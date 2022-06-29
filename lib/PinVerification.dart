import 'package:countdown_widget/countdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/Home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';

import 'main.dart' as mains;
import 'Home.dart' as homes;

String globalEmail = '';

class PinVerification extends StatefulWidget {
  String email = '';
  String? fcmToken;

  PinVerification(String email, this.fcmToken){
    this.email = email;
    globalEmail = email;
  }

  @override
  PinVerificationState createState() => PinVerificationState(email, fcmToken);
}

class PinVerificationState extends State<PinVerification> {
  String? fcmToken;
  final _formKey = GlobalKey<FormState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();

  String email = '';

  PinVerificationState(String email, this.fcmToken){
    this.email = email;
    globalEmail = email;
  }

  String apiKey = homes.apiKeyCore;

  int _pageIndex = 0;

  final List<Widget> _pinPuts = [];

  final List<Color> _bgColors = [
    Colors.white,
    const Color.fromRGBO(43, 36, 198, 1),
    Colors.white,
    const Color.fromRGBO(75, 83, 214, 1),
    const Color.fromRGBO(43, 46, 66, 1),
  ];

  @override
  void initState() {
    _pinPuts.addAll([
      onlySelectedBorderPinPut(),
    ]);
    super.initState();
  }

  late CountDownController _countDownController;

  void restart() {
    _countDownController.restart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'.toUpperCase(),
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),),
        // automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(top:0,bottom: 40,left: 40,right: 40),
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _pageIndex = index);
                },
                children: _pinPuts.map((p) {
                  return FractionallySizedBox(
                    heightFactor: 1.0,
                    child: Center(child: p),
                  );
                }).toList(),
              ),
            ),
            //_bottomAppBar,
          ],
        ),
      ),
    );
  }

  Widget onlySelectedBorderPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5.0),
    );
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'Enter 6 digit code we sent to ' + email,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onLongPress: () {
              print(_formKey.currentState?.validate());
            },
            child: Pinput(
              onCompleted: (String pin) => postRequest(pin),
              useNativeKeyboard: true,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              length: 6,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              defaultPinTheme: PinTheme(
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                margin: EdgeInsets.all(0),
                width: 45,
                height: 55,
                decoration: pinPutDecoration,
              ),
              onSubmitted: (String pin) => postRequest(pin),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              focusedPinTheme: PinTheme(
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                margin: EdgeInsets.all(0),
                width: 45,
                height: 55,
                decoration: pinPutDecoration.copyWith(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: const Color.fromRGBO(160, 215, 220, 1),
                    ),
                  ),
              ),
              pinAnimationType: PinAnimationType.scale,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CountDownWidget(
            duration: Duration(seconds: 40),
            builder: (context, duration) {
              return Column(
                children: [
                  Text('00.' + duration.inSeconds.toString(),
                    style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                        fontSize: 14
                    ),
                  ),
                  SizedBox(height: 30,),
                  Visibility(
                      visible: duration.inSeconds == 0,
                      child: Column(
                        children: [
                          Text('Haven\'t recieved the code?',
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: () {
                              restart();
                              _submit();
                            },
                            child: Text('Resend code',
                              style: TextStyle(
                                color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),),
                          ),
                        ],
                      )
                  )
                ],
              );
            },
            onControllerReady: (controller) {
              _countDownController = controller;
            },
            onDurationRemainChanged: (duration) {
              print('duration:${duration.toString()}');
            },
          )
        ],
      ),
    );
  }

  Future<http.Response> sendEmail(String email) async {
    String url ='https://chat.dev.r17.co.id/send_email.php';
    Map data = {
      'api_key': this.apiKey,
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
      // print("${response.body}");
    }
    else{
      pinFailedSnackBar(context,"Email gagal dikirim!");
    }
    return response;
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color(0xFF2381d0),
      borderRadius: BorderRadius.circular(15.0),
    );
    return Pinput(
      defaultPinTheme: PinTheme(
        textStyle: const TextStyle(color: Colors.white, fontSize: 20.0, height: 1),
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 50,
        height: 50,
        decoration: pinPutDecoration,
      ),
      showCursor: true,
      length: 4,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      onSubmitted: (String pin) => postRequest(pin),
      focusedPinTheme: PinTheme(
        textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
        margin: EdgeInsets.all(0),
        width: 45,
        height: 55,
        decoration: pinPutDecoration
      ),
      // submittedFieldDecoration: pinPutDecoration,
      // selectedFieldDecoration: pinPutDecoration,
      // followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }

  Widget get _bottomAppBar {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            onPressed: () => _pinPutFocusNode.requestFocus(),
            child: const Text('Focus'),
          ),
          TextButton(
            onPressed: () => _pinPutFocusNode.unfocus(),
            child: const Text('Unfocus'),
          ),
          TextButton(
            onPressed: () => _pinPutController.text = '',
            child: const Text('Clear All'),
          ),
          TextButton(
            child: Text('Paste'),
            onPressed: () => _pinPutController.text = '234',
          ),
        ],
      ),
    );
  }

  void _submit() {
    //kirim email
    sendEmail(email);
  }

  Future<http.Response> postRequest(String pin) async {
    String url ='https://chat.dev.r17.co.id/register.php';
    Map data = {
      'api_key': this.apiKey,
      'email': globalEmail,
      'pin': pin,
      'fcm_token': fcmToken,
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body
    );


    if(response.statusCode == 200){

      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status']==0) {

        final user = UserModel(
          userId: userMap['user_id'],
          userName: globalEmail,
          email: globalEmail,
          fcmToken: fcmToken,
        );

        mains.objectbox.boxUser.put(user);
        print('ini fcm di pinverif.dart: ${user.fcmToken}');
        print('ini fcm old: ${userMap['fcm_old']}');
        print('ini last_connection: ${userMap['last_connection']}');

        if(userMap['last_connection'] != 0){
          // sink last conn
          var msg = {};
          msg["api_key"] = apiKey;
          msg["decrypt_key"] = "";
          msg["type"] = "logout";
          msg["msg_tipe"] = 'text';
          msg["room_id"] = 12;

          String msgString = json.encode(msg);
          // print(msgString);

          homes.channel.sink.add(msgString);
        }

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);

      }
      else{
        pinFailedSnackBar(context,"PIN yang anda masukkan salah!");
      }
    }
    else{
      print(response);
      print('status code: ${response.statusCode}');
      pinFailedSnackBar(context,"Verifikasi gagal!");
    }
    return response;
  }

}

void pinFailedSnackBar(context,text){
  pinFailedSnackBar;
  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    content: Container(
      height: 25.0,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
    ),
    backgroundColor: Color(0xfffc125d),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

class RoundedButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2381d0),
        ),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}