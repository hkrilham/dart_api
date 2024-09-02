import 'package:mysql1/mysql1.dart';

// MySQL database connection settings
final settings = ConnectionSettings(
  host: 'localhost', // Change to your MySQL host
  port: 3306,
  user: 'root', // Replace with your MySQL username
  password: 'root', // Replace with your MySQL password
  db: 'dart1', // The name of your database
);

// Function to create a MySQL connection
Future<MySqlConnection> createConnection() async {
  return await MySqlConnection.connect(settings);
}

// Function to initialize the database and create tables if they do not exist
Future<void> initializeDatabase() async {
  final conn = await createConnection();

  try {
    // SQL statement to create the 'users' table if it does not exist
    await conn.query('''
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL
      )
    ''');
  } catch (e) {
    print('Failed to create table: $e');
  } finally {
    await conn.close();
  }
}
