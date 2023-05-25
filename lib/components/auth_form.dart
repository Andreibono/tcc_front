import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/models/user.dart';

import '../models/auth.dart';
import '../util/DialogUtils.dart';
import '../util/app_routes.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final fieldTextName = TextEditingController();
  final fieldTextEmail = TextEditingController();
  final fieldTextPassword = TextEditingController();
  final fieldTextConfirmPassword = TextEditingController();

  void clearText() {
    fieldTextName.clear();
    fieldTextEmail.clear();
    fieldTextPassword.clear();
    fieldTextConfirmPassword.clear();
  }

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'confirmPassword': '',
    'name': ''
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    clearText();
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  Future<void> _setUserInformationFromLogin (User user, Auth auth) async {
    if (user.error_message == '') {
        user.password = _authData['password'];
        //login com sucesso
        // get das Empresas do Usuário
        user = await auth.fetchCompanies(user.token);

        //get dos projetos do Usuário
        user = await auth.fetchProjects(user.token);

        //get das atividades do Usuário
        user = await auth.fetchActivities(user.token);
        

        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.HOME, (route) => false,
            arguments: user);
      } else {
        //tratamento de erro 
        DialogUtils.showCustomDialog(context,
          title: "Erro",
          content: user.error_message);
      }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    User user = User();
    if (_isLogin()) {
      user = await auth.login(_authData['email']!, _authData['password']!);
      await _setUserInformationFromLogin(user, auth);

    } else {
      await auth.singup(_authData['email']!, _authData['password']!,
          _authData['confirmPassword']!, _authData['name']!);
      user = await auth.login(_authData['email']!, _authData['password']!);
      await _setUserInformationFromLogin(user, auth);
    }

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: deviceSize.width * 0.75,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_isSignup())
                    TextFormField(
                      onChanged: (name) => '',
                      decoration: InputDecoration(labelText: 'Nome'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (name) => _authData['name'] = name ?? '',
                      controller: fieldTextName,
                    ),
                  TextFormField(
                    onChanged: (email) => '',
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) => _authData['email'] = email ?? '',
                    validator: (_email) {
                      final email = _email ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                    controller: fieldTextEmail,
                  ),
                  TextFormField(
                    onChanged: (password) => '',
                    decoration: InputDecoration(labelText: 'Senha'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    onSaved: (password) =>
                        _authData['password'] = password ?? '',
                    validator: (_password) {
                      final password = _password ?? '';
                      if (password.isEmpty) {
                        return 'Informe uma senha válida';
                      }
                      return null;
                    },
                    controller: fieldTextPassword,
                  ),
                  if (_isSignup())
                    TextFormField(
                      onChanged: (value) => '',
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      onSaved: (confirmPassword) =>
                          _authData['confirmPassword'] = confirmPassword ?? '',
                      controller: fieldTextConfirmPassword,
                    ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        _authMode == AuthMode.Login ? 'Entrar' : 'Registrar',
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8)),
                    ),
                  TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(_isLogin()
                          ? 'Deseja Registrar?'
                          : 'Já possui conta?')),
                ],
              )),
        ));
  }
}
