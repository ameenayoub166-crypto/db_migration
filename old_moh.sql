-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 22, 2025 at 01:39 PM
-- Server version: 8.0.43-0ubuntu0.24.04.1
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `old_moh`
--

-- --------------------------------------------------------

--
-- Table structure for table `allergies`
--

CREATE TABLE `allergies` (
  `id` bigint UNSIGNED NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icd_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` bigint UNSIGNED NOT NULL,
  `created_by_user_id` bigint UNSIGNED DEFAULT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `clinic_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `relation_patient_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('BOOKED','COMPLETED','DID_NOT_COME','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BOOKED',
  `booking_date_time` datetime NOT NULL,
  `easy_appointment_booking_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `associated_symptom_cases`
--

CREATE TABLE `associated_symptom_cases` (
  `symptom_id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinics`
--

CREATE TABLE `clinics` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `working_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `working_time` json DEFAULT NULL,
  `easy_appointment_service_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_medical_specialties`
--

CREATE TABLE `clinic_medical_specialties` (
  `clinic_id` bigint UNSIGNED NOT NULL,
  `medical_specialty_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_nurses`
--

CREATE TABLE `clinic_nurses` (
  `clinic_id` bigint UNSIGNED NOT NULL,
  `nurse_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `current_medical_case_medicines`
--

CREATE TABLE `current_medical_case_medicines` (
  `id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED NOT NULL,
  `medicine_id` bigint UNSIGNED NOT NULL,
  `medicine_form_id` bigint UNSIGNED NOT NULL,
  `medicine_frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `indication` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diagnostic_tests`
--

CREATE TABLE `diagnostic_tests` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `type` enum('BLOOD_TEST','TEST') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `medical_specialty_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `working_time` json DEFAULT NULL,
  `working_time_exception` json DEFAULT NULL,
  `easy_appointment_provider_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctor_clinics`
--

CREATE TABLE `doctor_clinics` (
  `doctor_id` bigint UNSIGNED NOT NULL,
  `clinic_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `governorates`
--

CREATE TABLE `governorates` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `country_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `icd_entities`
--

CREATE TABLE `icd_entities` (
  `id` bigint UNSIGNED NOT NULL,
  `foundation_uri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `linearization_uri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `block_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `class_kind` enum('CHAPTER','BLOCK','CATEGORY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depth_in_kind` int DEFAULT NULL,
  `is_residual` tinyint(1) DEFAULT NULL,
  `chapter_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_leaf` tinyint(1) DEFAULT NULL,
  `primary_tabulation` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `icd_entity_translations`
--

CREATE TABLE `icd_entity_translations` (
  `id` bigint UNSIGNED NOT NULL,
  `icd_entity_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `locale` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `icd_groups`
--

CREATE TABLE `icd_groups` (
  `id` bigint UNSIGNED NOT NULL,
  `icd_entity_id` bigint UNSIGNED NOT NULL,
  `grouping` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inherited_diseases`
--

CREATE TABLE `inherited_diseases` (
  `id` bigint UNSIGNED NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icd_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_cases`
--

CREATE TABLE `medical_cases` (
  `id` bigint UNSIGNED NOT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `chief_complaint` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('OPEN','CLOSED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `triage_level` enum('EMERGENCY_RED','PRIORITY_YELLOW','NON_URGENT_GREEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `onset` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `duration` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `location` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `severity` enum('MID','MODERATE','SEVERE','LIFE_THREATENING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `character_quality` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `aggravating_factors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `relieving_factors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `timing` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `blood_pressure` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `heart_rate` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `temperature` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `respiratory_rate` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `o2_saturation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `weight` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `height` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `bmi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `general_appearance` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `heent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cardiovascular` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `respiratory` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `abdominal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `neurological` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `musculoskeletal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `skin` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `provocation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `quality` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `region` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_case_attachments`
--

CREATE TABLE `medical_case_attachments` (
  `id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_case_diagnoses`
--

CREATE TABLE `medical_case_diagnoses` (
  `id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED NOT NULL,
  `icd_entity_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('CONFIRMED','POSTOPERATIVE','UNCONFIRMED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('DEFINITIVE_DIAGNOSES','DIFFERENTIAL_DIAGNOSES') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DEFINITIVE_DIAGNOSES',
  `injury_side` enum('RIGHT','LEFT','MIDDLE','BOTH_SIDES') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `diagnosis` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_centers`
--

CREATE TABLE `medical_centers` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `governorate_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_center_diagnostic_tests`
--

CREATE TABLE `medical_center_diagnostic_tests` (
  `id` bigint UNSIGNED NOT NULL,
  `diagnostic_test_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `status` enum('AVAILABLE','MAINTENANCE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_specialties`
--

CREATE TABLE `medical_specialties` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `name_ar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

CREATE TABLE `medicines` (
  `id` bigint UNSIGNED NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `medicine_brand_id` bigint UNSIGNED DEFAULT NULL,
  `medicine_form_id` bigint UNSIGNED NOT NULL,
  `composition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `package` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pharmacy_price` decimal(15,3) DEFAULT NULL,
  `retail_price` decimal(15,3) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicines_frequencies`
--

CREATE TABLE `medicines_frequencies` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_brands`
--

CREATE TABLE `medicine_brands` (
  `id` bigint UNSIGNED NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_forms`
--

CREATE TABLE `medicine_forms` (
  `id` bigint UNSIGNED NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `multi_type_settings`
--

CREATE TABLE `multi_type_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `setting_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('EMAIL','LINK','NUMBER','PHONE_NUMBER','TEXT','BOOLEAN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nurses`
--

CREATE TABLE `nurses` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `scopes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `redirect` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint UNSIGNED NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `medical_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `marital_status` enum('SINGLE','MARRIED','DIVORCED','WIDOWED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nationality` enum('SYRIAN','NON_SYRIAN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tobacco_use` enum('NEVER_USE','FORMER','CURRENT_SMOKER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `illicit_drug_use` enum('CURRENTLY','SOMETIMES','PREVIOUSLY','NEVER_USE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alcohol_use` enum('NEVER','OCCASIONAL','MODERATE','HEAVY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `living_situation` enum('LIVES_ALONE','LIVES_WITH_FAMILY','ASSISTED_LIVING','NURSING_HOME','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `national_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` bigint UNSIGNED DEFAULT NULL,
  `governorate_id` bigint UNSIGNED DEFAULT NULL,
  `easy_appointment_customer_id` int DEFAULT NULL,
  `years_of_smoking` int DEFAULT NULL,
  `smoking_start_year` int DEFAULT NULL,
  `cigarettes_per_day` int DEFAULT NULL,
  `average_packs_per_day` decimal(15,2) DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `occupation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `qr_code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `relation_patient_id` bigint UNSIGNED DEFAULT NULL,
  `relation_ship_type` enum('SON','DAUGHTER','PARTNER','FATHER','MOTHER','HUSBAND_SON','HUSBAND_DAUGHTER','WIFE_SON','WIFE_DAUGHTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_allergies`
--

CREATE TABLE `patient_allergies` (
  `id` bigint UNSIGNED NOT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `allergy_id` bigint UNSIGNED NOT NULL,
  `severity` enum('MID','MODERATE','SEVERE','LIFE_THREATENING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_health_records`
--

CREATE TABLE `patient_health_records` (
  `id` bigint UNSIGNED NOT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED NOT NULL,
  `visit_id` bigint UNSIGNED NOT NULL,
  `chronic_illnesses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `past_hospitalizations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `surgeries_procedures` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `major_injuries_accidents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `psychiatric_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ob_gyn_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `significant_family_medical_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `active_medication_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `known_allergies` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tobacco_use` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `alcohol_use` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `illicit_drug_use` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `occupation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `living_situation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `exercise_habits` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `diet` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `primary_reason_visit` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `detailed_narrative_problems` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `constitutional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `heent_ros` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `respiratory` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cardiovascular_ros` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `gastrointestinal` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `genitourinary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `musculoskeletal` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `skin_ros` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `neurological_ros` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `psychiatric` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `endocrine` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `hematologic_lymphatic` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `allergic_immunologic` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `blood_pressure` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `heart_rate` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `respiratory_rate` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `temperature` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `height` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `weight` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `bmi` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `o2_saturation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `general_appearance` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `heent_physical_examination` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `neck` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cardiovascular_physical_examination` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `lungs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `abdomen` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `extremities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `neurological_physical_examination` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `skin_physical_examination` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `clinical_assessment_diagnoses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `diagnostic_plan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `therapeutic_plan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `medication_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `dosage` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `duration` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `special_instructions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `referrals` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `follow_up_plan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `lab_results` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imaging_results` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `referral_reports` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `consultation_reports` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cpt_procedure_code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_health_record_icd_entities`
--

CREATE TABLE `patient_health_record_icd_entities` (
  `patient_health_record_id` bigint UNSIGNED NOT NULL,
  `icd_entity_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_inherited_diseases`
--

CREATE TABLE `patient_inherited_diseases` (
  `id` bigint UNSIGNED NOT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `inherited_disease_id` bigint UNSIGNED NOT NULL,
  `relative` enum('MOTHER','FATHER','SISTER','BROTHER','MATERNAL_GRANDMOTHER','MATERNAL_GRANDFATHER','PATERNAL_GRANDMOTHER','PATERNAL_GRANDFATHER','DAUGHTER','SON','AUNT','UNCLE','COUSIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `age_of_onset` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `standard` tinyint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `secretaries`
--

CREATE TABLE `secretaries` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `symptoms`
--

CREATE TABLE `symptoms` (
  `id` bigint UNSIGNED NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icd_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `father_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mother_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('MALE','FEMALE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `avatar_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` enum('SUPER_ADMIN','DOCTOR','PATIENT','NURSE','SECRETARY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vaccines`
--

CREATE TABLE `vaccines` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vaccine_patients`
--

CREATE TABLE `vaccine_patients` (
  `id` bigint UNSIGNED NOT NULL,
  `vaccine_id` bigint UNSIGNED NOT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `vaccination_age` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `verification_codes`
--

CREATE TABLE `verification_codes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `phone_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visits`
--

CREATE TABLE `visits` (
  `id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED DEFAULT NULL,
  `patient_id` bigint UNSIGNED NOT NULL,
  `relation_patient_id` bigint UNSIGNED DEFAULT NULL,
  `clinic_id` bigint UNSIGNED NOT NULL,
  `doctor_id` bigint UNSIGNED DEFAULT NULL,
  `medical_center_id` bigint UNSIGNED NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `visit_source` enum('VISIT','APPOINTMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISIT',
  `visit_type` enum('OUT_PATIENT_FOLLOW_UP','IN_PATIENT_FOLLOW_UP') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('WAIT_LIST','IN_PROGRESS','DONE','TRANSFERRED','WAITING_LIST_TRANSFERRED','CALLED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `visit_date` datetime DEFAULT NULL,
  `patient_visit_started_at` datetime DEFAULT NULL,
  `patient_visit_ended_at` datetime DEFAULT NULL,
  `queue_number` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visit_diagnose_attachments`
--

CREATE TABLE `visit_diagnose_attachments` (
  `id` bigint UNSIGNED NOT NULL,
  `medical_case_id` bigint UNSIGNED DEFAULT NULL,
  `visit_diagnostic_test_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visit_diagnostic_tests`
--

CREATE TABLE `visit_diagnostic_tests` (
  `id` bigint UNSIGNED NOT NULL,
  `visit_id` bigint UNSIGNED NOT NULL,
  `indication` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `diagnostic_test_id` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visit_prescribed_medications`
--

CREATE TABLE `visit_prescribed_medications` (
  `id` bigint UNSIGNED NOT NULL,
  `visit_id` bigint UNSIGNED NOT NULL,
  `medicine_id` bigint UNSIGNED NOT NULL,
  `medicine_form_id` bigint UNSIGNED NOT NULL,
  `medicine_frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `indication` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visual_settings`
--

CREATE TABLE `visual_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `setting_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visual_setting_translations`
--

CREATE TABLE `visual_setting_translations` (
  `id` bigint UNSIGNED NOT NULL,
  `visual_setting_id` bigint UNSIGNED NOT NULL,
  `locale` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `allergies`
--
ALTER TABLE `allergies`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `allergies` ADD FULLTEXT KEY `idx_ft_title` (`title`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_doctor` (`doctor_id`),
  ADD KEY `idx_clinic` (`clinic_id`),
  ADD KEY `idx_medical_center` (`medical_center_id`),
  ADD KEY `idx_relation_patient` (`relation_patient_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_create_user` (`created_by_user_id`);

--
-- Indexes for table `associated_symptom_cases`
--
ALTER TABLE `associated_symptom_cases`
  ADD KEY `idx_symptom` (`symptom_id`),
  ADD KEY `idx_case` (`medical_case_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_publish` (`publish`),
  ADD KEY `idx_medical_center` (`medical_center_id`);
ALTER TABLE `clinics` ADD FULLTEXT KEY `idx_name` (`name`);

--
-- Indexes for table `clinic_medical_specialties`
--
ALTER TABLE `clinic_medical_specialties`
  ADD KEY `idx_clinic` (`clinic_id`),
  ADD KEY `idx_medical_specialty` (`medical_specialty_id`);

--
-- Indexes for table `clinic_nurses`
--
ALTER TABLE `clinic_nurses`
  ADD KEY `idx_clinic` (`clinic_id`),
  ADD KEY `idx_nurse` (`nurse_id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_publish` (`publish`),
  ADD KEY `idx_iso2` (`iso2`),
  ADD KEY `idx_phone_code` (`phone_number_code`);
ALTER TABLE `countries` ADD FULLTEXT KEY `idx_name` (`name`);

--
-- Indexes for table `current_medical_case_medicines`
--
ALTER TABLE `current_medical_case_medicines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_medical_case` (`medical_case_id`),
  ADD KEY `idx_medicine` (`medicine_id`),
  ADD KEY `idc_form` (`medicine_form_id`);

--
-- Indexes for table `diagnostic_tests`
--
ALTER TABLE `diagnostic_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`type`);
ALTER TABLE `diagnostic_tests` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctors_user_id_foreign` (`user_id`),
  ADD KEY `idx_med_spec` (`medical_specialty_id`),
  ADD KEY `idx_med_cen` (`medical_center_id`);

--
-- Indexes for table `doctor_clinics`
--
ALTER TABLE `doctor_clinics`
  ADD KEY `doctor_clinics_doctor_id_foreign` (`doctor_id`),
  ADD KEY `doctor_clinics_clinic_id_foreign` (`clinic_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `governorates`
--
ALTER TABLE `governorates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `governorates_country_id_index` (`country_id`);
ALTER TABLE `governorates` ADD FULLTEXT KEY `idx_gover_name` (`name`);

--
-- Indexes for table `icd_entities`
--
ALTER TABLE `icd_entities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_class` (`class_kind`);
ALTER TABLE `icd_entities` ADD FULLTEXT KEY `idx_code` (`code`);

--
-- Indexes for table `icd_entity_translations`
--
ALTER TABLE `icd_entity_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `icd_entity_translations_icd_entity_id_locale_unique` (`icd_entity_id`,`locale`),
  ADD KEY `icd_entity_translations_locale_index` (`locale`);
ALTER TABLE `icd_entity_translations` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `icd_groups`
--
ALTER TABLE `icd_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_icd_entity` (`icd_entity_id`);
ALTER TABLE `icd_groups` ADD FULLTEXT KEY `idx_grouping` (`grouping`);

--
-- Indexes for table `inherited_diseases`
--
ALTER TABLE `inherited_diseases`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `inherited_diseases` ADD FULLTEXT KEY `idx_ft_title` (`title`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medical_cases`
--
ALTER TABLE `medical_cases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_doctor` (`doctor_id`),
  ADD KEY `idx_medical_center` (`medical_center_id`),
  ADD KEY `idx_triage` (`triage_level`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_severity` (`severity`);

--
-- Indexes for table `medical_case_attachments`
--
ALTER TABLE `medical_case_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_medical_case` (`medical_case_id`);

--
-- Indexes for table `medical_case_diagnoses`
--
ALTER TABLE `medical_case_diagnoses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_medical_case` (`medical_case_id`),
  ADD KEY `idx_icd_entity` (`icd_entity_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_injury_side` (`injury_side`),
  ADD KEY `idx_type` (`type`);

--
-- Indexes for table `medical_centers`
--
ALTER TABLE `medical_centers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_publish` (`publish`),
  ADD KEY `idx_governorate_id` (`governorate_id`);
ALTER TABLE `medical_centers` ADD FULLTEXT KEY `idx_name` (`name`);

--
-- Indexes for table `medical_center_diagnostic_tests`
--
ALTER TABLE `medical_center_diagnostic_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_diagnostic_test` (`diagnostic_test_id`),
  ADD KEY `idx_medical_center` (`medical_center_id`),
  ADD KEY `idX_status` (`status`);

--
-- Indexes for table `medical_specialties`
--
ALTER TABLE `medical_specialties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_publish` (`publish`);
ALTER TABLE `medical_specialties` ADD FULLTEXT KEY `idx_name_ar` (`name_ar`);
ALTER TABLE `medical_specialties` ADD FULLTEXT KEY `idx_name_en` (`name_en`);

--
-- Indexes for table `medicines`
--
ALTER TABLE `medicines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_publish` (`publish`),
  ADD KEY `idx_brand` (`medicine_brand_id`),
  ADD KEY `idx_form` (`medicine_form_id`);
ALTER TABLE `medicines` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `medicines_frequencies`
--
ALTER TABLE `medicines_frequencies`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `medicines_frequencies` ADD FULLTEXT KEY `idx_code` (`code`);

--
-- Indexes for table `medicine_brands`
--
ALTER TABLE `medicine_brands`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `medicine_brands` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `medicine_forms`
--
ALTER TABLE `medicine_forms`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `medicine_forms` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `multi_type_settings`
--
ALTER TABLE `multi_type_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_unique_setting_key` (`setting_key`),
  ADD KEY `idx_type` (`type`);
ALTER TABLE `multi_type_settings` ADD FULLTEXT KEY `idx_ft_setting_key` (`setting_key`);

--
-- Indexes for table `nurses`
--
ALTER TABLE `nurses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nurses_user_id_foreign` (`user_id`),
  ADD KEY `idx_medi_cent` (`medical_center_id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_unique_national` (`national_number`),
  ADD KEY `patients_user_id_foreign` (`user_id`),
  ADD KEY `idx_pat_type` (`marital_status`),
  ADD KEY `idx_nation` (`nationality`),
  ADD KEY `idx_blood` (`blood_type`),
  ADD KEY `idx_country` (`country_id`),
  ADD KEY `idx_governorate` (`governorate_id`),
  ADD KEY `idx_relation_patient` (`relation_patient_id`),
  ADD KEY `idx_relation_ship` (`relation_ship_type`),
  ADD KEY `idx_alcohol` (`alcohol_use`),
  ADD KEY `idx_living` (`living_situation`),
  ADD KEY `idx_tobacco` (`tobacco_use`),
  ADD KEY `idx_illicit` (`illicit_drug_use`);
ALTER TABLE `patients` ADD FULLTEXT KEY `idx_ft_national` (`national_number`);
ALTER TABLE `patients` ADD FULLTEXT KEY `idx_medical` (`medical_number`);

--
-- Indexes for table `patient_allergies`
--
ALTER TABLE `patient_allergies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient_allerg` (`patient_id`),
  ADD KEY `idx_allergy` (`allergy_id`),
  ADD KEY `idx_severity` (`severity`);

--
-- Indexes for table `patient_health_records`
--
ALTER TABLE `patient_health_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_doctor` (`doctor_id`),
  ADD KEY `idx_visit` (`visit_id`);

--
-- Indexes for table `patient_health_record_icd_entities`
--
ALTER TABLE `patient_health_record_icd_entities`
  ADD KEY `idx_patient_health_record` (`patient_health_record_id`),
  ADD KEY `idx_icd_entity` (`icd_entity_id`);

--
-- Indexes for table `patient_inherited_diseases`
--
ALTER TABLE `patient_inherited_diseases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient_inherit` (`patient_id`),
  ADD KEY `idx_inherit` (`inherited_disease_id`),
  ADD KEY `idx_relative` (`relative`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);
ALTER TABLE `permissions` ADD FULLTEXT KEY `ft_name` (`name`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`),
  ADD UNIQUE KEY `idx_name` (`name`),
  ADD UNIQUE KEY `idx_unique_identifier` (`code`);
ALTER TABLE `roles` ADD FULLTEXT KEY `ft_name_role` (`name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `secretaries`
--
ALTER TABLE `secretaries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `secretaries_user_id_foreign` (`user_id`),
  ADD KEY `idx_medi_cent` (`medical_center_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `symptoms`
--
ALTER TABLE `symptoms`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `symptoms` ADD FULLTEXT KEY `idx_title` (`title`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_gender` (`gender`),
  ADD KEY `idx_type` (`type`);
ALTER TABLE `users` ADD FULLTEXT KEY `ft_idx_full_fir` (`first_name`);
ALTER TABLE `users` ADD FULLTEXT KEY `ft_idx_full_la` (`last_name`);
ALTER TABLE `users` ADD FULLTEXT KEY `idx_ft_phone` (`phone_number`);

--
-- Indexes for table `vaccines`
--
ALTER TABLE `vaccines`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `vaccines` ADD FULLTEXT KEY `idx_name` (`name`);

--
-- Indexes for table `vaccine_patients`
--
ALTER TABLE `vaccine_patients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vaccine` (`vaccine_id`),
  ADD KEY `idx_patient` (`patient_id`);

--
-- Indexes for table `verification_codes`
--
ALTER TABLE `verification_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `verification_codes_user_id_foreign` (`user_id`);

--
-- Indexes for table `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patient` (`patient_id`),
  ADD KEY `idx_relation_patient` (`relation_patient_id`),
  ADD KEY `idx_clinic` (`clinic_id`),
  ADD KEY `idx_doctor` (`doctor_id`),
  ADD KEY `idx_medical_center` (`medical_center_id`),
  ADD KEY `idx_visit_source` (`visit_source`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_medical_case_id` (`medical_case_id`),
  ADD KEY `idx_visit_type` (`visit_type`);

--
-- Indexes for table `visit_diagnose_attachments`
--
ALTER TABLE `visit_diagnose_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vi_case` (`medical_case_id`),
  ADD KEY `idx_vi_diagnose` (`visit_diagnostic_test_id`);

--
-- Indexes for table `visit_diagnostic_tests`
--
ALTER TABLE `visit_diagnostic_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_visit` (`visit_id`),
  ADD KEY `idx_dia_test` (`diagnostic_test_id`);

--
-- Indexes for table `visit_prescribed_medications`
--
ALTER TABLE `visit_prescribed_medications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_visit` (`visit_id`),
  ADD KEY `idx_medicine` (`medicine_id`),
  ADD KEY `idx_medicine_form` (`medicine_form_id`);

--
-- Indexes for table `visual_settings`
--
ALTER TABLE `visual_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_unique_visual_setting_key` (`setting_key`);
ALTER TABLE `visual_settings` ADD FULLTEXT KEY `idx_ft_visual_setting_key` (`setting_key`);

--
-- Indexes for table `visual_setting_translations`
--
ALTER TABLE `visual_setting_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `visual_setting_translations_visual_setting_id_locale_unique` (`visual_setting_id`,`locale`),
  ADD KEY `visual_setting_translations_locale_index` (`locale`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `allergies`
--
ALTER TABLE `allergies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `current_medical_case_medicines`
--
ALTER TABLE `current_medical_case_medicines`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `diagnostic_tests`
--
ALTER TABLE `diagnostic_tests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `governorates`
--
ALTER TABLE `governorates`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `icd_entities`
--
ALTER TABLE `icd_entities`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36783;

--
-- AUTO_INCREMENT for table `icd_entity_translations`
--
ALTER TABLE `icd_entity_translations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73565;

--
-- AUTO_INCREMENT for table `icd_groups`
--
ALTER TABLE `icd_groups`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35040;

--
-- AUTO_INCREMENT for table `inherited_diseases`
--
ALTER TABLE `inherited_diseases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medical_cases`
--
ALTER TABLE `medical_cases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `medical_case_attachments`
--
ALTER TABLE `medical_case_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `medical_case_diagnoses`
--
ALTER TABLE `medical_case_diagnoses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `medical_centers`
--
ALTER TABLE `medical_centers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `medical_center_diagnostic_tests`
--
ALTER TABLE `medical_center_diagnostic_tests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `medical_specialties`
--
ALTER TABLE `medical_specialties`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `medicines`
--
ALTER TABLE `medicines`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `medicines_frequencies`
--
ALTER TABLE `medicines_frequencies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `medicine_brands`
--
ALTER TABLE `medicine_brands`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `medicine_forms`
--
ALTER TABLE `medicine_forms`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `multi_type_settings`
--
ALTER TABLE `multi_type_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `nurses`
--
ALTER TABLE `nurses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `patient_allergies`
--
ALTER TABLE `patient_allergies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `patient_health_records`
--
ALTER TABLE `patient_health_records`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_inherited_diseases`
--
ALTER TABLE `patient_inherited_diseases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `secretaries`
--
ALTER TABLE `secretaries`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `symptoms`
--
ALTER TABLE `symptoms`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `vaccines`
--
ALTER TABLE `vaccines`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vaccine_patients`
--
ALTER TABLE `vaccine_patients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `verification_codes`
--
ALTER TABLE `verification_codes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT for table `visits`
--
ALTER TABLE `visits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `visit_diagnose_attachments`
--
ALTER TABLE `visit_diagnose_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `visit_diagnostic_tests`
--
ALTER TABLE `visit_diagnostic_tests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `visit_prescribed_medications`
--
ALTER TABLE `visit_prescribed_medications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `visual_settings`
--
ALTER TABLE `visual_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `visual_setting_translations`
--
ALTER TABLE `visual_setting_translations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_created_by_user_id_foreign` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_relation_patient_id_foreign` FOREIGN KEY (`relation_patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `associated_symptom_cases`
--
ALTER TABLE `associated_symptom_cases`
  ADD CONSTRAINT `associated_symptom_cases_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `associated_symptom_cases_symptom_id_foreign` FOREIGN KEY (`symptom_id`) REFERENCES `symptoms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `clinics`
--
ALTER TABLE `clinics`
  ADD CONSTRAINT `clinics_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `clinic_medical_specialties`
--
ALTER TABLE `clinic_medical_specialties`
  ADD CONSTRAINT `clinic_medical_specialties_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clinic_medical_specialties_medical_specialty_id_foreign` FOREIGN KEY (`medical_specialty_id`) REFERENCES `medical_specialties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `clinic_nurses`
--
ALTER TABLE `clinic_nurses`
  ADD CONSTRAINT `clinic_nurses_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clinic_nurses_nurse_id_foreign` FOREIGN KEY (`nurse_id`) REFERENCES `nurses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `current_medical_case_medicines`
--
ALTER TABLE `current_medical_case_medicines`
  ADD CONSTRAINT `current_medical_case_medicines_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `current_medical_case_medicines_medicine_form_id_foreign` FOREIGN KEY (`medicine_form_id`) REFERENCES `medicine_forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `current_medical_case_medicines_medicine_id_foreign` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctors_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `doctors_medical_specialty_id_foreign` FOREIGN KEY (`medical_specialty_id`) REFERENCES `medical_specialties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `doctors_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `doctor_clinics`
--
ALTER TABLE `doctor_clinics`
  ADD CONSTRAINT `doctor_clinics_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `doctor_clinics_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `governorates`
--
ALTER TABLE `governorates`
  ADD CONSTRAINT `governorates_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `icd_entity_translations`
--
ALTER TABLE `icd_entity_translations`
  ADD CONSTRAINT `icd_entity_translations_icd_entity_id_foreign` FOREIGN KEY (`icd_entity_id`) REFERENCES `icd_entities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `icd_groups`
--
ALTER TABLE `icd_groups`
  ADD CONSTRAINT `icd_groups_icd_entity_id_foreign` FOREIGN KEY (`icd_entity_id`) REFERENCES `icd_entities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medical_cases`
--
ALTER TABLE `medical_cases`
  ADD CONSTRAINT `medical_cases_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medical_cases_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medical_cases_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medical_case_attachments`
--
ALTER TABLE `medical_case_attachments`
  ADD CONSTRAINT `medical_case_attachments_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medical_case_diagnoses`
--
ALTER TABLE `medical_case_diagnoses`
  ADD CONSTRAINT `medical_case_diagnoses_icd_entity_id_foreign` FOREIGN KEY (`icd_entity_id`) REFERENCES `icd_entities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medical_case_diagnoses_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medical_centers`
--
ALTER TABLE `medical_centers`
  ADD CONSTRAINT `medical_centers_governorate_id_foreign` FOREIGN KEY (`governorate_id`) REFERENCES `governorates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `medical_center_diagnostic_tests`
--
ALTER TABLE `medical_center_diagnostic_tests`
  ADD CONSTRAINT `medical_center_diagnostic_tests_diagnostic_test_id_foreign` FOREIGN KEY (`diagnostic_test_id`) REFERENCES `diagnostic_tests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medical_center_diagnostic_tests_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medicines`
--
ALTER TABLE `medicines`
  ADD CONSTRAINT `medicines_medicine_brand_id_foreign` FOREIGN KEY (`medicine_brand_id`) REFERENCES `medicine_brands` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medicines_medicine_form_id_foreign` FOREIGN KEY (`medicine_form_id`) REFERENCES `medicine_forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `nurses`
--
ALTER TABLE `nurses`
  ADD CONSTRAINT `nurses_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nurses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patients_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patients_governorate_id_foreign` FOREIGN KEY (`governorate_id`) REFERENCES `governorates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patients_relation_patient_id_foreign` FOREIGN KEY (`relation_patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patients_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_allergies`
--
ALTER TABLE `patient_allergies`
  ADD CONSTRAINT `patient_allergies_allergy_id_foreign` FOREIGN KEY (`allergy_id`) REFERENCES `allergies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_allergies_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_health_records`
--
ALTER TABLE `patient_health_records`
  ADD CONSTRAINT `patient_health_records_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_health_records_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_health_records_visit_id_foreign` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_health_record_icd_entities`
--
ALTER TABLE `patient_health_record_icd_entities`
  ADD CONSTRAINT `health_record` FOREIGN KEY (`patient_health_record_id`) REFERENCES `patient_health_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_health_record_icd_entities_icd_entity_id_foreign` FOREIGN KEY (`icd_entity_id`) REFERENCES `icd_entities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_inherited_diseases`
--
ALTER TABLE `patient_inherited_diseases`
  ADD CONSTRAINT `patient_inherited_diseases_inherited_disease_id_foreign` FOREIGN KEY (`inherited_disease_id`) REFERENCES `inherited_diseases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_inherited_diseases_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `secretaries`
--
ALTER TABLE `secretaries`
  ADD CONSTRAINT `secretaries_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `secretaries_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vaccine_patients`
--
ALTER TABLE `vaccine_patients`
  ADD CONSTRAINT `vaccine_patients_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vaccine_patients_vaccine_id_foreign` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `verification_codes`
--
ALTER TABLE `verification_codes`
  ADD CONSTRAINT `verification_codes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visits`
--
ALTER TABLE `visits`
  ADD CONSTRAINT `visits_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visits_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visits_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visits_medical_center_id_foreign` FOREIGN KEY (`medical_center_id`) REFERENCES `medical_centers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visits_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visits_relation_patient_id_foreign` FOREIGN KEY (`relation_patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visit_diagnose_attachments`
--
ALTER TABLE `visit_diagnose_attachments`
  ADD CONSTRAINT `visit_diagnose_attachments_medical_case_id_foreign` FOREIGN KEY (`medical_case_id`) REFERENCES `medical_cases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visit_diagnose_attachments_visit_diagnostic_test_id_foreign` FOREIGN KEY (`visit_diagnostic_test_id`) REFERENCES `visit_diagnostic_tests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visit_diagnostic_tests`
--
ALTER TABLE `visit_diagnostic_tests`
  ADD CONSTRAINT `visit_diagnostic_tests_diagnostic_test_id_foreign` FOREIGN KEY (`diagnostic_test_id`) REFERENCES `diagnostic_tests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visit_diagnostic_tests_visit_id_foreign` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visit_prescribed_medications`
--
ALTER TABLE `visit_prescribed_medications`
  ADD CONSTRAINT `visit_prescribed_medications_medicine_form_id_foreign` FOREIGN KEY (`medicine_form_id`) REFERENCES `medicine_forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visit_prescribed_medications_medicine_id_foreign` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visit_prescribed_medications_visit_id_foreign` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visual_setting_translations`
--
ALTER TABLE `visual_setting_translations`
  ADD CONSTRAINT `visual_setting_translations_visual_setting_id_foreign` FOREIGN KEY (`visual_setting_id`) REFERENCES `visual_settings` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
