import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/tsl_form_field.dart';
import 'package:flutter_task_list/views/sign_up/sign_up_bloc.dart';
import 'package:flutter_task_list/views/sign_up/sign_up_models.dart';

class SignUp extends StatelessWidget {
  final Function(bool parameters) changeScreen;
  SignUp({super.key, required this.changeScreen});

  final bloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _passwordConfirmationController = TextEditingController();

    final _signUpFormKey = GlobalKey<FormState>();

    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30.0, right: 30, bottom: 40, top: 100),
        child: Column(
          children: [
            const SizedBox(
              child: Center(
                child: Text(
                  "Welcome Onboard !",
                ),
              ),
            ),
            const SizedBox(
              child: Center(
                child: Text(
                  "Let's help you meet your task.",
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: Form(
                key: _signUpFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TslFormField(
                        hintText: 'Full Name',
                        textController: _nameController,
                        onChanged: (name) => bloc.onNameValueChanged.add(name),
                        statusStream: bloc.onNameInputStatusChangedStream,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TslFormField(
                        hintText: 'Email',
                        textController: _emailController,
                        onChanged: (email) =>
                            bloc.onEmailValueChanged.add(email),
                        statusStream: bloc.onEmailInputStatusChangedStream,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TslFormField(
                        hintText: 'Password',
                        textController: _passwordController,
                        onChanged: (password) =>
                            bloc.onPasswordValueChanged.add(password),
                        statusStream: bloc.onPasswordInputStatusChanged,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TslFormField(
                        hintText: 'Password Confirmation',
                        textController: _passwordConfirmationController,
                        onChanged: (password) => bloc
                            .onPasswordConfirmationValueChanged
                            .add(password),
                        statusStream:
                            bloc.onPasswordConfirmationInputStatusChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        InkWell(
                          onTap: () {
                            changeScreen(true);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 30,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Color.fromRGBO(217, 217, 217, 0.4),
                    ),
                    Row(
                      children: [
                        StreamBuilder<ButtonState>(
                          stream: bloc.onButtonStatusChanged,
                          builder: (context, snapshot) {
                            final buttonStatus =
                                snapshot.data ?? ButtonInactive();

                            return Expanded(
                              child: TextButton(
                                onPressed: () => buttonStatus is ButtonActive
                                    ? bloc.onSubmitButtonClick.add(null)
                                    : null,
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(1000, 60)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  backgroundColor: buttonStatus is ButtonActive
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.indigoAccent,
                                        )
                                      : MaterialStateProperty.all<Color>(
                                          Colors.blueGrey,
                                        ),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
