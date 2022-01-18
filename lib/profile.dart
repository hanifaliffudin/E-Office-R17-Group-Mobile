import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart' as mains;
import 'package:http/http.dart' as http;

import 'models/UserModel.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String apiKey ='1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3P';

  final String? email = mains.objectbox.boxUser.get(1)?.email;
  String? name = "";
  String? phone = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'.toUpperCase()),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2481CF),
        elevation: 0,
      ),
      body: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF6F6F6),
          ),
          child: ListView(
            children: [
              Container( //Avatar Section
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xffF2F1F6),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Colors.white,
                              height: 220,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffE6E6E8)
                                              )
                                          )
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            fixedSize: Size(500, 50),
                                            elevation: 0
                                        ),
                                        child: const Text(
                                          'Delete Photo',
                                          style: TextStyle(
                                              color: Colors.red
                                          ),),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffE6E6E8)
                                              )
                                          )
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            fixedSize: Size(500, 50),
                                            elevation: 0
                                        ),
                                        child: const Text(
                                          'Take Photo',
                                          style: TextStyle(
                                              color: Colors.black
                                          ),),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffE6E6E8)
                                              )
                                          )
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            fixedSize: Size(500, 50),
                                            elevation: 0
                                        ),
                                        child: const Text(
                                          'Choose Photo',
                                          style: TextStyle(
                                              color: Colors.black
                                          ),),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          fixedSize: Size(500, 50),
                                          elevation: 0
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.black
                                        ),),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue
                        ),),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: Color(0xffE6E6E8)
                        ),
                        bottom: BorderSide(
                            color: Color(0xffE6E6E8)
                        )
                    )
                ),
                child: Text(
                  name!
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6)
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  "PHONE NUMBER",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: Color(0xffE6E6E8)
                        ),
                        bottom: BorderSide(
                            color: Color(0xffE6E6E8)
                        )
                    )
                ),
                child: Text(
                    phone!
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6)
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  "ABOUT",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: Color(0xffE6E6E8)
                        ),
                        bottom: BorderSide(
                            color: Color(0xffE6E6E8)
                        )
                    )
                ),
                child: Row(
                  children: [
                    Text("busy",
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> getData() async {
    String url ='https://chat.dev.r17.co.id/get_user.php';
    Map<String, dynamic> data = {
      'api_key': this.apiKey,
      'email': email,
    };

    //encode Map to JSON
    //var body = "?api_key="+this.apiKey;

    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode(data),
    );
    if(response.statusCode == 200){
      //print("${response.body}");
      Map<String, dynamic> userMap = jsonDecode(response.body);

      if(userMap['code_status'] == 0){
        setState(() {
          final user = UserModel(
            userName: userMap['name'],
            phone: userMap['phone'],
          );
          int id = mains.objectbox.boxUser.put(user);
          name = userMap['name'];
          phone = userMap['phone'];
        });
        print(userMap['name']);
      }else{
        print("ada yang salah!");
      }
    }
    else{
      print("Gagal terhubung ke server!");
    }
    return response;
  }

}
