import 'dart:convert';
import 'dart:io';

var gem_dir = Directory.fromUri(Uri.parse(Platform.script.path)).parent;

String get file_separator => Platform.isWindows ? '\\' : '/';

var templates_dir = Directory.fromUri(Uri.file(gem_dir.path + '${file_separator}templates'));

Iterable<String> get templates => templates_dir.listSync().map((e) => e.path.split(file_separator).last);

var message_file = File.fromUri(Uri.file('${gem_dir.path}${file_separator}messages.json'));

var messages = json.decode(message_file.readAsStringSync());