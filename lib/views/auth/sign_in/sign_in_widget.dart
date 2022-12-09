import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/login_state_handler.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/tsl_form_field.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_bloc.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_models.dart';
import 'package:flutter_task_list/views/home/home_view.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatefulWidget {
  final Function(int parameters) changeScreen;

  final SignInBloc bloc;

  const SignInWidget({
    super.key,
    required this.changeScreen,
    required this.bloc,
  });

  static Widget create(Function(int parameters) changeScreen) =>
      ProxyProvider2<UserRepository, LoginStateHandler, SignInBloc>(
        update: (_, userRepository, dummyState, __) => SignInBloc(
          userRepository: userRepository,
          dummyStateHandler: dummyState,
        ),
        dispose: (_, bloc) => bloc.dispose(),
        child: Consumer<SignInBloc>(
          builder: (_, bloc, __) => SignInWidget(
            bloc: bloc,
            changeScreen: changeScreen,
          ),
        ),
      );

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage.create(),
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, bottom: 40, top: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        "Welcome Back !",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<SubmitStatus>(
                  stream: bloc.onSubmitStatus,
                  builder: (context, snapshot) {
                    final submitStatus = snapshot.data ?? SubmitStatus.valid;
                    String message;
                    switch (submitStatus) {
                      case SubmitStatus.wrongCredentials:
                        message = 'Invalid email or password!';
                        break;
                      case SubmitStatus.invalid:
                        message = 'Some internal error occured. Try again!';
                        break;
                      default:
                        message = ' ';
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 190,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TslFormField(
                            hintText: 'Email',
                            emptyFormMessage: 'Email field is required',
                            invalidFormMessage: 'Given email is invalid',
                            textController: _emailController,
                            onChanged: (email) =>
                                bloc.onEmailValueChanged.add(email),
                            statusStream: bloc.onEmailInputStatusChangedStream,
                          ),
                          // Expanded(child: Container()),
                          TslFormField(
                            hintText: 'Password',
                            emptyFormMessage: 'Password field is required',
                            textController: _passwordController,
                            onChanged: (password) =>
                                bloc.onPasswordValueChanged.add(password),
                            statusStream: bloc.onPasswordInputStatusChanged,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 105,
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
                              widget.changeScreen(1);
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
                                              Colors.blue,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
