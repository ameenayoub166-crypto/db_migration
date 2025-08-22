#!/usr/bin/env python3
"""
Test script for Medical Center Platform Migration Tool

This script demonstrates how to test the migration tool using the provided SQL dump files.
It sets up temporary databases and runs a dry-run migration.

Usage:
    python test_migration.py

Requirements:
    - MySQL/MariaDB server running locally
    - Python 3.10+
    - Required packages: pip install -r requirements-minimal.txt
"""

import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

def check_dependencies():
    """Check if required dependencies are installed."""
    try:
        import pymysql
        import sqlalchemy
        import yaml
        print("✓ All required dependencies are installed")
        return True
    except ImportError as e:
        print(f"✗ Missing dependency: {e}")
        print("Please install: pip install -r requirements-minimal.txt")
        return False

def check_mysql_connection():
    """Check if MySQL server is accessible."""
    try:
        import pymysql
        # Try to connect to MySQL
        conn = pymysql.connect(
            host='localhost',
            user='root',
            password='',
            port=3306,
            connect_timeout=5
        )
        conn.close()
        print("✓ MySQL server is accessible")
        return True
    except Exception as e:
        print(f"✗ Cannot connect to MySQL: {e}")
        print("Please ensure MySQL server is running and accessible")
        return False

def setup_test_databases():
    """Set up test databases from SQL dump files."""
    print("\nSetting up test databases...")
    
    # Check if SQL dump files exist
    old_moh_sql = Path("old_moh.sql")
    new_moh_sql = Path("new_moh.sql")
    
    if not old_moh_sql.exists():
        print("✗ old_moh.sql not found")
        return False
    
    if not new_moh_sql.exists():
        print("✗ new_moh.sql not found")
        return False
    
    try:
        # Create old_moh database
        print("Creating old_moh database...")
        subprocess.run([
            "mysql", "-u", "root", "-e", "CREATE DATABASE IF NOT EXISTS old_moh;"
        ], check=True, capture_output=True)
        
        # Load old_moh data
        print("Loading old_moh data...")
        subprocess.run([
            "mysql", "-u", "root", "old_moh", "<", "old_moh.sql"
        ], check=True, shell=True, capture_output=True)
        
        # Create new_moh database
        print("Creating new_moh database...")
        subprocess.run([
            "mysql", "-u", "root", "-e", "CREATE DATABASE IF NOT EXISTS new_moh;"
        ], check=True, capture_output=True)
        
        # Load new_moh data
        print("Loading new_moh data...")
        subprocess.run([
            "mysql", "-u", "root", "new_moh", "<", "new_moh.sql"
        ], check=True, shell=True, capture_output=True)
        
        print("✓ Test databases created successfully")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"✗ Failed to create test databases: {e}")
        return False

def create_test_config():
    """Create test configuration files."""
    print("\nCreating test configuration files...")
    
    # Create config.yaml
    config_content = """# Test configuration for Medical Center Migration Tool
old_db_url: "mysql+pymysql://root@localhost:3306/old_moh"
new_db_url: "mysql+pymysql://root@localhost:3306/new_moh"
batch_size: 1000
disable_fk_checks: true
backup_before_migration: false
log_level: "INFO"
"""
    
    with open("config.yaml", "w") as f:
        f.write(config_content)
    
    # Create mapping.yaml
    mapping_content = """# Test mapping configuration
roles_staff:
  - "DOCTOR"
  - "ADMIN"
  - "SECRETARY"
  - "NURSE"
  - "SUPER_ADMIN"

roles_patients:
  - "PATIENT"

role_aliases:
  "dr": "DOCTOR"
  "administrator": "ADMIN"

genders:
  "male": "MALE"
  "female": "FEMALE"
  "m": "MALE"
  "f": "FEMALE"

statuses:
  "active": "ACTIVE"
  "inactive": "INACTIVE"
"""
    
    with open("mapping.yaml", "w") as f:
        f.write(mapping_content)
    
    print("✓ Test configuration files created")

def run_dry_run():
    """Run the migration tool in dry-run mode."""
    print("\nRunning migration tool in dry-run mode...")
    
    try:
        # Run the migration tool
        result = subprocess.run([
            "python", "migrate.py",
            "--config", "config.yaml",
            "--mapping", "mapping.yaml",
            "--dry-run",
            "--verbose"
        ], check=True, capture_output=True, text=True)
        
        print("✓ Dry-run completed successfully")
        print("\nOutput:")
        print(result.stdout)
        
        if result.stderr:
            print("\nWarnings/Errors:")
            print(result.stderr)
        
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"✗ Dry-run failed: {e}")
        print(f"Error output: {e.stderr}")
        return False

def cleanup_test_databases():
    """Clean up test databases."""
    print("\nCleaning up test databases...")
    
    try:
        subprocess.run([
            "mysql", "-u", "root", "-e", "DROP DATABASE IF EXISTS old_moh;"
        ], check=True, capture_output=True)
        
        subprocess.run([
            "mysql", "-u", "root", "-e", "DROP DATABASE IF EXISTS new_moh;"
        ], check=True, capture_output=True)
        
        print("✓ Test databases cleaned up")
        
    except subprocess.CalledProcessError as e:
        print(f"⚠ Warning: Could not clean up databases: {e}")

def main():
    """Main test function."""
    print("Medical Center Platform Migration Tool - Test Script")
    print("=" * 55)
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Check MySQL connection
    if not check_mysql_connection():
        sys.exit(1)
    
    # Set up test databases
    if not setup_test_databases():
        print("Failed to set up test databases. Exiting.")
        sys.exit(1)
    
    # Create test configuration
    create_test_config()
    
    # Run dry-run migration
    if not run_dry_run():
        print("Dry-run failed. Exiting.")
        cleanup_test_databases()
        sys.exit(1)
    
    # Show generated files
    print("\nGenerated files:")
    files_to_check = [
        "schema_diff.md",
        "post_migration_checks.sql",
        "reports/migration_plan.json"
    ]
    
    for file_path in files_to_check:
        if Path(file_path).exists():
            print(f"✓ {file_path}")
        else:
            print(f"✗ {file_path} (not found)")
    
    # Clean up
    cleanup_test_databases()
    
    print("\n" + "=" * 55)
    print("Test completed successfully!")
    print("\nNext steps:")
    print("1. Review the generated schema_diff.md")
    print("2. Check the migration plan in reports/migration_plan.json")
    print("3. Review post_migration_checks.sql")
    print("4. Update config.yaml with your actual database credentials")
    print("5. Run the actual migration when ready")

if __name__ == "__main__":
    main()