# Medical Center Platform Migration Tool

A comprehensive Python-based migration tool for migrating data from the old medical center platform (v1) to the new platform (v2). This tool handles the complex task of separating a single `users` table into distinct `users` (staff) and `patients` tables while maintaining data integrity and referential consistency.

## Overview

### What This Tool Does

The migration tool performs the following key operations:

1. **Schema Analysis**: Introspects both old and new database schemas to identify differences
2. **User Separation**: Splits the v1 `users` table into:
   - `users` table: Staff members (doctors, admins, secretaries, nurses)
   - `patients` table: Patient data with enhanced medical information
3. **Foreign Key Rewiring**: Updates all related tables to point to the correct entity type
4. **Data Validation**: Ensures data integrity and generates comprehensive reports
5. **Crosswalk Generation**: Creates mapping files for audit trails

### Key Changes from v1 to v2

- **v1 (old_moh)**: Single `users` table containing all user types
- **v2 (new_moh)**: Separate `users` (staff) and `patients` tables
- **Data Types**: Some columns changed from `bigint` to `char(36)` (UUID) for patient IDs
- **Enhanced Patient Data**: New patient table includes additional medical and demographic fields

## Prerequisites

### System Requirements

- Python 3.10 or higher
- MySQL/MariaDB or PostgreSQL database access
- Sufficient disk space for backups and reports
- Network access to both source and target databases

### Python Dependencies

```bash
pip install pymysql sqlalchemy pyyaml
```

### Database Access

- Read access to the source database (old_moh)
- Read/Write access to the target database (new_moh)
- Ability to disable foreign key checks (recommended for performance)

## Installation

1. **Clone or download** the migration tool files
2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
3. **Create configuration files**:
   ```bash
   cp config.example.yaml config.yaml
   cp mapping.example.yaml mapping.yaml
   ```
4. **Update configuration** with your database connection details

## Configuration

### 1. Database Connection (config.yaml)

```yaml
# MySQL over TCP
old_db_url: "mysql+pymysql://username:password@localhost:3306/old_moh"
new_db_url: "mysql+pymysql://username:password@localhost:3306/new_moh"

# MySQL over Unix socket
old_db_url: "mysql+pymysql://username:password@/old_moh?unix_socket=/var/run/mysqld/mysqld.sock"

# Docker containers
old_db_url: "mysql+pymysql://username:password@host.docker.internal:3306/old_moh"
```

### 2. Migration Settings (config.yaml)

```yaml
batch_size: 5000                    # Records per batch
disable_fk_checks: true            # Recommended for performance
backup_before_migration: true      # Safety first
log_level: "INFO"                  # Logging verbosity
```

### 3. Data Mapping (mapping.yaml)

```yaml
# Define staff vs patient roles
roles_staff:
  - "DOCTOR"
  - "ADMIN"
  - "SECRETARY"
  - "NURSE"
  - "SUPER_ADMIN"

roles_patients:
  - "PATIENT"
```

## Usage

### Basic Commands

#### 1. Dry Run (Recommended First Step)

```bash
python migrate.py --config config.yaml --mapping mapping.yaml --dry-run
```

This will:
- Analyze both schemas
- Generate `schema_diff.md`
- Create migration plan
- Generate post-migration SQL
- **No data will be modified**

#### 2. Actual Migration

```bash
python migrate.py --config config.yaml --mapping mapping.yaml
```

This will:
- Perform the actual data migration
- Generate crosswalk reports
- Validate results
- Create comprehensive reports

#### 3. Verbose Mode

```bash
python migrate.py --config config.yaml --mapping mapping.yaml --verbose
```

### Advanced Options

```bash
# Custom batch size
python migrate.py --config config.yaml --mapping mapping.yaml --batch-size 1000

# Limit records (useful for testing)
python migrate.py --config config.yaml --mapping mapping.yaml --limit 100

# Dry run with custom config
python migrate.py --config config.yaml --mapping mapping.yaml --dry-run --verbose
```

## Migration Process

### Phase 1: Schema Analysis
- Connects to both databases
- Analyzes table structures, columns, and relationships
- Identifies foreign key changes needed
- Generates `schema_diff.md` report

### Phase 2: User Migration
- Reads all users from v1 `users` table
- Separates users by role (staff vs patient)
- Migrates staff users to new `users` table
- Migrates patient users to new `patients` table
- Generates crosswalk files

### Phase 3: Foreign Key Rewiring
- Updates all related tables to use correct entity references
- Handles `user_id` → `patient_id` conversions
- Maintains referential integrity
- Updates tables: appointments, visits, medical_cases, etc.

### Phase 4: Validation
- Counts records in all tables
- Checks foreign key integrity
- Validates data quality
- Generates validation report

## Output Files

### Reports Directory (`reports/`)

- `old_user_id__to__new_user_id.csv` - Staff user ID mappings
- `old_user_id__to__new_patient_id.csv` - Patient ID mappings
- `migration_plan.json` - Detailed migration plan
- `validation_report.json` - Post-migration validation results

### Root Directory

- `schema_diff.md` - Schema differences analysis
- `post_migration_checks.sql` - SQL queries for verification
- `migration.log` - Detailed migration log
- `validation_report.json` - Validation results

## Safety Features

### Backup and Rollback

- **Automatic Backup**: Creates backup before migration (if enabled)
- **Transaction Safety**: Uses database transactions for data consistency
- **Checkpoint System**: Can resume interrupted migrations
- **Validation**: Comprehensive post-migration checks

### Error Handling

