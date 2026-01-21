🧩 TECHNICAL BLUEPRINT
Offline-First Flutter POS System – Beverage Business
1. System Architecture Overview
1.1 High-Level Architecture
Presentation Layer (Flutter UI)
        │
        ▼
State Layer (Riverpod Providers & Notifiers)
        │
        ▼
Service Layer (Business Logic / Use Case)
        │
        ▼
Repository Layer (Abstraction)
        │
        ▼
Local Data Source (Drift / SQLite)


Semua proses transaksi, stok, dan laporan berjalan penuh di local device.
Layer cloud/sync belum diaktifkan, tetapi struktur data dan service sudah disiapkan.

2. Technology Stack

Client Application

Flutter (Android first, tablet-optimized)

Riverpod (flutter_riverpod)

Drift (SQLite ORM)

Freezed (immutable state)

UUID

Bluetooth printer plugin

Design Principles

Offline-first

Clean architecture lite

Repository pattern

Event-based transaction

Audit & transaction log

3. Project Structure (Recommended)
lib/
  core/
    database/
      app_database.dart
      tables/
    services/
      transaction_service.dart
      inventory_service.dart
      report_service.dart
    sync/ (future)
    utils/
  data/
    repositories/
      product_repository.dart
      order_repository.dart
      inventory_repository.dart
  domain/
    models/
    usecases/
  features/
    pos/
      ui/
      controller/
    inventory/
    products/
    reports/
    settings/
  shared/
    widgets/
    constants/

4. State Management Strategy (Riverpod)
4.1 Provider Classification

Global Infrastructure

databaseProvider

deviceProvider

settingsProvider

Domain Providers

productRepositoryProvider

inventoryRepositoryProvider

orderRepositoryProvider

Feature State

productListProvider (StreamProvider)

stockProvider (StreamProvider)

reportProvider (FutureProvider)

cartProvider (NotifierProvider)

sessionProvider (NotifierProvider)

4.2 Cart Controller (Example Responsibility)

addItem()

updateVariant()

applyDiscount()

calculateTotal()

submitOrder()

resetCart()

Cart hanya memegang state UI transaksi, bukan penyimpanan permanen.

5. Database Design Blueprint (Offline Core)
5.1 Core Tables

Master

products

categories

variants

ingredients

recipes

Operational

stocks

stock_movements

orders

order_items

payments

System

users

audit_logs

app_settings

5.2 Mandatory Fields (All Tables)

id (int, local)

uuid (string, global id)

created_at

updated_at

is_deleted

sync_status (future use)

6. Transaction Flow (Critical)
6.1 POS Order Flow

UI → CartController

Generate order_uuid

Insert orders

Insert order_items

Resolve recipes

Insert stock_movements

Update stocks

Insert payments

Write audit_logs

Commit transaction (SQLite batch)

Trigger printer

Reset cart

Seluruh proses dibungkus dalam satu database transaction.

7. Inventory Engine
7.1 BOM Resolution

Saat order selesai:

Sistem membaca recipes

Menghitung total kebutuhan bahan

Mengurangi stocks

Mencatat ke stock_movements

7.2 Stock Opname

Input stok fisik

Sistem membuat adjustment movement

Semua perubahan stok tidak pernah update langsung, selalu lewat stock_movements

8. Reporting Engine (Offline)

Reports dibangun dari:

orders

order_items

payments

stock_movements

Output:

daily sales

payment summary

top products

ingredient usage

gross margin estimation

9. Performance & Stability Rules

Semua heavy query via isolate

Index di uuid, created_at, foreign keys

Pagination untuk histori transaksi

Lazy loading untuk produk

Auto-backup lokal

10. Security & Data Integrity

Local user role

Shift session

PIN / biometric lock

Audit trail

Daily export backup

11. Future Online Readiness

Sudah disiapkan sejak awal:

uuid semua entity

soft delete

versioning field

stock_movements as event log

audit_logs

service layer isolation

Sehingga Phase online hanya menambah:

Auth server

Sync service

Conflict resolver

Owner dashboard

12. Development Roadmap (Technical)

Sprint 1

Project setup

DB schema

Riverpod core providers

POS UI skeleton

Sprint 2

Transaction engine

Cart flow

Receipt printing

Sprint 3

Inventory + recipe engine

Stock movement

Laporan dasar

Sprint 4

Role & shift

Export & backup

Hardening & testing lapangan

13. Definition of Done (v1 Offline)

Aplikasi dapat transaksi tanpa internet

Stok bahan otomatis terpotong

Data persisten walau app restart

Laporan bisa diambil per hari

Bisa dipakai kasir real operasional