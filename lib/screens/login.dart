import 'package:amodeus_api/amodeus_api.dart' show AmodeusApi;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Почта на домене @study.utmn.ru",
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || !RegExp(r".+@study.utmn.ru").hasMatch(value)) {
                      return "Укажите почту на домене @study.utmn.ru";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: "Пароль",
                    icon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Пароль не должен быть пустым";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_form.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("stub")),
                      );
                      final api = AmodeusApi().getAuthApi();
                      // await api.loginAuthPost(username: _form, password: password)
                    }
                  },
                  child: const Text("Войти"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
