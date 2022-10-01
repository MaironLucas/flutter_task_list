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

  final _loginFormKey = GlobalKey<FormState>();

  SignInBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return ActionHandler(
      actionStream: bloc.onSignInAction,
      onReceived: (action) {
        if (action is SignInSuccessAction) {
          //! rota para home
        }
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
              StreamBuilder<SubmitStatus>(
                  stream: bloc.onSubmitStatus,
                  builder: (context, snapshot) {
                    final submitStatus = snapshot.data;
                    if (submitStatus == SubmitStatus.wrongCredentials) {
                      return const Text(
                        'Email ou senha inválidos!',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      );
                    }
                    return Container();
                  }),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                          const Text("Doesn't have an account? ",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          InkWell(
                            onTap: () {
                              widget.changeScreen(false);
                            },
                            child: const Text(
                              'Sign Up',
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
                            child: StreamBuilder<ButtonState>(
                                stream: bloc.onButtonStatusChanged,
                                builder: (context, snapshot) {
                                  final buttonStatus =
                                      snapshot.data ?? ButtonInactive();

                                  if (buttonStatus is ButtonLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return TextButton(
                                    onPressed: () =>
                                        buttonStatus is ButtonActive
                                            ? bloc.onSubmitButtonClick.add(null)
                                            : null,
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(1000, 60)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      backgroundColor: buttonStatus
                                              is ButtonActive
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.indigoAccent,
                                            )
                                          : MaterialStateProperty.all<Color>(
                                              Colors.blueGrey,
                                            ),
                                    ),
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }),
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
      ),
    );
  }
}
