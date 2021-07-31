import 'dart:io';

import 'package:robot_project_generator/constants.dart';



bool hasTemplates() {
  var hasFolder = templates_dir.existsSync();
  if (hasFolder) {
    return templates.isNotEmpty;
  }
  return false;
}

bool hasTemplate(name) {
  return templates.where((element) => element == name).isNotEmpty;
}

List<FileSystemEntity> getTemplate(name) {
  if (!hasTemplate(name)) return [];
  var template_dir = Directory.fromUri(Uri.file('${templates_dir.path}$file_separator$name'));
  return template_dir.listSync(recursive: true);
}

void createTemplateDirectory() {
  if (!hasTemplates()) {
    templates_dir.createSync();
  }
}