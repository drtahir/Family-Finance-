import 'package:drift/drift.dart';

// BC Groups Table
class BcGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get membersCount => integer().withDefault(const Constant(0))();
  
  // Frequency: DAILY, WEEKLY, MONTHLY
  TextColumn get frequency => text()();
  
  // Draw day/date details
  TextColumn get drawDay => text().nullable()(); // e.g., "MONDAY" for weekly
  IntColumn get drawDate => integer().nullable()(); // 1-31 for monthly
  
  // Contribution amount per draw
  RealColumn get contributionAmount => real().withDefault(const Constant(0.0))();
  
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  
  // Organizer info
  TextColumn get organizerId => text()();
  TextColumn get organizerName => text()();
  
  // Status: ACTIVE, INACTIVE, COMPLETED
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

// BC Members Table
class BcMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()();
  
  TextColumn get memberId => text()();
  TextColumn get memberName => text()();
  TextColumn get memberEmail => text().nullable()();
  TextColumn get memberPhone => text().nullable()();
  
  // Status: ACTIVE, INACTIVE, WITHDRAWN
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  
  IntColumn get totalContributions => integer().withDefault(const Constant(0))();
  RealColumn get totalAmountPaid => real().withDefault(const Constant(0.0))();
  
  // Times won
  IntColumn get timesWon => integer().withDefault(const Constant(0))();
  RealColumn get totalWinnings => real().withDefault(const Constant(0.0))();
  
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<String> get customConstraints => [
    'UNIQUE(groupId, memberId)',
    'FOREIGN KEY (groupId) REFERENCES bc_groups(id) ON DELETE CASCADE'
  ];
}

// BC Draws Table (Lucky Draw History)
class BcDraws extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()();
  
  IntColumn get drawNumber => integer()(); // Sequential draw number in group
  
  // Draw details
  DateTimeColumn get drawDate => dateTime()();
  TextColumn get drawType => text().nullable()(); // MANUAL, AUTO_SCHEDULED
  
  // Winner info
  IntColumn get winnerId => integer().nullable()();
  TextColumn get winnerName => text().nullable()();
  TextColumn get winnerMemberId => text().nullable()();
  
  RealColumn get winAmount => real()();
  
  // Draw stats
  IntColumn get totalParticipants => integer()();
  
  // Status: PENDING, COMPLETED, CANCELLED
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (groupId) REFERENCES bc_groups(id) ON DELETE CASCADE',
    'FOREIGN KEY (winnerId) REFERENCES bc_members(id) ON DELETE SET NULL'
  ];
}

// BC Member Draw Participation Table
class BcDrawParticipation extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get drawId => integer()();
  IntColumn get memberId => integer()();
  IntColumn get groupId => integer()();
  
  // Contribution status: PAID, PENDING, SKIP
  TextColumn get contributionStatus => text().withDefault(const Constant('PAID'))();
  RealColumn get contributionAmount => real()();
  
  // Was this member eligible for this draw?
  BoolColumn get isEligible => boolean().withDefault(const Constant(true))();
  
  // Has this member won before in same cycle?
  BoolColumn get hasWonBefore => boolean().withDefault(const Constant(false))();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<String> get customConstraints => [
    'UNIQUE(drawId, memberId)',
    'FOREIGN KEY (drawId) REFERENCES bc_draws(id) ON DELETE CASCADE',
    'FOREIGN KEY (memberId) REFERENCES bc_members(id) ON DELETE CASCADE',
    'FOREIGN KEY (groupId) REFERENCES bc_groups(id) ON DELETE CASCADE'
  ];
}

// BC Payment Log Table
class BcPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()();
  IntColumn get memberId => integer()();
  IntColumn get drawId => integer()();
  
  RealColumn get amount => real()();
  
  // Payment status: PENDING, PAID, OVERDUE, SKIPPED
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get paidDate => dateTime().nullable()();
  
  TextColumn get paymentMethod => text().nullable()(); // CASH, BANK, ONLINE, etc.
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (groupId) REFERENCES bc_groups(id) ON DELETE CASCADE',
    'FOREIGN KEY (memberId) REFERENCES bc_members(id) ON DELETE CASCADE',
    'FOREIGN KEY (drawId) REFERENCES bc_draws(id) ON DELETE CASCADE'
  ];
}
