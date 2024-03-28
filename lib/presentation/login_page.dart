// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:bloc_ecommerce/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    checkAuth();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  void checkAuth() async {
    final auth = await LocalDataSource().getToken();
    if (auth.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return const HomePage();
      }));
    }
  }

  @override
  void dispose() {
    super.dispose();

    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
          actions: const [],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text("Login User")),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElavatedButton(
                  onPressed: () {
                    final requestModel = LoginRequestModel(
                      email: emailController!.text,
                      password: passwordController!.text);
                    context.read<LoginBloc>().add(
                      DoLoginEvent(model: requestModel),
                      );
                  },
                child: const Text('Login'));
              },
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  ));
              }
              if (state is LoginLoaded){
                LocalDataSource().saveToken(state.model.accesToken);
                ScaffoldMessager.of(context).showSnackBar(const SnackBar(
                  content: Text('Login Success'),
                  backgroundColor: Colors.blue,
                  ));
                Navigator.push(context, MaterialPageRoute(
                  builder:(context){
                    return cons HomePage();
                  }));
                }
              },
              ), 
              const SizedBox(
              height: 16.0,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (_){
                    return const RegisterPage();
                  }));
                },
                child: const Text('Belum punya akun? Register'),
            )
          ],
        ),
      ),
    );
  }
}
