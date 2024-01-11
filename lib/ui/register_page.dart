import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/server_resp.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/util/sp_util.dart';
import 'package:my_eng_program/util/strings.dart';

import '../data/user.dart';
import '../util/logger.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> with TickerProviderStateMixin {
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  String _name = "";
  String _pwd = "";

  bool _btnEnable = true;
  double _ProgressHeight = 1;

  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  late AnimationController _controller;

  _buildHeader() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color.fromARGB(255, 133, 234, 33), Colors.orange]),
      ),
    );
  }

  _buildNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        onSaved: (newValue) {
          _name = newValue!;
          Logger.debug("Register", " onSaved name = $newValue");
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "用户名不能为空";
          }
          if (value.trim().length > 16) {
            return "用户名长度不能超过16位";
          }
          if (value.trim().length < 6) {
            return "用户名长度不能小于6位";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "用户名",
          labelStyle: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
    );
  }

  _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        onSaved: (newValue) {
          _pwd = newValue!;
          Logger.debug("Register", " onSaved psw = $newValue");
        },
        obscureText: _isObscure,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "密码不能为空";
          }
          if (value.trim().length > 16) {
            return "密码长度不能超过16位";
          }

          if (value.trim().length < 6) {
            return "密码长度不能小于6位";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "密码",
            labelStyle: TextStyle(color: Colors.black, fontSize: 24),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                    _eyeColor = _isObscure ? Colors.grey : Colors.black;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _eyeColor,
                ))),
      ),
    );
  }

  _buildRegisterBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 160),
      child: ElevatedButton(
        onPressed: () async {
          if (!_btnEnable) {
            return;
          }
          setState(() {
            _ProgressHeight = 4;
          });
          _controller.repeat(reverse: true);
          _btnEnable = !_btnEnable;

          if (_FormKey.currentState!.validate()) {
            _FormKey.currentState!.save();
            Logger.debug("Register Button ", "onPressed name=$_name, pwd=$_pwd");

            Service.register(_name, _pwd, App.LOGIN_TYPE_PWD).then((value) {
              Resp resp = value;
              if (resp.isSuccess()) {
                Logger.debug("Register", "Register Success");
                final snackBar = SnackBar(content: Text(Strings.STR_REGISTER_OK));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                SPUtil.getInstance().then((spUtil) {
                  spUtil.setString(Strings.KEY_USER_IDENTIFIER, _name).then((value) => null);
                  spUtil.setString(Strings.KEY_USER_CREDENTIAL, _pwd).then((value) => null);
                  spUtil.setInt(Strings.KEY_USER_LOGIN_TYPE, App.LOGIN_TYPE_PWD).then((value) => null);

                  Service.login(_name, _pwd).then((resp) {
                    App.loginState = resp.error.errorNo == 0;
                    App.user = User.fromJson(resp.data!['user']);

                    _btnEnable = !_btnEnable;
                    setState(() {
                      _ProgressHeight = 1;
                    });
                    _controller.stop(canceled: true);
                    _controller.value = 0;

                    Navigator.pop(context);
                    Navigator.pushNamed(context, App.ROUTE_BOOK_GROUP);
                  });
                });
              } else {
                if (resp.error.errorNo == 1001) {
                  Logger.debug("Register", "Register Failed, User Exist");
                  final snackBar = SnackBar(content: Text(Strings.STR_USER_EXIST));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Logger.debug("Register", "Register Failed, Server Error");
                  final snackBar = SnackBar(content: Text(Strings.STR_REGISTER_FAILED));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                _btnEnable = !_btnEnable;
                setState(() {
                  _ProgressHeight = 1;
                });
                _controller.stop(canceled: true);
                _controller.value = 0;
              }
            });
          }
        },
        child: Text(
          "注册",
          style: TextStyle(color: Colors.black, fontSize: 32),
        ),
      ),
    );
  }

  _buildProgressIndicator() {
    return LinearProgressIndicator(
      semanticsLabel: 'Linear progress indicator',
      minHeight: _ProgressHeight,
      value: _controller.value,
      color: Colors.purple,
      backgroundColor: Colors.grey,
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1,
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
          key: _FormKey,
          child: ListView(
            children: [
              _buildHeader(),
              _buildProgressIndicator(),
              SizedBox(height: 20),
              _buildNameTextField(),
              SizedBox(height: 40),
              _buildPasswordField(),
              SizedBox(height: 80),
              _buildRegisterBtn(),
            ],
          )),
    );
  }
}
