import 'package:controlbomberos/ui/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: BlocListener<LoginCubit, LoginState>(
                listenWhen: (previous, current) {
                  return previous.status != current.status;
                },
                listener: (context, state) {
                  if (state.status == Status.failure) {
                    //Fluttertoast.showToast(
                    //  msg: 'Algo salió mal. Intenta nuevamente ...',
                    //);
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Sistema De ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue,
                        ),
                        children: [
                          TextSpan(
                            text: ' Control Electoral',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Login Page',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // OnboardingDivider(color: AppColors.darkGrey),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Your email'),
                      ),
                      onChanged: cubit.onEmailChanged,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                      onChanged: cubit.onPasswordChanged,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          onPressed: () async {
            await cubit.onLogin();
            if (cubit.state.status == Status.success) {
              Fluttertoast.showToast(
                msg: 'Login Correctamente', // Message to display in the toast
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 2, // Background color of the toast
              );
              /*navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppNavigator.home,
                (route) => false,
              );*/
            } else if (cubit.state.status == Status.failure) {
              Fluttertoast.showToast(
                msg: 'Algo salió mal. Intenta nuevamente ...',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 2,
              );
            } else if (cubit.state.status == Status.invalid) {
              Fluttertoast.showToast(
                msg: 'Email o contraseña inválidos',
                backgroundColor: Colors.red,
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 2,
              );
            } else {
              Fluttertoast.showToast(
                msg: 'Estado no reconocido',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 2,
              );
            }
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
