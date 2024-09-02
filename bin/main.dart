import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'register.dart';
import 'login.dart';
import 'allUser.dart';
import 'userDetails.dart';
import 'db.dart'; // Import the db.dart file to use initializeDatabase()

void main() async {
  // Initialize the database and create tables if needed
  await initializeDatabase();

  // Create a router to handle API routes
  final router = Router();

  // Register route for user registration
  router.post('/register', registerUser);

  // Login route for user authentication
  router.post('/login', loginUser);

  // Route to fetch all users
  router.get('/all-users', fetchAllUsers);

  // Route to fetch user details by user ID
  router.get('/user/<userId>', fetchUserDetails);

  // Set up the server and start listening for requests
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  final ip = InternetAddress.anyIPv4;
  final port = 8080;

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
