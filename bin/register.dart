// register.dart
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'db.dart';

// Function to handle user registration
Future<Response> registerUser(Request request) async {
  final payload = await request.readAsString();
  final data = json.decode(payload);

  final username = data['username'];
  final password = data['password'];

  if (username == null || password == null) {
    return Response.badRequest(
      body: json.encode({'error': 'Missing username or password'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Connect to the MySQL database
  final conn = await createConnection();

  try {
    // Insert the new user into the database
    final result = await conn.query(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [
        username,
        password
      ], // Ensure you store passwords securely in a real application
    );

    // Retrieve the auto-generated ID of the newly inserted user
    final userId = result.insertId;

    return Response.ok(
      json.encode({
        'message': 'User registered successfully',
        'user_id': userId, // Include the new user's ID in the response
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    if (e.toString().contains('Duplicate entry')) {
      return Response(
        HttpStatus.conflict,
        body: json.encode({'error': 'Username already exists'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    return Response.internalServerError(
      body: json.encode({'error': 'Failed to register user'}),
      headers: {'Content-Type': 'application/json'},
    );
  } finally {
    await conn.close();
  }
}
