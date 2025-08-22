-- Post-Migration Verification Queries
-- Medical Center Platform Migration Tool
-- 
-- This file contains SQL queries to verify that the migration from old_moh to new_moh
-- was successful. Run these queries after completing the migration to ensure data
-- integrity and completeness.
--
-- Usage:
--   mysql -u username -p new_moh < post_migration_checks.sql
--   OR run individual queries in your database client
--
-- Generated: 2025-01-27
-- Migration Tool Version: 1.0.0

-- =============================================================================
-- 1. RECORD COUNT VERIFICATION
-- =============================================================================

-- Check total record counts in key tables
SELECT '=== RECORD COUNT VERIFICATION ===' as section;

-- Users table (staff only)
SELECT 
    'Users (Staff)' as entity,
    COUNT(*) as total_count,
    COUNT(CASE WHEN type = 'DOCTOR' THEN 1 END) as doctors,
    COUNT(CASE WHEN type = 'ADMIN' THEN 1 END) as admins,
    COUNT(CASE WHEN type = 'SECRETARY' THEN 1 END) as secretaries,
    COUNT(CASE WHEN type = 'NURSE' THEN 1 END) as nurses,
    COUNT(CASE WHEN type = 'SUPER_ADMIN' THEN 1 END) as super_admins
FROM users;

-- Patients table
SELECT 
    'Patients' as entity,
    COUNT(*) as total_count,
    COUNT(CASE WHEN gender = 'MALE' THEN 1 END) as male_patients,
    COUNT(CASE WHEN gender = 'FEMALE' THEN 1 END) as female_patients,
    COUNT(CASE WHEN phone_number IS NOT NULL THEN 1 END) as with_phone,
    COUNT(CASE WHEN phone_number IS NULL THEN 1 END) as without_phone
FROM patients;

-- Summary comparison
SELECT 
    'Summary' as check_type,
    (SELECT COUNT(*) FROM users) as staff_users,
    (SELECT COUNT(*) FROM patients) as patients,
    (SELECT COUNT(*) FROM users) + (SELECT COUNT(*) FROM patients) as total_migrated,
    'Verify this matches original users count' as note;

-- =============================================================================
-- 2. FOREIGN KEY INTEGRITY CHECKS
-- =============================================================================

SELECT '=== FOREIGN KEY INTEGRITY CHECKS ===' as section;

-- Check for orphaned foreign keys in appointments
SELECT 
    'Appointments - NULL patient_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM appointments 
WHERE patient_id IS NULL;

SELECT 
    'Appointments - NULL doctor_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM appointments 
WHERE doctor_id IS NULL;

-- Check for orphaned foreign keys in visits
SELECT 
    'Visits - NULL patient_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM visits 
WHERE patient_id IS NULL;

SELECT 
    'Visits - NULL doctor_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM visits 
WHERE doctor_id IS NULL;

-- Check for orphaned foreign keys in medical cases
SELECT 
    'Medical Cases - NULL patient_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM medical_cases 
WHERE patient_id IS NULL;

-- Check for orphaned foreign keys in verification codes
SELECT 
    'Verification Codes - NULL patient_id' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM verification_codes 
WHERE patient_id IS NULL;

-- =============================================================================
-- 3. REFERENTIAL INTEGRITY VERIFICATION
-- =============================================================================

SELECT '=== REFERENTIAL INTEGRITY VERIFICATION ===' as section;

-- Verify appointments have valid patient references
SELECT 
    'Appointments with valid patient_id' as check_name,
    COUNT(*) as count,
    'Should match total appointments' as expected
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id;

-- Verify appointments have valid doctor references
SELECT 
    'Appointments with valid doctor_id' as check_name,
    COUNT(*) as count,
    'Should match total appointments' as expected
FROM appointments a
JOIN users u ON a.doctor_id = u.id;

-- Verify visits have valid patient references
SELECT 
    'Visits with valid patient_id' as check_name,
    COUNT(*) as count,
    'Should match total visits' as expected
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id;

-- Verify visits have valid doctor references (where doctor_id is not null)
SELECT 
    'Visits with valid doctor_id' as check_name,
    COUNT(*) as count,
    'Should match visits with doctor_id' as expected
