import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Importa las opciones generadas por flutterfire_cli
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart'; // Tu pantalla principal
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización correcta utilizando la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'PetVerse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        // Validamos el estado del usuario en tiempo real[cite: 10]
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.user == null) {
              return const LoginScreen();
            }
            return HomeScreen();
          },
        ),
      ),
    );
  }
}