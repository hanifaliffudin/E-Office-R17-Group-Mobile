import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:militarymessenger/PinVerification.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<Login>  {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String apiKey ='1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('e-Office'.toUpperCase(),
      style: TextStyle(
        letterSpacing: 2.0,
        fontWeight: FontWeight.bold,
      ),),
      centerTitle: true,
      backgroundColor: Color(0xFFFAFBF9),
      foregroundColor: Color(0xFF2481CF),
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty || !EmailValidator.validate(value.trim())) {
                  return 'Email is not valid!';
                }
                return null;
              },
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'Enter your email :',
                labelStyle: TextStyle(
                  color: Color(0xFF2481CF)
                )
                ),
              style: TextStyle(
                fontSize: 19.0,
                height: 1.3,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PIN code will be sent to your email.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Container(
            height: 110,
            child: Column(
              children: [
                Text('We will be verifying the email address'),
                SizedBox(
                  height: 30,
                ),
                Text('Is this OK or would you like to edit the email address?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: _submit,
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
      child: const Icon(Icons.send),
    ),
  );

  void _submit(){
    if (_formKey.currentState!.validate()) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sedang memproses.')),
      );*/
      //kirim email

      sendEmail(_controller.text.trim());

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>  PinVerification(_controller.text.trim())),
      );
    }
  }

  Future<http.Response> sendEmail(String email) async {
    String url ='https://chat.dev.r17.co.id/send_email.php';
    Map data = {
      'api_key': this.apiKey,
      'email': email
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body
    );

    if(response.statusCode == 200){
      print("${response.body}");
      Map<String, dynamic> userMap = jsonDecode(response.body);

      //print (userMap.error);
      //pinFailedSnackBar(context,"PIN yang anda masukkan salah!");


    }
    else{
      pinFailedSnackBar(context,"Email gagal dikirim!");
    }
    return response;
  }
}