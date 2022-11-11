import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/tsl_form_field.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/settings/modal/edit_user_bloc.dart';
import 'package:flutter_task_list/views/settings/modal/edit_user_models.dart';
import 'package:provider/provider.dart';

class EditUserModal extends StatefulWidget {
  const EditUserModal({
    super.key,
    required this.name,
    required this.bloc,
  });

  final String name;
  final EditUserBloc bloc;

  static Widget create(String name) =>
      ProxyProvider<UserRepository, EditUserBloc>(
        update: (_, userRepository, __) =>
            EditUserBloc(userRepository: userRepository),
        dispose: (_, bloc) => bloc.dispose(),
        child: Consumer<EditUserBloc>(
          builder: (_, bloc, __) => EditUserModal(
            name: name,
            bloc: bloc,
          ),
        ),
      );

  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  EditUserBloc get bloc => widget.bloc;

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  final _createTaskFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController.text = widget.name;
    bloc.onNameValueChanged.add(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActionHandler<EditUserAction>(
      actionStream: bloc.onEditUserAction,
      onReceived: (action) {
        if (action is PopToLogin) {
          displaySnackBar(context, 'User needs to authenticate again!');
          Navigator.of(context).pop;
        } else if (action is SuccessOnEditUser) {
          displaySnackBar(context, 'Success on edit user Infos');
          Navigator.of(context).pop;
        }
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createTaskFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Edit User"),
                  StreamBuilder<SubmitStatus>(
                    stream: bloc.onSubmitStatus,
                    builder: (context, snapshot) {
                      final submitStatus = snapshot.data ?? SubmitStatus.valid;
                      String message;
                      switch (submitStatus) {
                        case SubmitStatus.weakPassword:
                          message = 'Weak Password!';
                          break;
                        case SubmitStatus.invalid:
                          message = 'Some internal error occured. Try again!';
                          break;
                        default:
                          message = ' ';
                      }
                      return Text(
                        message,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TslFormField(
                        height: 60,
                        textController: _nameController,
                        onChanged: (name) => bloc.onNameValueChanged.add(name),
                        statusStream: bloc.onNameInputStatusChangedStream,
                        invalidFormMessage: 'Passwords doesnt match!',
                        borderRadius: BorderRadius.circular(10),
                        contentPadding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TslFormField(
                        height: 60,
                        textController: _passwordController,
                        onChanged: (password) =>
                            bloc.onPasswordValueChanged.add(password),
                        statusStream: bloc.onPasswordInputStatusChanged,
                        borderRadius: BorderRadius.circular(10),
                        contentPadding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TslFormField(
                        height: 60,
                        textController: _passwordConfirmationController,
                        onChanged: (password) => bloc
                            .onPasswordConfirmationValueChanged
                            .add(password),
                        statusStream:
                            bloc.onPasswordConfirmationInputStatusChanged,
                        borderRadius: BorderRadius.circular(10),
                        contentPadding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: bloc.onButtonStatusChanged,
                    builder: (conterx, snapshot) {
                      final buttonStatus = snapshot.data ?? ButtonInactive();

                      return TextButton(
                        onPressed: () => buttonStatus is ButtonActive
                            ? bloc.onSubmitButtonClick.add(null)
                            : null,
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(200, 60)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          backgroundColor: buttonStatus is ButtonActive
                              ? MaterialStateProperty.all<Color>(
                                  Colors.indigoAccent,
                                )
                              : MaterialStateProperty.all<Color>(
                                  Colors.blueGrey,
                                ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