FROM visits v
JOIN users u ON v.doctor_id = u.id
WHERE v.doctor_id IS NOT NULL;

-- Verify medical cases have valid patient references
SELECT 
    'Medical Cases with valid patient_id' as check_name,
    COUNT(*) as count,
    'Should match total medical cases' as expected
FROM medical_cases mc
JOIN patients p ON mc.patient_id = p.patient_id;

-- =============================================================================
-- 4. DATA QUALITY CHECKS
-- =============================================================================

SELECT '=== DATA QUALITY CHECKS ===' as section;

-- Check for duplicate emails in users table
SELECT 
    'Duplicate emails in users' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM (
    SELECT email, COUNT(*) as cnt 
    FROM users 
    WHERE email IS NOT NULL 
    GROUP BY email 
    HAVING COUNT(*) > 1
) as duplicates;

-- Check for duplicate phone numbers in patients table
SELECT 
    'Duplicate phone numbers in patients' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM (
    SELECT phone_number, COUNT(*) as cnt 
    FROM patients 
    WHERE phone_number IS NOT NULL 
    GROUP BY phone_number 
    HAVING COUNT(*) > 1
) as duplicates;

-- Check for invalid email formats
SELECT 
    'Users with invalid email format' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM users 
WHERE email IS NOT NULL 
AND email NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';

-- Check for invalid phone number formats
SELECT 
    'Patients with invalid phone format' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM patients 
WHERE phone_number IS NOT NULL 
AND phone_number NOT REGEXP '^\\+?[1-9]\\d{1,14}$';

-- =============================================================================
-- 5. DATA CONSISTENCY CHECKS
-- =============================================================================

SELECT '=== DATA CONSISTENCY CHECKS ===' as section;

-- Check for patients with valid phone numbers
SELECT 
    'Patients with valid phone numbers' as check_name,
    COUNT(*) as count,
    'Should be > 0' as expected
FROM patients 
WHERE phone_number IS NOT NULL 
AND phone_number != '';

-- Check for users with valid emails
SELECT 
    'Users with valid emails' as check_name,
    COUNT(*) as count,
    'Should be > 0' as expected
FROM users 
WHERE email IS NOT NULL 
AND email != '';

-- Check for consistent gender values
SELECT 
    'Users with valid gender values' as check_name,
    COUNT(*) as count,
    'Should match total users' as expected
FROM users 
WHERE gender IN ('MALE', 'FEMALE');

SELECT 
    'Patients with valid gender values' as check_name,
    COUNT(*) as count,
    'Should match total patients' as expected
FROM patients 
WHERE gender IN ('MALE', 'FEMALE');

-- =============================================================================
-- 6. AUDIT TRAIL VERIFICATION
-- =============================================================================

SELECT '=== AUDIT TRAIL VERIFICATION ===' as section;

-- Check for users with audit timestamps
SELECT 
    'Users with created_at' as check_name,
    COUNT(*) as count,
    'Should match total users' as expected
FROM users 
WHERE created_at IS NOT NULL;

SELECT 
    'Users with updated_at' as check_name,
    COUNT(*) as count,
    'Should be > 0' as expected
FROM users 
WHERE updated_at IS NOT NULL;

-- Check for patients with audit timestamps
SELECT 
    'Patients with created_at' as check_name,
    COUNT(*) as count,
    'Should match total patients' as expected
FROM patients 
WHERE created_at IS NOT NULL;

SELECT 
    'Patients with updated_at' as check_name,
    COUNT(*) as count,
    'Should be > 0' as expected
FROM patients 
WHERE updated_at IS NOT NULL;

-- Check for soft-deleted records
SELECT 
    'Users with deleted_at' as check_name,
    COUNT(*) as count,
    'Should match original soft-deleted count' as expected
FROM users 
WHERE deleted_at IS NOT NULL;

SELECT 
    'Patients with deleted_at' as check_name,
    COUNT(*) as count,
    'Should match original soft-deleted count' as expected
FROM patients 
WHERE deleted_at IS NOT NULL;

-- =============================================================================
-- 7. BUSINESS LOGIC VERIFICATION
-- =============================================================================

