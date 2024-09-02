// userDetails.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'db.dart';

// Function to handle fetching user details by ID
Future<Response> fetchUserDetails(Request request, String userId) async {
  // Connect to the MySQL database
  final conn = await createConnection();

  try {
    // Query to get user details from the database
    final results = await conn.query(
      'SELECT id, username FROM users WHERE id = ?',
      [int.parse(userId)],
    );

    if (results.isNotEmpty) {
      // Extract the user details
      final row = results.first;
      final userDetails = {
        'id': row['id'],
        'username': row['username'],
      };

      return Response.ok(
        json.encode(userDetails),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.notFound(
        json.encode({'error': 'User not found'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: json.encode({'error': 'Failed to fetch user details'}),
      headers: {'Content-Type': 'application/json'},
    );
  } finally {
    await conn.close();
  }
}
