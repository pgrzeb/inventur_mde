import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventur_mde/core/constants/colors.dart';
import 'package:inventur_mde/core/providers/index.dart';
import 'package:inventur_mde/presentation/pages/index.dart';
import 'package:inventur_mde/presentation/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import '../../data/models/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _komnrController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    final komnr = int.tryParse(_komnrController.text);
    final pin = _pinController.text;
    final provider = Provider.of<PersonalProvider>(context, listen: false);

    if (komnr != null && pin.isNotEmpty) {
      final request = PersonalLoginRequest(komnr: komnr, pin: pin);
      try {
        final navigator = Navigator.of(context);

        final response = await provider.login(request);
        if (response.nachricht != null) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.nachricht ?? "Fehler. Dienst nicht aktiv oder Komnr und Passwort stimmen nicht überein!"),
                backgroundColor: AppColors.warningColor, 
                duration: Duration(seconds: 4),),
          );
          _pinController.value = TextEditingValue.empty;
          return;
        }

        final storage = FlutterSecureStorage();

        await storage.write(key: 'komnr', value: response.komnr.toString());
        await storage.write(key: 'komna', value: response.komna);

        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } catch (e) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login fehlgeschlagen: $e'),
            backgroundColor: AppColors.errorColor,
            duration: Duration(seconds: 3),),
        );
      }
    } else {
      // Zeige eine Fehlermeldung an, wenn die Felder leer sind
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte geben Sie eine gültige Komnr und Pin ein'),
            backgroundColor: AppColors.warningColor,
            duration: Duration(seconds: 3),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontSize: 28)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _komnrController,
              decoration: const InputDecoration(
                labelText: 'Komnr',
                floatingLabelStyle:
                    TextStyle(color: AppColors.primaryColor, fontSize: 20),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pinController,
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                labelText: 'Pin',
                floatingLabelStyle:
                    TextStyle(color: AppColors.primaryColor, fontSize: 20),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              obscureText: true,
              onSubmitted: (pin) {
                _login();
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 135,
              child: ButtonWidget(
                onPressed: _login,
                title: 'Login', 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
