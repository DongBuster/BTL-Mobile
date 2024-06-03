import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase/firebase_options.dart';
import 'routes/route_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ixxvhqgtzttjzkgqihed.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4eHZocWd0enR0anprZ3FpaGVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTczMDk5MDIsImV4cCI6MjAzMjg4NTkwMn0.W0YqWJKMcWLc2xnme0Ggp3ml-QBqaJE-obTC-ace6Tw',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routeConfig,
    );
  }
}
