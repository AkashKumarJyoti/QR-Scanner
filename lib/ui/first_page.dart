import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/ui/result.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanning = true;
  bool isFlashOn = false;
  bool isCameraFlipped = false;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween<double>(begin: -0.95, end: 0.95).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Scanner',
          style: TextStyle(
            color: Color(0xFFFAFAFA),
          ),
        ),
        backgroundColor: Color(0xFFBA68C8),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          buildQRView(context),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                top: (MediaQuery.of(context).size.height - 100) / 2 + animation.value * 150,
                left: MediaQuery.of(context).size.width / 2 - 128,
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 2,
                  color: Color(0xFFBA68C8),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Color(0xFFBA68C8),
                  ),
                  onPressed: () {
                    toggleFlash();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.flip_camera_ios,
                    color: Color(0xFFBA68C8),
                  ),
                  onPressed: () {
                    toggleCameraFlip();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 16,
        borderColor: Color(0xFFFAFAFA),
        borderLength: 30,
        borderWidth: 8,
        cutOutSize: 300,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      handleScanData(scanData);
    });
  }

  void handleScanData(Barcode scanData) {
    if (scanning) {
      setState(() {
        scanning = false;
        isFlashOn ? toggleFlash() : debugPrint("");
      });

      String scannedCode = scanData.code!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(data: scannedCode),
        ),
      ).then((_) {
        // Executed when returning from ResultPage
        setState(() {
          scanning = true;
        });
      });
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: 'Camera permission denied',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }
  }

  void toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  void toggleCameraFlip() async {
    if (controller != null) {
      await controller!.flipCamera();
      setState(() {
        isCameraFlipped = !isCameraFlipped;
      });
    }
  }
}
