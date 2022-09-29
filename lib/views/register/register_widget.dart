import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  Function(bool parameters) changeScreen;
  RegisterWidget({super.key, required this.changeScreen});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
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
                                    hintText: 'Full name',
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
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
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
                                  hintText: 'Confirm Password',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text("Already have an account? ",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          InkWell(
                            onTap: () {
                              widget.changeScreen(true);
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
                                child: const Text("Register",
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