- **Graceful Degradation**: Continues migration on non-critical errors
- **Detailed Logging**: Logs all operations and errors
- **Rollback Support**: Can rollback changes if needed
- **Data Integrity**: Maintains referential consistency

## Verification

### Post-Migration Checks

1. **Run the generated SQL**:
   ```bash
   mysql -u username -p new_moh < post_migration_checks.sql
   ```

2. **Check the validation report**:
   ```bash
   cat validation_report.json
   ```

3. **Verify crosswalks**:
   ```bash
   head -10 reports/old_user_id__to__new_user_id.csv
   head -10 reports/old_user_id__to__new_patient_id.csv
   ```

### Key Validation Points

- **Record Counts**: Total users + patients should equal original users
- **Foreign Keys**: No orphaned references
- **Data Quality**: No duplicate emails/phones
- **Audit Trail**: All timestamps preserved

## Troubleshooting

### Common Issues

#### 1. Connection Errors

```bash
# Check database connectivity
mysql -u username -p -h hostname -P 3306 old_moh -e "SELECT 1"
mysql -u username -p -h hostname -P 3306 new_moh -e "SELECT 1"
```

#### 2. Permission Errors

```sql
-- Grant necessary permissions
GRANT SELECT ON old_moh.* TO 'migration_user'@'%';
GRANT SELECT, INSERT, UPDATE ON new_moh.* TO 'migration_user'@'%';
```

#### 3. Foreign Key Constraint Errors

```sql
-- Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;
-- Run migration
SET FOREIGN_KEY_CHECKS = 1;
```

### Debug Mode

```bash
# Enable debug logging
export PYTHONPATH=.
python migrate.py --config config.yaml --mapping mapping.yaml --verbose --dry-run
```

## Performance Optimization

### Database Tuning

```sql
-- Increase buffer pool size
SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB

-- Optimize for bulk operations
SET SESSION innodb_flush_log_at_trx_commit = 2;
SET SESSION innodb_doublewrite = 0;
```

### Migration Settings

```yaml
# Optimize for large datasets
batch_size: 10000
max_workers: 8
bulk_insert_size: 2000
disable_fk_checks: true
```

## Examples

### Example 1: Local Development

```bash
# Setup local databases
mysql -u root -p < old_moh.sql
mysql -u root -p < new_moh.sql

# Configure local connections
# config.yaml
old_db_url: "mysql+pymysql://root:password@localhost:3306/old_moh"
new_db_url: "mysql+pymysql://root:password@localhost:3306/new_moh"

# Run dry-run
python migrate.py --config config.yaml --mapping mapping.yaml --dry-run
```

### Example 2: Production Migration

```bash
# 1. Backup production data
mysqldump -u username -p --single-transaction old_moh > old_moh_backup.sql

# 2. Run dry-run first
python migrate.py --config config.yaml --mapping mapping.yaml --dry-run

# 3. Review reports and plan
cat schema_diff.md
cat reports/migration_plan.json

# 4. Execute migration
python migrate.py --config config.yaml --mapping mapping.yaml

# 5. Verify results
mysql -u username -p new_moh < post_migration_checks.sql
```

### Example 3: Docker Environment

```bash
# Docker Compose setup
docker-compose up -d mysql-old mysql-new

# Wait for databases to be ready
sleep 30

# Run migration
python migrate.py --config config.yaml --mapping mapping.yaml --dry-run
```

## Monitoring and Logging

### Log Files

- `migration.log` - Main migration log
- Console output - Real-time progress
- JSON reports - Structured data for analysis

### Key Metrics

- Records processed per second
- Error rates
- Memory usage
- Database connection status

### Alerting

Monitor these conditions:
- High error rates
- Long-running operations
- Database connection failures
- Disk space usage

## Security Considerations

### Data Protection

- **PII Logging**: Disabled by default
- **Password Handling**: Never logs password hashes
- **Connection Security**: Use SSL for remote connections
- **Access Control**: Minimal required permissions

### Network Security

```yaml
# Use SSL connections
old_db_url: "mysql+pymysql://user:pass@host:3306/old_moh?ssl_ca=/path/to/ca.pem"
new_db_url: "mysql+pymysql://user:pass@host:3306/new_moh?ssl_ca=/path/to/ca.pem"
```

## Support and Maintenance

### Post-Migration Tasks

1. **Update Application Code**: Point to new database schema
2. **Update Connection Strings**: Use new database URLs
3. **Test Functionality**: Verify all features work correctly
4. **Monitor Performance**: Watch for any performance issues
5. **Archive Old Data**: Keep backups for compliance

### Maintenance

- **Regular Validation**: Run verification queries periodically
- **Performance Monitoring**: Track query performance
- **Data Quality**: Monitor for data anomalies
- **Backup Strategy**: Maintain regular backups

## Contributing

### Development Setup

```bash
# Clone repository
git clone <repository-url>
cd medical-center-migration

# Install development dependencies
pip install -r requirements-dev.txt

# Run tests
python -m pytest tests/

# Code formatting
black migrate.py
isort migrate.py
```

### Testing

```bash
# Run unit tests
python -m pytest tests/unit/

# Run integration tests
python -m pytest tests/integration/

# Run with coverage
python -m pytest --cov=migrate tests/
```

## License

This tool is provided as-is for medical center platform migrations. Please ensure compliance with your organization's data handling policies and regulations.

## Contact

For support or questions about this migration tool, please contact your database administration team or the development team responsible for the medical center platform.

---

**Important**: Always test migrations in a non-production environment first. This tool handles sensitive medical data and should be used with appropriate care and testing.