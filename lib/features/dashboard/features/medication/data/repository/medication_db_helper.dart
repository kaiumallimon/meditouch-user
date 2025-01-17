import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../model/medication_model.dart';

class MedicationDBHelper {
  static final MedicationDBHelper _instance = MedicationDBHelper._internal();
  factory MedicationDBHelper() => _instance;
  MedicationDBHelper._internal();

  // StreamController for reminders
  final StreamController<List<MedicineReminder>> _reminderStreamController = StreamController<List<MedicineReminder>>.broadcast();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicineName TEXT,
            reminderTime TEXT,
            fromDate TEXT,
            toDate TEXT
          )
          ''',
        );
      },
    );
  }

  // Insert a new reminder into the database
  Future<int> insertReminder(MedicineReminder reminder) async {
    final db = await database;
    int id = await db.insert('reminders', reminder.toMap());
    _notifyReminderUpdate(); // Notify the stream after insertion
    return id;
  }

  // Fetch all reminders from the database
  Future<List<MedicineReminder>> fetchReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return MedicineReminder.fromMap(maps[i]);
    });
  }

  // Delete all reminders
  Future<void> deleteAllReminders() async {
    final db = await database;
    await db.delete('reminders');
    _notifyReminderUpdate(); // Notify the stream after deletion
  }

  // Delete a specific reminder by ID
  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
    _notifyReminderUpdate(); // Notify the stream after deletion
  }

  // Fetch all reminders from the database as a stream
  Stream<List<MedicineReminder>> get remindersStream async* {
    await for (var _ in _reminderStreamController.stream) {
      yield await fetchRemindersForStream(); // Yield current reminders from database
    }
  }

  // Fetch all reminders from the database
  Future<List<MedicineReminder>> fetchRemindersForStream() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return MedicineReminder.fromMap(maps[i]);
    });
  }

  // Notify the stream that the reminders have been updated
  void _notifyReminderUpdate() async {
    List<MedicineReminder> updatedReminders = await fetchReminders();
    _reminderStreamController.add(updatedReminders); // Emit updated reminders
  }
}