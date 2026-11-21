import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Renders the widget under [key] (a RepaintBoundary) to PNG at [pixelRatio].
Future<Uint8List> capturePng(GlobalKey key, {double pixelRatio = 3}) async {
  final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

String _fileName(String tripName) {
  final slug = tripName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '');
  return 'the_leak_${slug.isEmpty ? 'trip' : slug}';
}

/// Opens the share sheet (WhatsApp and friends) with the card as a PNG.
Future<void> shareCard(Uint8List png, {required String tripName}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${_fileName(tripName)}.png');
  await file.writeAsBytes(png, flush: true);
  await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'image/png')]));
}

/// Saves the card to the photo gallery, asking for permission if needed.
/// Returns false when permission was refused.
Future<bool> saveCardToGallery(Uint8List png, {required String tripName}) async {
  if (!await Gal.hasPermission()) {
    if (!await Gal.requestPermission()) return false;
  }
  await Gal.putImageBytes(png, name: _fileName(tripName));
  return true;
}
