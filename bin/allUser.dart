// allUser.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'db.dart';

// Function to handle fetching all users
Future<Response> fetchAllUsers(Request request) async {
  // Connect to the MySQL database
  final conn = await createConnection();

  try {
    // Query to get all users from the database
    final results = await conn.query('SELECT id, username FROM users');

    // Convert the results to a list of maps
    final users = results
        .map((row) => {'id': row['id'], 'username': row['username']})
        .toList();

    return Response.ok(
      json.encode({'users': users}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: json.encode({'error': 'Failed to fetch users'}),
      headers: {'Content-Type': 'application/json'},
    );
  } finally {
    await conn.close();
  }
}
