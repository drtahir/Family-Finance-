// lib/core/database/tables/tables.dart
import 'package:drift/drift.dart';

// ─── TRANSACTIONS ─────────────────────────────────────────────────────────────

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'income' | 'expense'
  TextColumn get categoryId => text()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get paymentMethod => text()(); // 'cash' | 'bank' | 'mobile_wallet'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ─── CATEGORIES ───────────────────────────────────────────────────────────────

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get nameUrdu => text().nullable()();
  TextColumn get type => text()(); // 'income' | 'expense' | 'both'
  TextColumn get icon => text().withDefault(const Constant('category'))();
  TextColumn get color => text().withDefault(const Constant('#2196F3'))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// ─── ASSETS ───────────────────────────────────────────────────────────────────

class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get type => text()(); // 'gold'|'silver'|'land'|'cash'|'business'|'vehicle'|'other'
  RealColumn get currentValue => real()();
  RealColumn get purchaseValue => real().withDefault(const Constant(0.0))();
  RealColumn get quantity => real().nullable()(); // grams for gold/silver
  TextColumn get unit => text().nullable()(); // 'grams'|'tola'|'marla'|'kanal'
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isZakatApplicable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ─── LIABILITIES ──────────────────────────────────────────────────────────────

class Liabilities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get personName => text().withLength(min: 1, max: 200)();
  TextColumn get personPhone => text().nullable()();
  TextColumn get type => text()(); // 'loan_given'|'loan_taken'|'committee'|'debt'
  RealColumn get totalAmount => real()();
  RealColumn get remainingAmount => real()();
  RealColumn get monthlyInstallment => real().withDefault(const Constant(0.0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active'|'paid'|'overdue'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ─── LIABILITY PAYMENTS ───────────────────────────────────────────────────────

class LiabilityPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get liabilityId => integer().references(Liabilities, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── ZAKAT SNAPSHOTS ──────────────────────────────────────────────────────────

class ZakatSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  RealColumn get cashAmount => real().withDefault(const Constant(0.0))();
  RealColumn get goldValue => real().withDefault(const Constant(0.0))();
  RealColumn get silverValue => real().withDefault(const Constant(0.0))();
  RealColumn get businessAssets => real().withDefault(const Constant(0.0))();
  RealColumn get otherAssets => real().withDefault(const Constant(0.0))();
  RealColumn get totalLiabilities => real().withDefault(const Constant(0.0))();
  RealColumn get zakatableWealth => real().withDefault(const Constant(0.0))();
  RealColumn get zakatAmount => real().withDefault(const Constant(0.0))();
  RealColumn get nisabGold => real().withDefault(const Constant(0.0))();
  RealColumn get nisabSilver => real().withDefault(const Constant(0.0))();
  BoolColumn get zakatDue => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get calculatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── APP SETTINGS ─────────────────────────────────────────────────────────────

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['UNIQUE (key)'];
}
