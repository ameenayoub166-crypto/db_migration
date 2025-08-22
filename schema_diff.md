# Schema Migration Analysis Report

Generated: 2025-01-27T10:30:00

## Summary

- **Old Database Tables**: 25
- **New Database Tables**: 26
- **Tables Added**: 1
- **Tables Removed**: 0
- **Common Tables**: 25

## Key Schema Changes

### Users Table Split

- **Old Schema**: Single `users` table containing all user types
- **New Schema**: 
  - `users` table: Staff only (doctors, admins, secretaries, nurses)
  - `patients` table: Patient data with enhanced medical information

### Foreign Key Changes

The following tables need FK rewiring:

- **appointments**: Determine if user_id points to staff or patient
- **visits**: Determine if user_id points to staff or patient
- **medical_cases**: Determine if user_id points to staff or patient
- **verification_codes**: Determine if user_id points to staff or patient

### Data Type Changes

- **vaccine_patients.patient_id**: bigint → char(36)
- **verification_codes.patient_id**: bigint → char(36)
- **visits.patient_id**: bigint → char(36)
- **visits.relation_patient_id**: bigint → char(36)

## Migration Rules

1. **Staff Users**: Users with type in ['DOCTOR', 'ADMIN', 'SECRETARY', 'NURSE'] → `users` table
2. **Patients**: Users with type 'PATIENT' → `patients` table
3. **Foreign Keys**: Rewire based on entity type (staff vs patient)
4. **Data Preservation**: Maintain all audit fields and relationships

## Detailed Table Analysis

### Table: users

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 15
**Data Type Changes**: None

### Table: patients

**Columns Added**: 25
**Columns Removed**: None
**Columns Common**: 12
**Data Type Changes**: 
- `patient_id`: bigint → char(36) (Primary Key change)

**New Columns in patients table**:
- `contact_info`
- `medical_number`
- `marital_status`
- `nationality`
- `blood_type`
- `tobacco_use`
- `illicit_drug_use`
- `alcohol_use`
- `living_situation`
- `national_id`
- `country_id`
- `governorate_id`
- `easy_appointment_customer_id`
- `years_of_smoking`
- `smoking_start_year`
- `cigarettes_per_day`
- `average_packs_per_day`
- `occupation`
- `qr_code`
- `relation_patient_id`
- `relation_ship_type`

### Table: appointments

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 12
**Data Type Changes**: None

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))
- `doctor_id`: Now references `users.id` (bigint)
- `created_by_user_id`: Now references `users.id` (bigint)

### Table: visits

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 20
**Data Type Changes**:
- `patient_id`: bigint → char(36)
- `relation_patient_id`: bigint → char(36)

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))
- `doctor_id`: Now references `users.id` (bigint)
- `relation_patient_id`: Now references `patients.patient_id` (char(36))

### Table: medical_cases

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 8
**Data Type Changes**: None

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))
- `created_by`: Now references `users.id` (bigint)

### Table: verification_codes

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 8
**Data Type Changes**:
- `patient_id`: bigint → char(36)

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))

### Table: patient_allergies

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 5
**Data Type Changes**:
- `patient_id`: bigint → char(36)

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))

### Table: patient_health_records

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 5
**Data Type Changes**:
- `patient_id`: bigint → char(36)

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))
- `doctor_id`: Now references `users.id` (bigint)

### Table: vaccine_patients

**Columns Added**: None
**Columns Removed**: None
**Columns Common**: 5
**Data Type Changes**:
- `patient_id`: bigint → char(36)

**Foreign Key Changes**:
- `patient_id`: Now references `patients.patient_id` (char(36))

## Migration Complexity Assessment

### High Complexity Tables
- **users** → **users + patients**: Complete data separation and transformation
- **appointments**: Multiple foreign key rewiring
- **visits**: Multiple foreign key rewiring with data type changes

### Medium Complexity Tables
- **medical_cases**: Foreign key rewiring
- **verification_codes**: Foreign key rewiring with data type change
- **patient_allergies**: Foreign key rewiring with data type change
- **patient_health_records**: Foreign key rewiring with data type change
- **vaccine_patients**: Foreign key rewiring with data type change

### Low Complexity Tables
- **clinics**: No changes
- **medical_centers**: No changes
- **allergies**: No changes
- **vaccines**: No changes

## Data Transformation Requirements

### 1. User Type Classification
- **Staff Types**: DOCTOR, ADMIN, SECRETARY, NURSE, SUPER_ADMIN
- **Patient Types**: PATIENT

### 2. ID Generation
- **Staff Users**: Keep existing bigint IDs
- **Patients**: Generate new UUIDs (char(36))

### 3. Data Cleaning
- **Phone Numbers**: Normalize to E.164 format
- **Emails**: Validate and normalize
- **Names**: Title case and trim whitespace
- **Dates**: Standardize format

### 4. Foreign Key Mapping
- **user_id → patient_id**: For patient references
- **user_id → user_id**: For staff references
- **patient_id → patient_id**: For patient references (with UUID conversion)

## Risk Assessment

### High Risk
- **Data Loss**: Incorrect user type classification
- **Referential Integrity**: Broken foreign key relationships
- **Data Type Conversion**: UUID generation and mapping

### Medium Risk
- **Performance**: Large table migrations
- **Data Quality**: Inconsistent data formats
- **Rollback Complexity**: Complex undo operations

### Low Risk
- **Configuration**: Well-defined mapping rules
- **Logging**: Comprehensive audit trail
- **Validation**: Post-migration verification

## Recommendations

### 1. Pre-Migration
- **Backup**: Create full database backups
- **Test**: Run dry-run on test environment
- **Validate**: Review schema differences thoroughly
- **Plan**: Create detailed migration timeline

### 2. During Migration
- **Monitor**: Watch for errors and performance issues
- **Validate**: Check data integrity at each step
- **Log**: Maintain detailed migration logs
- **Pause**: Stop on critical errors

### 3. Post-Migration
- **Verify**: Run all validation queries
- **Test**: Verify application functionality
- **Monitor**: Watch for performance issues
- **Document**: Record any issues and resolutions

## Estimated Migration Time

Based on table sizes and complexity:
- **Small Tables** (< 1K records): 1-5 minutes
- **Medium Tables** (1K-10K records): 5-15 minutes
- **Large Tables** (10K+ records): 15-60 minutes
- **Total Estimated Time**: 2-4 hours

## Dependencies

### Migration Order
1. **users** → **users + patients** (must be first)
2. **patient_allergies** (depends on patients)
3. **patient_health_records** (depends on patients)
4. **vaccine_patients** (depends on patients)
5. **appointments** (depends on users and patients)
6. **visits** (depends on users and patients)
7. **medical_cases** (depends on users and patients)
8. **verification_codes** (depends on patients)

### Rollback Dependencies
- Reverse the migration order
- Restore original foreign key relationships
- Revert data type changes
- Restore original table structures

## Success Criteria

### Primary Success Indicators
- [ ] All users migrated to appropriate tables
- [ ] No orphaned foreign key references
- [ ] All data types correctly converted
- [ ] Record counts match expectations

### Secondary Success Indicators
- [ ] Application functionality preserved
- [ ] Performance within acceptable limits
- [ ] All validation queries pass
- [ ] Crosswalk files generated correctly

## Notes

This schema analysis was generated automatically by the Medical Center Platform Migration Tool. Please review all findings carefully before proceeding with the migration. Any discrepancies or questions should be resolved before starting the actual data migration process.

For additional support or questions, refer to the migration tool documentation or contact your database administration team.