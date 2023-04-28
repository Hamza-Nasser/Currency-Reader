import 'package:camera/camera.dart';
import 'package:currency_detector/screens/preview.dart';
import 'package:flutter/cupertino.dart'
    show showCupertinoDialog, CupertinoAlertDialog;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../detect.dart';
import '../resources.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final List<CameraDescription>? cameras;
  late CameraController _cameraController;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      loading = false;
      cameras = value;
      initCamera(cameras![0]);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      late XFile picture;
      await _cameraController.takePicture().then((value) {
        picture = value;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(
              picture: picture,
            ),
          ),
        );
      });
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Reader',
          style: TextStyle(color: ColorManager.white),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Language selection"),
                  content: const Text("Choose the language"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Provider.of<ImageDetection>(context, listen: false)
                              .isArabic = true;
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Changed to Arabic"),
                            ),
                          );
                        },
                        child: const Text("Arabic")),
                    TextButton(
                      onPressed: () {
                        Provider.of<ImageDetection>(context, listen: false)
                            .isArabic = false;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Changed to English"),
                          ),
                        );
                      },
                      child: const Text("English"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.menu,
              color: ColorManager.white,
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.info_outline,
            color: ColorManager.white,
          ),
        ),
      ),
      body: () {
        if (!loading && _cameraController.value.isInitialized) {
          return GestureDetector(
            onTap: takePicture,
            child: CameraPreview(_cameraController),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }(),
    );
  }
}
