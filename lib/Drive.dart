import 'package:flutter/material.dart';
import 'package:militarymessenger/Directory.dart';
// import 'package:militarymessenger/GDrive.dart';

class DrivePage extends StatefulWidget {
  const DrivePage({Key? key}) : super(key: key);

  @override
  State<DrivePage> createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  double _height = 0;
  double _width = 0;

  @override
  Widget build(BuildContext context) {
    _height=MediaQuery.of(context).size.height;
    _width=MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: _height/4,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.only( left:15.0,right: 5.0, top: 10),
                width: _width * 2/3,
                height: _height/4,
                child: InkWell(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation:2.0,
                    color: Colors.white,
                    child:Padding(
                      padding: const EdgeInsets.only(left:10.0,right: 10.0,top:10.0,bottom:10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Icon(Icons.folder, size: 50,color: Colors.grey,),
                          ),

                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.folder,color: Colors.cyan,size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.image,color: Colors.grey[300],size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.add_comment,color: Colors.grey[300],size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.folder,color: Colors.grey[300],size:30.0),
                            ],
                          ),

                          const Text("Rizki Tujuhbelas Kelola",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),

                          Column(

                            children: <Widget>[

                              Container(
                                margin:const EdgeInsets.only(right:5.0),
                                alignment: Alignment.topRight,
                                child: const Text('6/15 GB',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600),),
                              ),

                              //SizedBox(height:5.0,),

                              Row(
                                children: <Widget>[
                                  Container(
                                    height: _height/120.0,
                                    width: _width/4.5,
                                    color: Colors.indigo,
                                  ),
                                  Container(
                                    height: _height/120.0,
                                    width: _width/3.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DirectoryPage()),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only( left:15.0,right: 5.0, top: 10),
                width: _width * 2/3,
                height: _height/4,
                child: InkWell(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation:2.0,
                    color: Colors.white,
                    child:Padding(
                      padding: const EdgeInsets.only(left:10.0,right: 10.0,top:10.0,bottom:10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child:const Icon(Icons.folder, size: 50,color: Colors.grey,),
                          ),

                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.folder,color: Colors.cyan,size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.image,color: Colors.grey[300],size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.add_comment,color: Colors.grey[300],size:30.0),
                              const SizedBox(width:5.0,),
                              Icon(Icons.folder,color: Colors.grey[300],size:30.0),
                            ],
                          ),
                          const Text("Digiprimatera",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                          Column(
                            children: <Widget>[
                              Container(
                                margin:const EdgeInsets.only(right:5.0),
                                alignment: Alignment.topRight,
                                child: const Text('6/15 GB',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600),),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: _height/120.0,
                                    width: _width/4.5,
                                    color: Colors.indigo,
                                  ),
                                  Container(
                                    height: _height/120.0,
                                    width: _width/3.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SecondPage()),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom:0.0),
          height: _height/2.0,
          color: Colors.indigoAccent[600],
          width: _width,
          child: SingleChildScrollView(
              physics:const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom:0.0,top:0.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 19.0,left:4.0),
                    alignment: Alignment.topLeft,
                    height:_height/16,
                    child: const Text(
                      'Last File',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height/2,
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          InkWell(
                            child:SizedBox(
                              height:80.0,
                              // color: Colors.transparent,
                              child: Opacity(
                                opacity: 0.9,
                                child: Card(
                                  // color: Color(0xFF2196F3),
                                  elevation: 1,
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading:ClipRRect(
                                      borderRadius: BorderRadius.circular(60.0),
                                      child: SizedBox(
                                        height:60,
                                        width: 50,
                                        child:Image.asset("assets/images/pdf.png"),
                                      ),
                                    ),
                                    title: Row(
                                      children: const <Widget>[
                                        Text("Surat Keputusan",style: TextStyle(fontWeight: FontWeight.w600)),
                                        Text('.PDF'),
                                      ],
                                    ),
                                    subtitle: const Text(
                                        "Surat resmi ini bertujuan untuk menyampaikan keputusan",
                                        style: TextStyle(fontSize:10.0),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                    trailing: InkWell(
                                      child: SizedBox(
                                        height:_height/10.0,
                                        width: _width/12.0,
                                        // color: Colors.white,
                                        child: const Icon(Icons.more_vert_rounded),
                                      ),
                                      onTap: (){

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child:SizedBox(
                              height:80.0,
                              // color: Colors.transparent,
                              child: Opacity(
                                opacity: 0.9,
                                child: Card(
                                  // color: Color(0xFF2196F3),
                                  elevation: 1,
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading:ClipRRect(
                                      borderRadius: BorderRadius.circular(60.0),
                                      child: SizedBox(
                                        height:60,
                                        width: 50,
                                        child:Image.asset("assets/images/pdf.png"),
                                      ),
                                    ),
                                    title: Row(
                                      children: const <Widget>[
                                        Text("Surat Permohonan",style: TextStyle(fontWeight: FontWeight.w600)),
                                        Text('.PDF'),
                                      ],
                                    ),
                                    subtitle: const Text(
                                        "Surat permohonan digunakan ketika suatu pihak menyampaikan suatu permohonan.",
                                        style: TextStyle(fontSize:10.0),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                    trailing: InkWell(
                                      child: SizedBox(
                                        height:_height/10.0,
                                        width: _width/12.0,
                                        // color: Colors.white,
                                        child: const Icon(Icons.more_vert_rounded),
                                      ),
                                      onTap: (){

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child:SizedBox(
                              height:80.0,
                              // color: Colors.transparent,
                              child: Opacity(
                                opacity: 0.9,
                                child: Card(
                                  // color: Color(0xFF2196F3),
                                  elevation: 1,
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading:ClipRRect(
                                      borderRadius: BorderRadius.circular(60.0),
                                      child: SizedBox(
                                        height:60,
                                        width: 50,
                                        child:Image.asset("assets/images/pdf.png"),
                                      ),
                                    ),
                                    title: Row(
                                      children: const <Widget>[
                                        Text("Surat Undangan",style: TextStyle(fontWeight: FontWeight.w600)),
                                        Text('.PDF'),
                                      ],
                                    ),
                                    subtitle: const Text(
                                        "Surat resmi ini digunakan untuk memanggil atau mengundang seseorang untuk keperluan tertentu.",
                                        style: TextStyle(fontSize:10.0),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                    trailing: InkWell(
                                      child: SizedBox(
                                        height:_height/10.0,
                                        width: _width/12.0,
                                        // color: Colors.white,
                                        child: const Icon(Icons.more_vert_rounded),
                                      ),
                                      onTap: (){

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                    ),
                  ),

                ],
              )
          ),
        ),
      ],
    );
  }
}
