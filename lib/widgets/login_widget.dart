import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  Function(bool parameters) changeScreen;

  LoginWidget({
    super.key,
    required this.changeScreen,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: TextField(
                                style: TextStyle(fontSize: 12),
                                cursorColor: Color.fromRGBO(49, 45, 84, 1),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey))),
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
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: TextField(
                              style: TextStyle(fontSize: 12),
                              cursorColor: Color.fromRGBO(49, 45, 84, 1),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
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
        ));
  }
}
