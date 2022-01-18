import 'history.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Penunjukan Menteri Dalam Negeri.pdf',
        style: TextStyle(
          fontSize: 16
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2481CF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 15, right: 15, left: 15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              height: 470,
              color: Color(0xFFD1D1D6),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SfPdfViewer.asset('assets/files/file.pdf',
                  pageLayoutMode: PdfPageLayoutMode.single,
                  scrollDirection: PdfScrollDirection.horizontal,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 30),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF2481CF),
                    fixedSize: Size(500, 50),
                    elevation: 0
                ),
                icon: Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,),
                label: Text("Approve",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DocumentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: Size(500, 50),
                    elevation: 0
                ),
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF94A3B8),),
                label: Text("Reject",
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 16
                  ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
