import 'package:flutter/material.dart';

class FormTestRoute extends StatefulWidget {
  const FormTestRoute({super.key});

  @override
  State<FormTestRoute> createState() => _FormTestRouteState();
}

class _FormTestRouteState extends State<FormTestRoute> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Test Route')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              controller: _unameController,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "用户名或邮箱",
                icon: Icon(Icons.person),
              ),
              //校验用户名
              validator: (v) {
                return v!.trim().isNotEmpty ? null : "用户名不能为空";
              },
            ),
            TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "您的登录密码",
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
              //校验密码
              validator: (v) {
                return v!.trim().length > 5 ? null : "密码不能少于6位";
              },
            ),

            //登陆按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("登录"),
                      ),
                      onPressed: () {
                        //通过formKey.currentState
                        if((_formKey.currentState as FormState).validate()) {
                          //验证通过提交数据
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}
