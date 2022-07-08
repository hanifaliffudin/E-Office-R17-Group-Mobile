import 'package:flutter/material.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  double _height=0;
  double _width=0;

  @override
  Widget build(BuildContext context) {
    _height=MediaQuery.of(context).size.height;
    _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          child:Padding(
            padding:EdgeInsets.only(top:10.0),
            child:Icon(Icons.arrow_back_ios,color: Colors.black87,),
          ),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[

          Container(
            //alignment: Alignment.centerRight,
              height: _height/16,
              width: _width/8,
              margin: EdgeInsets.only(right:20.0,top:10.0),
              //color: Colors.cyanAccent,
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundImage:  Image.asset("assets/images/defaultuser.png").image,
                backgroundColor: Color(0xffF2F1F6),
                radius: 20,
              )
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height:_height/8,
              width:_width,
              child: ListTile(
                leading: Container(
                  alignment: Alignment.topLeft,
                  height: _height/12,
                  width: _width/5.0,
                  //color: Colors.grey,
                  child:Icon(Icons.folder, size: 50,color: Colors.grey,),
                ),

                title: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text('Rizki Tujuhbelas Kelola',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                ),

                subtitle: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Storage',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600),),
                          Container(
                            margin: EdgeInsets.only(right:30.0),
                            // color: Colors.green,
                            alignment: Alignment.topRight,
                            child: Text('6/15 GB',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                      SizedBox(height:5.0,),

                      Row(
                        children: <Widget>[
                          Container(
                            height: _height/120.0,
                            width: _width/4.5,
                            color: Colors.yellow,
                          ),
                          Container(
                            height: _height/120.0,
                            width: _width/2.8,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child:ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
                child:Container(
                  // padding: EdgeInsets.only(bottom:0.0,top:10.0),
                  height:_height,
                  width: _width,
                  color: Colors.blue[700],
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 30.0,left: 20.0),
                            // alignment: Alignment.topLeft,
                            // height:_height/16,
                            child: Text('Folders',style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),

                          Container(
                            padding: EdgeInsets.only(top: 20.0,right: 20.0),
                            //alignment: Alignment.topLeft,
                            //height:_height/16,
                            child: Text('See All',style: TextStyle(color: Colors.white70,fontSize:12.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),


                      Container(
                        margin: EdgeInsets.only(top:10.0,left:10.0),
                        width: _width,
                        height: _height/4,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.only( left:5.0,right: 5.0),
                              width: _width/1.4,
                              child: InkWell(
                                child: Card(
                                  elevation:1.0,
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.only(left:10.0,right:10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.folder,color: Colors.white,size: 40.0,),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Text('My Drive',style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child:Container(
                                                width:_width/3.4,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Image.asset('assets/images/image2.jpg',fit:BoxFit.fill,width:_width/3.4,),
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.only(left:5.0),
                                                      color: Colors.blue[800],
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                                          SizedBox(width: 5.0,),
                                                          Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child:Container(
                                                width:_width/3.4,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Image.asset('assets/images/image1.jpg',fit:BoxFit.fill,width:_width/3.4),
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.only(left:5.0),
                                                      color: Colors.blue[800],
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                                          SizedBox(width: 5.0,),
                                                          Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){

                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only( left:5.0,right: 5.0),
                              width: _width/1.4,
                              child: InkWell(
                                child: Card(
                                  elevation:1.0,
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.only(left:10.0,right:10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.folder,color: Colors.white,size: 40.0,),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Text('My Drive',style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child:Container(
                                                width:_width/3.4,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Image.asset('assets/images/image3.jpg',fit:BoxFit.fill,width:_width/3.4,),
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.only(left:5.0),
                                                      color: Colors.blue[800],
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                                          SizedBox(width: 5.0,),
                                                          Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child:Container(
                                                width:_width/3.4,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Image.asset('assets/images/image4.jpg',fit:BoxFit.fill,width:_width/3.4),
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.only(left:5.0),
                                                      color: Colors.blue[800],
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                                          SizedBox(width: 5.0,),
                                                          Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){

                                },
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        padding: EdgeInsets.only(top: 25.0,left: 20.0,right: 20.0),
                        alignment: Alignment.topLeft,
                        child:Text('Files',style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),),
                      ),

                      Container(
                        margin: EdgeInsets.only(top:10.0),
                        // width: _width,
                        height: _height/8,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:20.0),
                              width:_width/2.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child:Container(
                                  color:Colors.red,
                                  height:_height/8.0,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:4,
                                        child: Container(
                                          child: Image.asset('assets/images/feed3.jpeg',fit:BoxFit.fill,width:_width/2.9,),
                                        ),
                                      ),

                                      Expanded(
                                        flex:1,
                                        child: Container(
                                          padding: EdgeInsets.only(left:0.0,right:0.0),
                                          color: Colors.blue,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                              // SizedBox(width:5.0,),
                                              Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left:20.0),
                              width:_width/2.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child:Container(
                                  color:Colors.red,
                                  height:_height/8.0,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:4,
                                        child: Container(
                                          child: Image.asset('assets/images/feed3.jpeg',fit:BoxFit.fill,width:_width/2.9,),
                                        ),
                                      ),

                                      Expanded(
                                        flex:1,
                                        child: Container(
                                          padding: EdgeInsets.only(left:0.0,right:0.0),
                                          color: Colors.blue,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                              // SizedBox(width:5.0,),
                                              Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left:20.0),
                              width:_width/2.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child:Container(
                                  color:Colors.red,
                                  height:_height/8.0,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex:4,
                                        child: Container(
                                          child: Image.asset('assets/images/feed3.jpeg',fit:BoxFit.fill,width:_width/2.9,),
                                        ),
                                      ),

                                      Expanded(
                                        flex:1,
                                        child: Container(
                                          padding: EdgeInsets.only(left:0.0,right:0.0),
                                          color: Colors.blue,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(Icons.folder,color: Colors.white,size: 10.0,),
                                              // SizedBox(width:5.0,),
                                              Text('Dowload Image',style: TextStyle(color: Colors.white,fontSize: 10.0),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      // SizedBox(height: 10.0,),

                      SingleChildScrollView(
                        physics:NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom:0.0,top:10.0),
                        child:Container(
                          height: _height/4.5,
                          // color: Colors.orange,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              Container(
                                // height:80.0,
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: Card(
                                      elevation: 1,
                                      color: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: ListTile(
                                        leading:Container(
                                          height:70,
                                          width: 50,
                                          child:Image.asset('assets/images/pdf.png'),
                                        ),
                                        title: Row(
                                          children: <Widget>[
                                            Text('Surat Kuasa',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                            Text('.PDF',style: TextStyle(color: Colors.white70),),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Surat resmi berisi pemberian wewenang kepada pihak lain saat pihak pertama berhalangan.',
                                          style: TextStyle(color: Colors.white70,fontSize:10.0),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        trailing: InkWell(
                                          child: Container(
                                            height:_height/10.0,
                                            width: _width/12.0,
                                            // color: Colors.white,
                                            child: Icon(Icons.more_vert_rounded),
                                          ),
                                          onTap: (){

                                          },
                                        ),
                                      ),
                                    ),)
                              ),
                              Container(
                                // height:80.0,
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: Card(
                                      elevation: 1,
                                      color: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: ListTile(
                                        leading:Container(
                                          height:70,
                                          width: 50,
                                          child:Image.asset('assets/images/pdf.png'),
                                        ),
                                        title: Row(
                                          children: <Widget>[
                                            Text('Surat Edaran',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                            Text('.PDF',style: TextStyle(color: Colors.white70),),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Surat resmi yang dibuat dan ditujukan kepada kalangan tertentu yang isinya berupa pemberitahuan kegiatan atau hal tertentu',
                                          style: TextStyle(color: Colors.white70,fontSize:10.0),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        trailing: InkWell(
                                          child: Container(
                                            height:_height/10.0,
                                            width: _width/12.0,
                                            // color: Colors.white,
                                            child: Icon(Icons.more_vert_rounded),
                                          ),
                                          onTap: (){

                                          },
                                        ),
                                      ),
                                    ),)
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
