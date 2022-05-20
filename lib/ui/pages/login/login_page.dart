import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';

import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 240,
                    margin: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).primaryColorLight,
                          Theme.of(context).primaryColorDark
                        ]
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                          blurRadius: 4,
                          color: Colors.black
                        )
                      ],
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(80))
                    ),
                    child: const Image(image: AssetImage('lib/ui/assets/logo.png')),
                  ),
                  Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<UIError?>(
                            stream: presenter.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                                  errorText: snapshot.data?.description
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: presenter.validateEmail,
                              );
                            }
                          ),
                          StreamBuilder<UIError?>(
                            stream: presenter.passwordErrorStream,
                            builder: (context, snapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 32),
                                child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
                                  errorText: snapshot.data?.description
                                ),
                                obscureText: true,
                                onChanged: presenter.validatePassword,
                              ),
                              );
                            }
                          ),
                          const ElevatedButton(
                            onPressed: null,
                            child: Text('ENTRAR'),
                          ),
                          TextButton.icon(
                            onPressed: (){},
                            icon: const Icon(Icons.person),
                            label: const Text('Adicionar conta')
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
