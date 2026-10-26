import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

void main() {
  runApp(const QRStudioApp());
}

const bg = Color(0xFF0B1020);
const purple = Color(0xFF8B5CF6);
const muted = Color(0xFF9CA3AF);

class QRStudioApp extends StatelessWidget {
  const QRStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Studio',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF151C30),
          hintStyle: const TextStyle(color: muted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF303952)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF303952)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: purple, width: 1.5),
          ),
        ),
      ),
      home: const QRHomePage(),
    );
  }
}

class QRHomePage extends StatefulWidget {
  const QRHomePage({super.key});

  @override
  State<QRHomePage> createState() => _QRHomePageState();
}

class _QRHomePageState extends State<QRHomePage> {
  final controller = TextEditingController();
  final GlobalKey qrKey = GlobalKey();
  String? qrData;
  String error = '';

  void generateQR() {
    final text = controller.text.trim();

    setState(() {
      error = '';
      if (text.isEmpty) {
        qrData = null;
        error = 'Please enter text or a URL first.';
      } else {
        qrData = text;
      }
    });
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<Uint8List?> captureQr() async {
    if (qrData == null) return null;

    try {
      final boundary =
          qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null || boundary.debugNeedsPaint) {
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 3);

      try {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        return byteData?.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    } catch (e) {
      debugPrint('QR capture error: $e');
      return null;
    }
  }

  Future<void> saveQR() async {
    final bytes = await captureQr();

    if (bytes == null) {
      showMessage('Generate QR code first');
      return;
    }

    try {
      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: 'QR_Studio_${DateTime.now().microsecondsSinceEpoch}',
      );
      if (!mounted) return;
      final success =
          result is Map &&
          (result['isSuccess'] == true || result['isSuccess'] == 1);
      showMessage(success ? 'QR saved to gallery!' : 'could not save QR iamge');
    } catch (e) {
      debugPrint('Save QR error : $e');
      if (!mounted) return;
      showMessage('Failed to save QR  image');
    }
  }

  Future<void> copyContent() async {
    if (qrData == null) return;

    await Clipboard.setData(ClipboardData(text: qrData!));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Content copied successfully!')),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF17152F), bg, Color(0xFF0D1729)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [purple, Color(0xFF4F46E5)],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR Studio',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'CREATE • SCAN • SHARE',
                              style: TextStyle(
                                color: muted,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.auto_awesome, color: Color(0xFFC4B5FD)),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Make it scan.',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Turn your links and ideas into QR codes.',
                    style: TextStyle(color: muted, fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141B2D).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFF303952)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR CONTENT',
                          style: TextStyle(
                            color: Color(0xFFC4B5FD),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter text or paste a URL...',
                            prefixIcon: Icon(Icons.link_rounded),
                          ),
                          onSubmitted: (_) => generateQR(),
                        ),
                        if (error.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            error,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [purple, Color(0xFF635BEB)],
                              ),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: generateQR,
                              icon: const Icon(Icons.qr_code_rounded),
                              label: const Text(
                                'Generate QR Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withValues(alpha: 0.12),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              color: Color(0xFF29213F),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'QR Preview',
                                style: TextStyle(
                                  color: Color(0xFF17152A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            if (qrData != null)
                              const Text(
                                'READY',
                                style: TextStyle(
                                  color: Color(0xFF16865C),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        RepaintBoundary(
                          key: qrKey,
                          child: Container(
                            width: 220,
                            height: 220,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: qrData == null
                                ? const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 74,
                                        color: Color(0xFFC4B5FD),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Your QR appears here',
                                        style: TextStyle(
                                          color: Color(0xFF7C7890),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: QrImageView(
                                      data: qrData!,
                                      version: QrVersions.auto,
                                      size: 190,
                                      backgroundColor: Colors.white,
                                      errorCorrectionLevel:
                                          QrErrorCorrectLevel.H,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          qrData == null
                              ? 'Enter your content to get started'
                              : 'Your QR code is ready to scan',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF777387),
                            fontSize: 12,
                          ),
                        ),
                        if (qrData != null) ...[
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: copyContent,
                              icon: const Icon(Icons.copy_rounded),
                              label: const Text('Copy Content'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF5B3CC4),
                                side: const BorderSide(
                                  color: Color(0xFFD9D0FA),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: saveQR,
                              icon: const Icon(Icons.download_rounded),
                              label: const Text("Save QR Image"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B3CC4),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'CRAFTED WITH CARE  •  QR STUDIO',
                      style: TextStyle(
                        color: Color(0xFF68718B),
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
