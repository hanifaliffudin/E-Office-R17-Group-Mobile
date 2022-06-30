import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:militarymessenger/PinVerification.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Home.dart' as homes;

class Login extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<Login>  {
  var fcmToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      fcmToken = value;
      // print(value);
    });
  }
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String apiKey = homes.apiKeyCore;


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('R17 Group',
        style: TextStyle(
          letterSpacing: 2.0,
          fontWeight: FontWeight.bold,
        ),),
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      elevation: 0,
    ),
    body: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.grey,
                autofocus: true,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Email is not valid!';
                  }else if(!value.contains('@r17.co.id')){
                    if(!value.contains('@digiprimatera.co.id')){
                      return "Only the email accounts of R17 and Digiprimatera can login!";
                    }
                  }
                  else if (!EmailValidator.validate(value.trim())) {
                    return 'Email is not valid!';
                  }
                  return null;
                },
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Colors.grey
                    )
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.3,
                  color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _openDialog(context);
                  };
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 0,
                  primary: Color(0xFF2481CF),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white
                  ),
                )),
          ],
        ),
      ),
    ),
  );

  void _openDialog(ctx) {
    showCupertinoDialog(
        context: ctx,
        builder: (_) => CupertinoAlertDialog(
          title: Text("Verify Email"),
          content: Row(
            children: [
              Flexible(
                child: Text("PIN code will be sent to " + _controller.text),
              ),
            ],
          ),
          actions: [
            // Close the dialog
            // You can use the CupertinoDialogAction widget instead
            CupertinoButton(
                child: Text('Edit',
                  style: TextStyle(
                      color: Color(0xFF2481CF)
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                }),
            CupertinoButton(
              child: Text('Verify',
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onPressed: () {
                //kirim email

                sendEmail(_controller.text.trim());

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  PinVerification(_controller.text.trim(), fcmToken)),
                );
              },
            )
          ],
        ));
  }

  Future<http.Response> sendEmail(String email) async {
    print('ini fcm di login.dart: ${fcmToken}');
    String url ='https://chat.dev.r17.co.id/send_email.php';
    Map data = {
      'api_key': apiKey,
      'email': email,
      'fcm_token': fcmToken
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body
    );

    if(response.statusCode == 200){
      // print(response.body);
      // Map<String, dynamic> userMap = json.decode(response.body);

      //pinFailedSnackBar(context,"PIN yang anda masukkan salah!");
    }
    else{
      pinFailedSnackBar(context,"Email gagal dikirim!");
    }
    return response;
  }
}