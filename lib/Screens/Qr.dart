import 'package:flutter/material.dart';
import 'package:karel/Services/api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String scannedData = '';
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              if (scannedData.isNotEmpty)
                Text(
                  'Scanned Data: $scannedData',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ElevatedButton(
                onPressed: () => _startScan(forEntry: true),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Giriş',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  primary: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _startScan(forEntry: false),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Çıkış',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  primary: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, bool forEntry) {
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        setState(() {
          isScanning = false;
          scannedData = scanData.code!;
        });
        _delayedNavigation(controller);

        if (forEntry) {
          await Api.addLocation(scannedData);
        } else {
          await Api.updateOutTime(scannedData);
        }
      }
    });
  }

  Future<void> _delayedNavigation(QRViewController controller) async {
    await Future.delayed(Duration(milliseconds: 500));
    controller.dispose();
    Navigator.pop(context);
  }

  void _startScan({required bool forEntry}) {
    setState(() {
      isScanning = true;
      scannedData = '';
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: GlobalKey(debugLabel: 'QR'),
                  onQRViewCreated: (controller) =>
                      _onQRViewCreated(controller, forEntry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(home: QrPage()));
}
