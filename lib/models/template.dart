import 'dart:io';

import 'package:robot_project_generator/constants.dart';
import 'package:robot_project_generator/messages.dart';
import 'package:robot_project_generator/utilities/file_utils.dart';

class Template {
  final String name;
  final String project_name;
  late List<FileSystemEntity> files;
  late Directory project_folder;
  bool open_editor = false;

  Template({required this.name, required this.project_name}) {
    files = getTemplate(name);
    project_folder = Directory.fromUri(
        Uri.file('${Directory.current.path}$file_separator$project_name'));
  }

  Future<void> install() async {
    if (files.isNotEmpty) {
      await project_folder.create();
      await Future.sync(() {
        files.forEach((f) async {
          if (f is File) {
            var content = await f.readAsBytes();
            var p_path = f.path.replaceFirst(
                '${templates_dir.path}$file_separator$name',
                project_folder.path);
            var file = File.fromUri(Uri.file(p_path));
            await file.create(recursive: true);
            await file.writeAsBytes(content);
          }
        });
      });
      if (open_editor) {
        await Process.run(openProjectCommandMessage, [project_folder.path], runInShell: true);
      }
    }
  }
}
