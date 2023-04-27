import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../detect.dart';
import '../resources.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.picture});
  final XFile picture;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late bool arabic;
  late String? detectedString;

  @override
  void initState() {
    super.initState();
    Provider.of<ImageDetection>(context, listen: false).picture =
        widget.picture;

    arabic = Provider.of<ImageDetection>(context, listen: false).isArabic;
    Provider.of<ImageDetection>(context, listen: false)
        .detectCurrency(widget.picture, arabic)
        .then((value) {
      detectedString = value;

      if (detectedString == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to detect"),
          ),
        );
      } else {
        sayCurrency(detectedString!);
      }
    });
  }

  void sayCurrency(String currency) {
    // say currency algo.
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview",
          style: TextStyle(
            color: ColorManager.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorManager.white,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(
              File(widget.picture.path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: size.height / 1.28,
            ),
            const SizedBox(height: 24),
            Text(widget.picture.name)
          ],
        ),
      ),
    );
  }
}
