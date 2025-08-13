
import 'package:image_picker/image_picker.dart';

class FileManager {
  static final FileManager _instance = FileManager._internal();
  factory FileManager() => _instance;
  FileManager._internal();

  List<XFile> selectedFiles = []; // Now stores multiple images

  void addFile(XFile file) {
    selectedFiles.add(file);
  }

  void removeFile(XFile file) {
    selectedFiles.remove(file);
  }

  void clearFiles() {
    selectedFiles.clear();
  }
}
