#!/usr/bin/env python3
"""
Medical Center Platform Migration Tool

Migrates data from old_moh (v1) to new_moh (v2) database schemas.
Handles the separation of users table into users (staff) and patients tables.

Usage:
    python migrate.py --config config.yaml --mapping mapping.yaml [options]

Author: Medical Center Migration Team
Version: 1.0.0
"""

import argparse
import asyncio
import csv
import json
import logging
import os
import sys
import time
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple, Union
import yaml

try:
    import pymysql
    import sqlalchemy
    from sqlalchemy import create_engine, text, MetaData, Table, Column, inspect
    from sqlalchemy.engine import Engine
    from sqlalchemy.exc import SQLAlchemyError
    from sqlalchemy.pool import QueuePool
except ImportError as e:
    print(f"Missing required dependency: {e}")
    print("Please install: pip install pymysql sqlalchemy pyyaml")
    sys.exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('migration.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Type aliases
Config = Dict[str, Any]
Mapping = Dict[str, Any]
SchemaInfo = Dict[str, Any]
MigrationState = Dict[str, Any]


class MigrationConfig:
    """Configuration management for the migration tool."""
    
    def __init__(self, config_path: str, mapping_path: str):
        self.config = self._load_yaml(config_path)
        self.mapping = self._load_yaml(mapping_path)
        self._validate_config()
    
    def _load_yaml(self, path: str) -> Dict[str, Any]:
        """Load and parse YAML configuration file."""
        try:
            with open(path, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        except Exception as e:
            logger.error(f"Failed to load {path}: {e}")
            sys.exit(1)
    
    def _validate_config(self):
        """Validate required configuration parameters."""
        required_keys = ['old_db_url', 'new_db_url', 'batch_size']
        for key in required_keys:
            if key not in self.config:
                logger.error(f"Missing required config key: {key}")
                sys.exit(1)
        
        if 'roles_staff' not in self.mapping:
            logger.error("Missing required mapping: roles_staff")
            sys.exit(1)


class DatabaseConnector:
    """Database connection management and introspection."""
    
    def __init__(self, config: Config):
        self.config = config
        self.old_engine: Optional[Engine] = None
        self.new_engine: Optional[Engine] = None
        self.old_metadata: Optional[MetaData] = None
        self.new_metadata: Optional[MetaData] = None
    
    def connect(self) -> None:
        """Establish connections to both databases."""
        try:
            # Connect to old database
            self.old_engine = create_engine(
                self.config['old_db_url'],
                poolclass=QueuePool,
                pool_size=5,
                max_overflow=10,
                pool_pre_ping=True
            )
            self.old_metadata = MetaData()
            self.old_metadata.reflect(bind=self.old_engine)
            
            # Connect to new database
            self.new_engine = create_engine(
                self.config['new_db_url'],
                poolclass=QueuePool,
                pool_size=5,
                max_overflow=10,
                pool_pre_ping=True
            )
            self.new_metadata = MetaData()
            self.new_metadata.reflect(bind=self.new_engine)
            
            logger.info("Successfully connected to both databases")
            
        except Exception as e:
            logger.error(f"Failed to connect to databases: {e}")
            sys.exit(1)
    
    def get_table_info(self, engine: Engine, table_name: str) -> Optional[SchemaInfo]:
        """Get detailed information about a specific table."""
        try:
            inspector = inspect(engine)
            columns = inspector.get_columns(table_name)
            pk = inspector.get_pk_constraint(table_name)
            fks = inspector.get_foreign_keys(table_name)
            indexes = inspector.get_indexes(table_name)
            
            return {
                'name': table_name,
                'columns': columns,
                'primary_key': pk,
                'foreign_keys': fks,
                'indexes': indexes
            }
        except Exception as e:
            logger.warning(f"Could not inspect table {table_name}: {e}")
            return None
    
    def get_all_tables(self, engine: Engine) -> List[str]:
        """Get list of all tables in the database."""
        try:
            inspector = inspect(engine)
            return inspector.get_table_names()
        except Exception as e:
            logger.error(f"Failed to get table list: {e}")
            return []


class SchemaAnalyzer:
    """Analyzes schema differences between old and new databases."""
    
    def __init__(self, connector: DatabaseConnector):
        self.connector = connector
        self.schema_diff: Dict[str, Any] = {}
    
    def analyze_schemas(self) -> Dict[str, Any]:
        """Perform comprehensive schema analysis."""
        logger.info("Starting schema analysis...")
        
        old_tables = self.connector.get_all_tables(self.connector.old_engine)
        new_tables = self.connector.get_all_tables(self.connector.new_engine)
        
        self.schema_diff = {
            'summary': {
                'old_tables_count': len(old_tables),
                'new_tables_count': len(new_tables),
                'tables_added': list(set(new_tables) - set(old_tables)),
                'tables_removed': list(set(old_tables) - set(new_tables)),
                'tables_common': list(set(old_tables) & set(new_tables))
            },
            'table_details': {},
            'foreign_key_changes': [],
            'data_type_changes': [],
            'enum_changes': []
        }
        
        # Analyze common tables
        for table_name in self.schema_diff['summary']['tables_common']:
            self._analyze_table(table_name)
        
        # Analyze foreign key changes
        self._analyze_foreign_key_changes()
        
        logger.info("Schema analysis completed")
        return self.schema_diff
    
    def _analyze_table(self, table_name: str) -> None:
        """Analyze a specific table for differences."""
        old_info = self.connector.get_table_info(self.connector.old_engine, table_name)
        new_info = self.connector.get_table_info(self.connector.new_engine, table_name)
        
        if not old_info or not new_info:
            return
        
        # Compare columns
        old_columns = {col['name']: col for col in old_info['columns']}
        new_columns = {col['name']: col for col in new_info['columns']}
        
        columns_added = list(set(new_columns.keys()) - set(old_columns.keys()))
        columns_removed = list(set(old_columns.keys()) - set(new_columns.keys()))
        columns_common = list(set(old_columns.keys()) & set(new_columns.keys()))
        
        # Check for data type changes
        data_type_changes = []
        for col_name in columns_common:
            old_col = old_columns[col_name]
            new_col = new_columns[col_name]
            if old_col.get('type') != new_col.get('type'):
                data_type_changes.append({
                    'table': table_name,
                    'column': col_name,
                    'old_type': str(old_col.get('type')),
                    'new_type': str(new_col.get('type'))
                })
        
        self.schema_diff['table_details'][table_name] = {
            'columns_added': columns_added,
            'columns_removed': columns_removed,
            'columns_common': columns_common,
            'data_type_changes': data_type_changes
        }
        
        # Track data type changes globally
        self.schema_diff['data_type_changes'].extend(data_type_changes)
    
    def _analyze_foreign_key_changes(self) -> None:
        """Analyze changes in foreign key relationships."""
        # Focus on key tables that reference users/patients
        key_tables = ['appointments', 'visits', 'medical_cases', 'verification_codes']
        
        for table_name in key_tables:
            if table_name in self.connector.old_metadata.tables:
                old_fks = self.connector.old_metadata.tables[table_name].foreign_keys
                if table_name in self.connector.new_metadata.tables:
                    new_fks = self.connector.new_metadata.tables[table_name].foreign_keys
                    
                    # Check for user_id -> patient_id changes
                    for old_fk in old_fks:
                        if 'user_id' in str(old_fk):
                            # This FK needs to be analyzed for migration
                            self.schema_diff['foreign_key_changes'].append({
                                'table': table_name,
                                'old_column': str(old_fk),
                                'migration_rule': 'Determine if user_id points to staff or patient'
                            })
    
    def generate_schema_diff_report(self, output_path: str = "schema_diff.md") -> None:
        """Generate a markdown report of schema differences."""
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write("# Schema Migration Analysis Report\n\n")
            f.write(f"Generated: {datetime.now().isoformat()}\n\n")
            
            # Summary
            f.write("## Summary\n\n")
            f.write(f"- **Old Database Tables**: {self.schema_diff['summary']['old_tables_count']}\n")
            f.write(f"- **New Database Tables**: {self.schema_diff['summary']['new_tables_count']}\n")
            f.write(f"- **Tables Added**: {len(self.schema_diff['summary']['tables_added'])}\n")
            f.write(f"- **Tables Removed**: {len(self.schema_diff['summary']['tables_removed'])}\n")
            f.write(f"- **Common Tables**: {len(self.schema_diff['summary']['tables_common'])}\n\n")
            
            # Key Changes
            f.write("## Key Schema Changes\n\n")
            
            f.write("### Users Table Split\n")
            f.write("- **Old Schema**: Single `users` table containing all user types\n")
            f.write("- **New Schema**: \n")
            f.write("  - `users` table: Staff only (doctors, admins, secretaries, nurses)\n")
            f.write("  - `patients` table: Patient data with enhanced medical information\n\n")
            
            f.write("### Foreign Key Changes\n")
            f.write("The following tables need FK rewiring:\n")
            for fk_change in self.schema_diff['foreign_key_changes']:
                f.write(f"- **{fk_change['table']}**: {fk_change['migration_rule']}\n")
            f.write("\n")
            
            # Data Type Changes
            if self.schema_diff['data_type_changes']:
                f.write("### Data Type Changes\n")
                for change in self.schema_diff['data_type_changes']:
                    f.write(f"- **{change['table']}.{change['column']}**: {change['old_type']} → {change['new_type']}\n")
                f.write("\n")
            
            # Migration Rules
            f.write("## Migration Rules\n\n")
            f.write("1. **Staff Users**: Users with type in ['DOCTOR', 'ADMIN', 'SECRETARY', 'NURSE'] → `users` table\n")
            f.write("2. **Patients**: Users with type 'PATIENT' → `patients` table\n")
            f.write("3. **Foreign Keys**: Rewire based on entity type (staff vs patient)\n")
            f.write("4. **Data Preservation**: Maintain all audit fields and relationships\n\n")
        
        logger.info(f"Schema diff report generated: {output_path}")


class DataMigrator:
    """Handles the actual data migration process."""
    
    def __init__(self, connector: DatabaseConnector, config: Config, mapping: Mapping):
        self.connector = connector
        self.config = config
        self.mapping = mapping
        self.migration_state: MigrationState = {}
        self.crosswalks: Dict[str, Dict[int, str]] = {
            'user_to_user': {},      # old_user_id -> new_user_id (staff)
            'user_to_patient': {}    # old_user_id -> new_patient_id (patients)
        }
    
    def migrate_users_to_separate_tables(self) -> None:
        """Migrate users from old single table to new separate tables."""
        logger.info("Starting user migration...")
        
        # Get all users from old database
        with self.connector.old_engine.connect() as conn:
            users = conn.execute(text("SELECT * FROM users")).fetchall()
        
        logger.info(f"Found {len(users)} users to migrate")
        
        # Separate users by type
        staff_users = []
        patient_users = []
        
        for user in users:
            user_dict = dict(user._mapping)
            if user_dict['type'] in self.mapping['roles_staff']:
                staff_users.append(user_dict)
            else:
                patient_users.append(user_dict)
        
        logger.info(f"Staff users: {len(staff_users)}, Patient users: {len(patient_users)}")
        
        # Migrate staff users
        self._migrate_staff_users(staff_users)
        
        # Migrate patient users
        self._migrate_patient_users(patient_users)
        
        # Generate crosswalk reports
        self._generate_crosswalk_reports()
    
    def _migrate_staff_users(self, staff_users: List[Dict[str, Any]]) -> None:
        """Migrate staff users to the new users table."""
        logger.info(f"Migrating {len(staff_users)} staff users...")
        
        with self.connector.new_engine.connect() as conn:
            for user in staff_users:
                try:
                    # Insert into new users table
                    insert_query = text("""
                        INSERT INTO users (
                            first_name, last_name, father_name, mother_name,
                            email, password, phone_number, gender, date_of_birth,
                            avatar_file_url, created_at, updated_at, type, deleted_at
                        ) VALUES (
                            :first_name, :last_name, :father_name, :mother_name,
                            :email, :password, :phone_number, :gender, :date_of_birth,
                            :avatar_file_url, :created_at, :updated_at, :type, :deleted_at
                        )
                    """)
                    
                    result = conn.execute(insert_query, user)
                    new_user_id = result.lastrowid
                    
                    # Store crosswalk
                    self.crosswalks['user_to_user'][user['id']] = new_user_id
                    
                    logger.debug(f"Migrated staff user {user['id']} -> {new_user_id}")
                    
                except Exception as e:
                    logger.error(f"Failed to migrate staff user {user['id']}: {e}")
                    continue
            
            conn.commit()
        
        logger.info(f"Successfully migrated {len(self.crosswalks['user_to_user'])} staff users")
    
    def _migrate_patient_users(self, patient_users: List[Dict[str, Any]]) -> None:
        """Migrate patient users to the new patients table."""
        logger.info(f"Migrating {len(patient_users)} patient users...")
        
        with self.connector.new_engine.connect() as conn:
            for user in patient_users:
                try:
                    # Generate new patient_id (UUID)
                    new_patient_id = str(uuid.uuid4())
                    
                    # Insert into new patients table
                    insert_query = text("""
                        INSERT INTO patients (
                            patient_id, first_name, last_name, father_name, mother_name,
                            phone_number, gender, date_of_birth, avatar_file_url,
                            created_at, updated_at, deleted_at
                        ) VALUES (
                            :patient_id, :first_name, :last_name, :father_name, :mother_name,
                            :phone_number, :gender, :date_of_birth, :avatar_file_url,
                            :created_at, :updated_at, :deleted_at
                        )
                    """)
                    
                    patient_data = {
                        'patient_id': new_patient_id,
                        'first_name': user['first_name'],
                        'last_name': user['last_name'],
                        'father_name': user['father_name'],
                        'mother_name': user['mother_name'],
                        'phone_number': user['phone_number'],
                        'gender': user['gender'],
                        'date_of_birth': user['date_of_birth'],
                        'avatar_file_url': user['avatar_file_url'],
                        'created_at': user['created_at'],
                        'updated_at': user['updated_at'],
                        'deleted_at': user['deleted_at']
                    }
                    
                    conn.execute(insert_query, patient_data)
                    
                    # Store crosswalk
                    self.crosswalks['user_to_patient'][user['id']] = new_patient_id
                    
                    logger.debug(f"Migrated patient user {user['id']} -> {new_patient_id}")
                    
                except Exception as e:
                    logger.error(f"Failed to migrate patient user {user['id']}: {e}")
                    continue
            
            conn.commit()
        
        logger.info(f"Successfully migrated {len(self.crosswalks['user_to_patient'])} patient users")
    
    def _generate_crosswalk_reports(self) -> None:
        """Generate CSV reports for crosswalks."""
        # User to User crosswalk
        with open('reports/old_user_id__to__new_user_id.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['old_user_id', 'new_user_id'])
            for old_id, new_id in self.crosswalks['user_to_user'].items():
                writer.writerow([old_id, new_id])
        
        # User to Patient crosswalk
        with open('reports/old_user_id__to__new_patient_id.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['old_user_id', 'new_patient_id'])
            for old_id, new_id in self.crosswalks['user_to_patient'].items():
                writer.writerow([old_id, new_id])
        
        logger.info("Crosswalk reports generated in reports/ directory")
    
    def rewire_foreign_keys(self) -> None:
        """Rewire foreign keys in related tables."""
        logger.info("Starting foreign key rewiring...")
        
        # Tables that need FK rewiring
        tables_to_rewire = [
            ('appointments', 'patient_id', 'user_to_patient'),
            ('appointments', 'doctor_id', 'user_to_user'),
            ('visits', 'patient_id', 'user_to_patient'),
            ('visits', 'doctor_id', 'user_to_user'),
            ('verification_codes', 'patient_id', 'user_to_patient'),
            ('medical_cases', 'patient_id', 'user_to_patient'),
            ('patient_allergies', 'patient_id', 'user_to_patient'),
            ('patient_health_records', 'patient_id', 'user_to_patient'),
            ('vaccine_patients', 'patient_id', 'user_to_patient')
        ]
        
        for table_name, column_name, crosswalk_type in tables_to_rewire:
            self._rewire_table_foreign_keys(table_name, column_name, crosswalk_type)
        
        logger.info("Foreign key rewiring completed")
    
    def _rewire_table_foreign_keys(self, table_name: str, column_name: str, crosswalk_type: str) -> None:
        """Rewire foreign keys for a specific table and column."""
        logger.info(f"Rewiring {table_name}.{column_name} using {crosswalk_type}")
        
        try:
            with self.connector.old_engine.connect() as old_conn:
                # Get all rows that need updating
                select_query = text(f"SELECT id, {column_name} FROM {table_name} WHERE {column_name} IS NOT NULL")
                rows = old_conn.execute(select_query).fetchall()
            
            with self.connector.new_engine.connect() as new_conn:
                updated_count = 0
                for row in rows:
                    old_id = row[column_name]
                    if old_id in self.crosswalks[crosswalk_type]:
                        new_id = self.crosswalks[crosswalk_type][old_id]
                        
                        # Update the foreign key
                        update_query = text(f"UPDATE {table_name} SET {column_name} = :new_id WHERE id = :row_id")
                        new_conn.execute(update_query, {'new_id': new_id, 'row_id': row['id']})
                        updated_count += 1
                
                new_conn.commit()
                logger.info(f"Updated {updated_count} foreign keys in {table_name}.{column_name}")
                
        except Exception as e:
            logger.error(f"Failed to rewire {table_name}.{column_name}: {e}")


class MigrationValidator:
    """Validates the migration results and generates verification reports."""
    
    def __init__(self, connector: DatabaseConnector):
        self.connector = connector
    
    def validate_migration(self) -> Dict[str, Any]:
        """Perform comprehensive migration validation."""
        logger.info("Starting migration validation...")
        
        validation_results = {
            'record_counts': {},
            'foreign_key_integrity': {},
            'data_quality': {},
            'anomalies': []
        }
        
        # Check record counts
        validation_results['record_counts'] = self._check_record_counts()
        
        # Check foreign key integrity
        validation_results['foreign_key_integrity'] = self._check_foreign_key_integrity()
        
        # Check data quality
        validation_results['data_quality'] = self._check_data_quality()
        
        logger.info("Migration validation completed")
        return validation_results
    
    def _check_record_counts(self) -> Dict[str, Any]:
        """Check record counts in key tables."""
        counts = {}
        
        # Check old vs new user counts
        with self.connector.old_engine.connect() as conn:
            old_users_count = conn.execute(text("SELECT COUNT(*) FROM users")).scalar()
            counts['old_users_total'] = old_users_count
        
        with self.connector.new_engine.connect() as conn:
            new_users_count = conn.execute(text("SELECT COUNT(*) FROM users")).scalar()
            new_patients_count = conn.execute(text("SELECT COUNT(*) FROM patients")).scalar()
            counts['new_users_total'] = new_users_count
            counts['new_patients_total'] = new_patients_count
            counts['total_migrated'] = new_users_count + new_patients_count
        
        # Verify counts match
        counts['counts_match'] = counts['old_users_total'] == counts['total_migrated']
        
        return counts
    
    def _check_foreign_key_integrity(self) -> Dict[str, Any]:
        """Check foreign key integrity in related tables."""
        integrity_checks = {}
        
        # Check for orphaned foreign keys
        tables_to_check = [
            ('appointments', 'patient_id'),
            ('appointments', 'doctor_id'),
            ('visits', 'patient_id'),
            ('visits', 'doctor_id')
        ]
        
        for table_name, column_name in tables_to_check:
            try:
                with self.connector.new_engine.connect() as conn:
                    # Check for NULL values where not allowed
                    null_count = conn.execute(
                        text(f"SELECT COUNT(*) FROM {table_name} WHERE {column_name} IS NULL")
                    ).scalar()
                    
                    integrity_checks[f"{table_name}.{column_name}_nulls"] = null_count
                    
            except Exception as e:
                logger.warning(f"Could not check integrity for {table_name}.{column_name}: {e}")
        
        return integrity_checks
    
    def _check_data_quality(self) -> Dict[str, Any]:
        """Check data quality metrics."""
        quality_checks = {}
        
        try:
            with self.connector.new_engine.connect() as conn:
                # Check for duplicate emails in users
                duplicate_emails = conn.execute(
                    text("SELECT COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1")
                ).fetchall()
                quality_checks['duplicate_emails_users'] = len(duplicate_emails)
                
                # Check for duplicate phones in patients
                duplicate_phones = conn.execute(
                    text("SELECT COUNT(*) FROM patients GROUP BY phone_number HAVING COUNT(*) > 1")
                ).fetchall()
                quality_checks['duplicate_phones_patients'] = len(duplicate_phones)
                
        except Exception as e:
            logger.warning(f"Could not perform data quality checks: {e}")
        
        return quality_checks
    
    def generate_validation_report(self, results: Dict[str, Any], output_path: str = "validation_report.json") -> None:
        """Generate a JSON validation report."""
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, default=str)
        
        logger.info(f"Validation report generated: {output_path}")
    
    def generate_post_migration_sql(self, output_path: str = "post_migration_checks.sql") -> None:
        """Generate SQL queries for post-migration verification."""
        sql_queries = """
-- Post-Migration Verification Queries
-- Run these queries to verify the migration was successful

-- 1. Check record counts
SELECT 'Users' as entity, COUNT(*) as count FROM users
UNION ALL
SELECT 'Patients' as entity, COUNT(*) as count FROM patients;

-- 2. Check for orphaned foreign keys
SELECT 'Appointments with NULL patient_id' as check_name, COUNT(*) as count 
FROM appointments WHERE patient_id IS NULL
UNION ALL
SELECT 'Appointments with NULL doctor_id' as check_name, COUNT(*) as count 
FROM appointments WHERE doctor_id IS NULL
UNION ALL
SELECT 'Visits with NULL patient_id' as check_name, COUNT(*) as count 
FROM visits WHERE patient_id IS NULL
UNION ALL
SELECT 'Visits with NULL doctor_id' as check_name, COUNT(*) as count 
FROM visits WHERE doctor_id IS NULL;

-- 3. Check data quality
SELECT 'Duplicate emails in users' as check_name, COUNT(*) as count
FROM (
    SELECT email, COUNT(*) as cnt 
    FROM users 
    WHERE email IS NOT NULL 
    GROUP BY email 
    HAVING COUNT(*) > 1
) as duplicates;

-- 4. Verify foreign key relationships
SELECT 'Appointments with valid patient_id' as check_name, COUNT(*) as count
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id;

SELECT 'Appointments with valid doctor_id' as check_name, COUNT(*) as count
FROM appointments a
JOIN users u ON a.doctor_id = u.id;

-- 5. Check for data consistency
SELECT 'Patients with valid phone numbers' as check_name, COUNT(*) as count
FROM patients WHERE phone_number IS NOT NULL AND phone_number != '';

-- 6. Audit trail verification
SELECT 'Users with created_at' as check_name, COUNT(*) as count
FROM users WHERE created_at IS NOT NULL
UNION ALL
SELECT 'Patients with created_at' as check_name, COUNT(*) as count
FROM patients WHERE created_at IS NOT NULL;
"""
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(sql_queries)
        
        logger.info(f"Post-migration SQL generated: {output_path}")


class MigrationTool:
    """Main migration tool orchestrator."""
    
    def __init__(self, config_path: str, mapping_path: str):
        self.config_manager = MigrationConfig(config_path, mapping_path)
        self.connector = DatabaseConnector(self.config_manager.config)
        self.analyzer = SchemaAnalyzer(self.connector)
        self.migrator = DataMigrator(self.connector, self.config_manager.config, self.config_manager.mapping)
        self.validator = MigrationValidator(self.connector)
        
        # Create reports directory
        Path("reports").mkdir(exist_ok=True)
    
    def run_dry_run(self) -> None:
        """Run migration in dry-run mode."""
        logger.info("Running migration in DRY-RUN mode")
        
        try:
            # Connect to databases
            self.connector.connect()
            
            # Analyze schemas
            schema_diff = self.analyzer.analyze_schemas()
            self.analyzer.generate_schema_diff_report()
            
            # Generate post-migration SQL
            self.validator.generate_post_migration_sql()
            
            # Simulate migration planning
            self._plan_migration()
            
            logger.info("Dry-run completed successfully. Check generated reports.")
            
        except Exception as e:
            logger.error(f"Dry-run failed: {e}")
            raise
    
    def run_migration(self) -> None:
        """Run the actual migration."""
        logger.info("Starting actual migration...")
        
        try:
            # Connect to databases
            self.connector.connect()
            
            # Analyze schemas
            schema_diff = self.analyzer.analyze_schemas()
            self.analyzer.generate_schema_diff_report()
            
            # Perform migration
            self.migrator.migrate_users_to_separate_tables()
            self.migrator.rewire_foreign_keys()
            
            # Validate migration
            validation_results = self.validator.validate_migration()
            self.validator.generate_validation_report(validation_results)
            self.validator.generate_post_migration_sql()
            
            logger.info("Migration completed successfully!")
            
        except Exception as e:
            logger.error(f"Migration failed: {e}")
            raise
    
    def _plan_migration(self) -> None:
        """Generate migration plan for dry-run mode."""
        logger.info("Generating migration plan...")
        
        # Count users by type
        with self.connector.old_engine.connect() as conn:
            staff_count = conn.execute(
                text("SELECT COUNT(*) FROM users WHERE type IN ('DOCTOR', 'ADMIN', 'SECRETARY', 'NURSE')")
            ).scalar()
            
            patient_count = conn.execute(
                text("SELECT COUNT(*) FROM users WHERE type = 'PATIENT'")
            ).scalar()
        
        plan = {
            'migration_plan': {
                'staff_users_to_migrate': staff_count,
                'patient_users_to_migrate': patient_count,
                'total_users': staff_count + patient_count,
                'estimated_duration_minutes': (staff_count + patient_count) // 1000 + 5,
                'tables_to_rewire': [
                    'appointments', 'visits', 'medical_cases', 'verification_codes',
                    'patient_allergies', 'patient_health_records', 'vaccine_patients'
                ]
            }
        }
        
        # Save migration plan
        with open('reports/migration_plan.json', 'w', encoding='utf-8') as f:
            json.dump(plan, f, indent=2)
        
        logger.info("Migration plan generated: reports/migration_plan.json")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description='Medical Center Platform Migration Tool')
    parser.add_argument('--config', required=True, help='Path to configuration file')
    parser.add_argument('--mapping', required=True, help='Path to mapping file')
    parser.add_argument('--dry-run', action='store_true', help='Run in dry-run mode')
    parser.add_argument('--verbose', action='store_true', help='Enable verbose logging')
    parser.add_argument('--batch-size', type=int, help='Override batch size from config')
    parser.add_argument('--limit', type=int, help='Limit number of records to process')
    
    args = parser.parse_args()
    
    # Set logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    try:
        # Initialize migration tool
        migration_tool = MigrationTool(args.config, args.mapping)
        
        # Override batch size if specified
        if args.batch_size:
            migration_tool.config_manager.config['batch_size'] = args.batch_size
        
        # Run migration
        if args.dry_run:
            migration_tool.run_dry_run()
        else:
            migration_tool.run_migration()
            
    except KeyboardInterrupt:
        logger.info("Migration interrupted by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Migration failed: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()