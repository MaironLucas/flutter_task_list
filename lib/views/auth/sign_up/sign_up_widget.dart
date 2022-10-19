import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/tsl_form_field.dart';
import 'package:flutter_task_list/views/auth/sign_up/sign_up_bloc.dart';
import 'package:flutter_task_list/views/auth/sign_up/sign_up_models.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  final Function(bool parameters) changeScreen;
  final SignUpBloc bloc;

  const SignUpWidget({
    super.key,
    required this.changeScreen,
    required this.bloc,
  });

  static Widget create(Function(bool parameters) changeScreen) =>
      ProxyProvider<UserRepository, SignUpBloc>(
        update: (_, userRepository, __) => SignUpBloc(
          userRepository: userRepository,
        ),
        dispose: (_, bloc) => bloc.dispose(),
        child: Consumer<SignUpBloc>(
          builder: (_, bloc, __) => SignUpWidget(
            changeScreen: changeScreen,
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfirmationController = TextEditingController();

    final signUpFormKey = GlobalKey<FormState>();

    return ActionHandler(
      actionStream: bloc.onSignUpAction,
      onReceived: (action) {
        if (action is SignUpSuccessAction) {
          displaySnackBar(context, 'User created successfully');
          changeScreen(true);
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30.0, right: 30, bottom: 40, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7.5),
                child: Column(
                  children: [
                    Text(
                      "Welcome Onboard !",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const Text(
                      "Let's help you to meet your task.",
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<SubmitStatus>(
              stream: bloc.onSubmitStatus,
              builder: (context, snapshot) {
                final submitStatus = snapshot.data ?? SubmitStatus.valid;
                String message;
                switch (submitStatus) {
                  case SubmitStatus.emailAlreadyUsed:
                    message = 'Given email is already used!';
                    break;
                  case SubmitStatus.weakPassword:
                    message =
                        'Weak Password! Should have at least 6 characters';
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
              height: 400,
              child: Form(
                key: signUpFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TslFormField(
                        hintText: 'Full Name',
                        emptyFormMessage: 'Field name is necessary!',
                        invalidFormMessage: 'Given name is invalid!',
                        textController: nameController,
                        onChanged: (name) => bloc.onNameValueChanged.add(name),
                        statusStream: bloc.onNameInputStatusChangedStream,
                      ),
                      TslFormField(
                        hintText: 'Email',
                        emptyFormMessage: 'Field email is necessary!',
                        invalidFormMessage: 'Given email is invalid!',
                        textController: emailController,
                        onChanged: (email) =>
                            bloc.onEmailValueChanged.add(email),
                        statusStream: bloc.onEmailInputStatusChangedStream,
                      ),
                      TslFormField(
                        hintText: 'Password',
                        emptyFormMessage: 'Field password is necessary!',
                        invalidFormMessage: 'Given password is invalid!',
                        textController: passwordController,
                        onChanged: (password) =>
                            bloc.onPasswordValueChanged.add(password),
                        statusStream: bloc.onPasswordInputStatusChanged,
                      ),
                      TslFormField(
                        hintText: 'Password Confirmation',
                        emptyFormMessage: 'Please, confirm password!',
                        invalidFormMessage: 'Passwords doesnt match!',
                        textController: passwordConfirmationController,
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
            SizedBox(
              height: 105,
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
          ],
        ),
      ),
    );
  }
}
