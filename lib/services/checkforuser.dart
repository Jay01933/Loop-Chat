import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

final databaseref = FirebaseDatabase.instance.ref('Database').child('user');

final List<String> user = [];
final List<String> usersfromdatabase = [];

Future<bool> getUserInput(String userInput) async {
  user.add(userInput);
  log(userInput);
  try {
    DatabaseEvent event = await databaseref.once();
    DataSnapshot snapshot = event.snapshot;

    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      data.forEach((key, value) {
        log("Key: $key, Value: $value");
        usersfromdatabase.add(value.toString());
      });
    } else {
      log("No data found.");
    }
  } catch (e) {
    log("Error reading data: $e");
  }
  for (String userData in usersfromdatabase) {
    log(userData);
  }

  return user.every((element) => usersfromdatabase.contains(element));
}
