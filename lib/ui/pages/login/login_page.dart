import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
                            ),
                            obscureText: true
                          ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('ENTRAR'),
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
