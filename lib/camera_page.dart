import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // กล้องหน้า (Front camera)
  bool isFrontCamera = true;

  Future<void> _requestPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  // เปลี่ยนกล้อง (หน้า / หลัง)
  void _toggleCamera() {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  Future<void> _takePhoto() async {
    await _requestPermission(); // ขอ permission

    // เลือกกล้อง
    final camera = isFrontCamera ? ImageSource.camera : ImageSource.camera;

    final XFile? image = await _picker.pickImage(
      source: camera,
      preferredCameraDevice:
          isFrontCamera ? CameraDevice.front : CameraDevice.rear,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      // บันทึกภาพลงแกลเลอรีโดยใช้ gal
      await Gal.putImage(image.path).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ บันทึกลงแกลเลอรีแล้ว!")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ไม่สามารถบันทึกได้: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📷 ถ่ายรูป')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!)
                : const Text('ยังไม่ได้ถ่ายรูป'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: Text(isFrontCamera
                  ? '📸 ถ่ายรูปด้วยกล้องหน้า'
                  : '📸 ถ่ายรูปด้วยกล้องหลัง'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleCamera,
              child: const Text('🔄 สลับกล้อง'),
            ),
          ],
        ),
      ),
    );
  }
}
