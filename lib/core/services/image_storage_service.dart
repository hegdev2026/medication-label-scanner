import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:medicine_lab_reader/features/medicines/domain/services/image_storage.dart';

@LazySingleton(as: ImageStorage)
class ImageStorageService implements ImageStorage {
  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'medicine_images'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  @override
  Future<String> persist(String sourcePath) async {
    final dir = await _dir();
    if (p.isWithin(dir.path, sourcePath)) return sourcePath;
    final name =
        '${DateTime.now().microsecondsSinceEpoch}${p.extension(sourcePath)}';
    final target = p.join(dir.path, name);
    await File(sourcePath).copy(target);
    return target;
  }

  @override
  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    final dir = await _dir();
    if (!p.isWithin(dir.path, path)) return; // never delete user files
    final f = File(path);
    if (await f.exists()) await f.delete();
  }
}
