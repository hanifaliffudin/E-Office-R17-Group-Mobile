import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/services/qr_auth_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:militarymessenger/main.dart' as mains;

class QrcodeEofficePage extends StatefulWidget {
  const QrcodeEofficePage({Key? key}) : super(key: key);

  @override
  State<QrcodeEofficePage> createState() => _QrcodeEofficePageState();
}

class _QrcodeEofficePageState extends State<QrcodeEofficePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? _qrController;
  final _qrAuthService = QrAuthService();
  late UserModel user;
  late FToast fToast;
  bool _qrScanLoading = false;

  @override
  void initState() {
    super.initState();
    
    fToast = FToast();
    user = mains.objectbox.boxUser.get(1)!;

    fToast.init(context);
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrController = controller;

    _qrController!.pauseCamera();
    _qrController!.resumeCamera();
    _qrController!.scannedDataStream.listen((Barcode scanData) {
      if (scanData.code != null && !_qrScanLoading) { 
        setState(() {
          _qrScanLoading = true;
        });

        _qrController!.pauseCamera();
        Future.delayed(const Duration(milliseconds: 300), () {
          _readQrCode(scanData.code!);
        });
      }
    });
  }

  void _readQrCode(String code) async {
    _showDialgLoading();
      
    Map<String, dynamic> readQrAuthMap = await _qrAuthService.readQrAuth(code, user.email!);

    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!readQrAuthMap['error']) {
        Map<String, dynamic> boydReadQrAuthMap = readQrAuthMap['body'];

        _showDialogResult(
          true,
          boydReadQrAuthMap['message'],
          () {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        );
      } else {
        _showDialogResult(
          false,
          readQrAuthMap['message'],
          () {
            Navigator.pop(context);
            _qrController!.resumeCamera();
          }
        );
      }

      setState(() {
        _qrScanLoading = false;
      });
    });
  }

  void _showDialgLoading() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(
              top: 30.0,
              bottom: 24.0,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Transform.scale(
                  scale: 0.9,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 14.0),
                  child: Text(
                    'Loading',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialogResult(bool success, String message, Function okOnPressed) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          contentPadding: const EdgeInsets.only(
            top: 25.0,
            right: 25.0,
            left: 25.0,
            bottom: 7.0,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => okOnPressed(),
                  child: Text(
                    success ? 'Oke' : 'Retry',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildQrView(context),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey, 
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderWidth: 10.0,
        borderRadius: 10.0,
        borderLength: 30.0,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}