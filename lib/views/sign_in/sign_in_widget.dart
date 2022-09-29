import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/tsl_form_field.dart';
import 'package:flutter_task_list/views/sign_in/sign_in_bloc.dart';
import 'package:flutter_task_list/views/sign_in/sign_in_models.dart';

class SignInWidget extends StatefulWidget {
  final Function(bool parameters) changeScreen;

  final bloc = SignInBloc();

  SignInWidget({
    super.key,
    required this.changeScreen,
  });

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return ActionHandler(
      actionStream: bloc.onSignInAction,
      onReceived: (action) {
        if (action is SignInSuccessAction) {
          //! rota para home
        } else if (action is SignInErrorAction) {}
      },
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, bottom: 40, top: 100),
            child: Column(
              children: [
                const SizedBox(
                  child: Center(
                    child: Text(
                      "Welcome Back !",
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          height: 60,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: TslFormField(
                                hintText: 'Email',
                                textController: _emailController,
                                onChanged: (email) =>
                                    bloc.onEmailValueChanged.add(email),
                                statusStream:
                                    bloc.onEmailInputStatusChangedStream,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          height: 60,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: TslFormField(
                                hintText: 'Password',
                                textController: _passwordController,
                                onChanged: (password) =>
                                    bloc.onPasswordValueChanged.add(password),
                                statusStream: bloc.onPasswordInputStatusChanged,
                              ),
                            ),
                          ),
                        )
                      ],
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
                          // ignore: prefer_const_literals_to_create_immutables
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text("Doesn't have an account? ",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            InkWell(
                              onTap: () {
                                widget.changeScreen(false);
                              },
                              child: const Text(
                                'Sign In',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 12),
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
                            Expanded(
                              child: TextButton(
                                  onPressed: () => {},
                                  style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(1000, 60)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.indigoAccent)),
                                  child: const Text("Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
