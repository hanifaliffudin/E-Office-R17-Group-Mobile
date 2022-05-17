import 'package:countdown_widget/countdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:militarymessenger/Home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart' as mains;
import 'Home.dart' as homes;

String globalEmail = '';

class PinVerification extends StatefulWidget {
  String email = '';

  PinVerification(String email){
    this.email = email;
    globalEmail = email;
  }

  @override
  PinVerificationState createState() => PinVerificationState(email);
}

class PinVerificationState extends State<PinVerification> {
  var fcmToken;
  final _formKey = GlobalKey<FormState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();

  String email = '';

  PinVerificationState(String email){
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
            child: PinPut(
              validator: (s) {
                if (s != null && s.contains('1')) return null;
                return 'NOT VALID';
              },
              useNativeKeyboard: true,
              autovalidateMode: AutovalidateMode.always,
              withCursor: true,
              fieldsCount: 6,
              fieldsAlignment: MainAxisAlignment.spaceAround,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldMargin: EdgeInsets.all(0),
              eachFieldWidth: 45.0,
              eachFieldHeight: 55.0,
              onSubmit: (String pin) => postRequest(pin),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration.copyWith(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(160, 215, 220, 1),
                ),
              ),
              followingFieldDecoration: pinPutDecoration,
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
    print(fcmToken);
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
      print("${response.body}");
      // Map<String, dynamic> userMap = json.decode(response.body);

      //print (userMap.error);
      //pinFailedSnackBar(context,"PIN yang anda masukkan salah!");
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
    return PinPut(
      eachFieldWidth: 50.0,
      eachFieldHeight: 50.0,
      withCursor: true,
      fieldsCount: 4,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      eachFieldMargin: EdgeInsets.symmetric(horizontal: 10),
      onSubmit: (String pin) => postRequest(pin),
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
      textStyle:
      const TextStyle(color: Colors.white, fontSize: 20.0, height: 1),
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
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body
    );


    if(response.statusCode == 200){

      Map<String, dynamic> userMap = jsonDecode(response.body);

      //pinFailedSnackBar(context,"PIN yang anda masukkan salah!");
      //response.user_id;
      //if(pin.toString() == userMap['verification_code'].toString()) {
      //print(userMap['code_status']);
      if(userMap['code_status']==0) {

        //Send data to server

        final user = UserModel(
          userId: userMap['user_id'],
          userName: globalEmail,
          email: globalEmail,
        );
        int id = mains.objectbox.boxUser.put(user);
        print(user.id);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);

      }
      else{
        pinFailedSnackBar(context,"PIN yang anda masukkan salah!");
      }
    }
    else{
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