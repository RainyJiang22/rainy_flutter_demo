import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAppPage extends StatefulWidget {
  const PhotoAppPage({super.key});

  @override
  State<PhotoAppPage> createState() => _PhotoAppPageState();
}

class _PhotoAppPageState extends State<PhotoAppPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _imageFiles = [];

  Future<void> _pickPhoto(bool isTakePhoto) async {
    try {
      Navigator.pop(context);
      final XFile? image = await _picker.pickImage(
        source: isTakePhoto ? ImageSource.camera : ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _imageFiles.add(image);
        });
      }
    } catch (e) {
      debugPrint('Pick Image error $e');
    }
  }

  Widget _buildImagePreview() {
    if (_imageFiles.first == null) {
      return const Text('还没有选择图片', style: TextStyle(fontSize: 16));
    }

    return Image.file(File(_imageFiles.first!.path), fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ImagePicker实例')),
      body: Center(
        child: Wrap(spacing: 5, runSpacing: 5, children: _getImageItems()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: _pickImage,
            tooltip: '从相册选择',
            child: const Icon(Icons.photo),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 160,
        child: Column(children: [_item('拍照', true), _item('从相册选择', false)]),
      ),
    );
  }

  Widget _item(String title, bool isTakPhoto) {
    return GestureDetector(
      child: ListTile(
        leading: Icon(isTakPhoto ? Icons.camera_alt : Icons.photo_library),
        title: Text(title),
        onTap: () => _pickPhoto(isTakPhoto),
      ),
    );
  }

  List<Widget> _getImageItems() {
    return _imageFiles.map((file) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(6),
            child: Image.file(
              File(file!.path),
              width: 120,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _imageFiles.remove(file);
                });
              },
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(color: Colors.black54),
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
