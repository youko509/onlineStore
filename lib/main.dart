import 'package:flutter/material.dart';
import 'login.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('box');
  await Hive.openBox('fav');
  runApp(const LoginApp(),);
}
