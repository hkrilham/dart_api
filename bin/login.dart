// login.dart
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import "package:shelf/shelf.dart";
import 'db.dart';

// Function to handle user login
Future<Response> loginUser(Request request) async {
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
    // Check if the user exists and the password matches
    final results = await conn.query(
      'SELECT id FROM users WHERE username = ? AND password = ?',
      [
        username,
        password
      ], // Ensure you securely compare hashed passwords in a real application
    );

    if (results.isNotEmpty) {
      return Response.ok(
        json.encode({'message': 'Login successful'}),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response(
        HttpStatus.unauthorized,
        body: json.encode({'error': 'Invalid username or password'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: json.encode({'error': 'Failed to log in user'}),
      headers: {'Content-Type': 'application/json'},
    );
  } finally {
    await conn.close();
  }
}