SELECT '=== BUSINESS LOGIC VERIFICATION ===' as section;

-- Verify no patients exist in users table
SELECT 
    'Users with PATIENT type (should be 0)' as check_name,
    COUNT(*) as count,
    'Should be 0' as expected
FROM users 
WHERE type = 'PATIENT';

-- Verify all staff types are present in users table
SELECT 
    'Staff type distribution' as check_name,
    type,
    COUNT(*) as count
FROM users 
GROUP BY type
ORDER BY type;

-- Verify patient data completeness
SELECT 
    'Patients with complete basic info' as check_name,
    COUNT(*) as count,
    'Should be > 0' as expected
FROM patients 
WHERE first_name IS NOT NULL 
AND last_name IS NOT NULL 
AND phone_number IS NOT NULL;

-- =============================================================================
-- 8. PERFORMANCE AND INDEX CHECKS
-- =============================================================================

SELECT '=== PERFORMANCE AND INDEX CHECKS ===' as section;

-- Check table sizes
SELECT 
    'Table sizes' as check_name,
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = DATABASE()
AND table_name IN ('users', 'patients', 'appointments', 'visits', 'medical_cases')
ORDER BY table_name;

-- Check for missing indexes on foreign key columns
SELECT 
    'Missing indexes on FK columns' as check_name,
    'Check manually: appointments.patient_id, appointments.doctor_id, visits.patient_id, visits.doctor_id' as recommendation;

-- =============================================================================
-- 9. CROSSWALK VERIFICATION
-- =============================================================================

SELECT '=== CROSSWALK VERIFICATION ===' as section;

-- This section requires the crosswalk CSV files to be imported into temporary tables
-- You can create these tables manually or import the CSV files

-- Example: Create crosswalk verification table
-- CREATE TEMPORARY TABLE crosswalk_verification (
--     old_user_id BIGINT,
--     new_entity_type ENUM('user', 'patient'),
--     new_entity_id VARCHAR(36)
-- );

-- Load crosswalk data and verify
SELECT 
    'Crosswalk verification' as check_name,
    'Import crosswalk CSV files and verify all old user IDs are mapped' as instruction;

-- =============================================================================
-- 10. FINAL SUMMARY
-- =============================================================================

SELECT '=== FINAL SUMMARY ===' as section;

-- Overall migration success indicators
SELECT 
    'Migration Success Indicators' as check_name,
    CASE 
        WHEN (SELECT COUNT(*) FROM users) + (SELECT COUNT(*) FROM patients) > 0 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END as user_migration,
    CASE 
        WHEN (SELECT COUNT(*) FROM appointments WHERE patient_id IS NULL) = 0 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END as fk_integrity,
    CASE 
        WHEN (SELECT COUNT(*) FROM users WHERE type = 'PATIENT') = 0 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END as user_separation,
    'Review all results above' as next_steps;

-- =============================================================================
-- NOTES AND RECOMMENDATIONS
-- =============================================================================

/*
MIGRATION VERIFICATION NOTES:

1. **Record Counts**: 
   - Total migrated records (users + patients) should equal original users count
   - Any discrepancy indicates data loss or duplication

2. **Foreign Key Integrity**:
   - All NULL foreign key counts should be 0 (unless the field is nullable by design)
   - All referential integrity checks should pass

3. **Data Quality**:
   - No duplicate emails or phone numbers
   - All email and phone formats should be valid
   - Gender values should be consistent

4. **Business Logic**:
   - No patients should exist in the users table
   - All staff types should be properly categorized
   - Audit trails should be preserved

5. **Performance**:
   - Check table sizes are reasonable
   - Ensure proper indexes exist on foreign key columns
   - Monitor query performance

6. **Next Steps**:
   - If all checks pass: Migration successful
   - If any checks fail: Investigate and resolve issues
   - Run these checks periodically to ensure ongoing data integrity

7. **Rollback Plan**:
   - Keep original database backup
   - Document any manual fixes applied
   - Test application functionality thoroughly

8. **Monitoring**:
   - Set up alerts for data quality issues
   - Monitor application performance
   - Track any data anomalies

For questions or issues, refer to the migration tool documentation or contact your database administration team.
*/