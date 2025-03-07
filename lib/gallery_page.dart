import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<File> _galleryImages = []; // เก็บรายชื่อของรูปภาพที่เลือกจากแกลเลอรี

  // ฟังก์ชันในการโหลดรูปภาพจากแกลเลอรี
  Future<void> _loadImagesFromGallery() async {
    final List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        _galleryImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImagesFromGallery(); // โหลดรูปภาพจากแกลเลอรีเมื่อหน้าเปิดขึ้น
  }

  // ฟังก์ชันเพื่อเปิดดูรูปภาพในหน้าจอเต็ม
  void _viewFullScreenImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🖼 แกลเลอรี')),
      body: Column(
        children: [
          Expanded(
            child: _galleryImages.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _galleryImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _viewFullScreenImage(_galleryImages[
                            index]), // เมื่อกดที่รูปจะเปิดหน้าเต็ม
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // กรอบขาวด้านบน
                              Container(
                                color: Colors.white,
                                height: 5, // ขนาดกรอบขาวด้านบน
                              ),
                              // รูปภาพ
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10), // กรอบขาวด้านข้าง
                                  color: Colors.white, // กำหนดกรอบขาว
                                  child: Image.file(
                                    _galleryImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              // กรอบขาวด้านล่าง
                              Container(
                                color: Colors.white,
                                height: 40, // กรอบขาวด้านล่างจะยาวกว่าด้านบน
                                child: const Center(
                                  child: Text(
                                    'Polaroid',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('ไม่มีรูปภาพ')),
          ),
        ],
      ),
    );
  }
}

// หน้าจอสำหรับแสดงรูปภาพเต็มจอ
class FullScreenImagePage extends StatelessWidget {
  final File image;

  const FullScreenImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ดูรูปภาพ', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context), // กดออกจากโหมดเต็มจอ
          child: Image.file(
            image,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
