import 'dart:convert';
import 'dart:io';

import 'package:robot_project_generator/constants.dart';
import 'package:robot_project_generator/files/default_messages.dart';
import 'package:robot_project_generator/messages.dart';
import 'package:robot_project_generator/models/template.dart';
import 'package:robot_project_generator/utilities/file_utils.dart';
import 'package:robot_project_generator/utilities/global_utils.dart';

void main(List<String> args) async {
  createTemplateDirectory();

  if (!message_file.existsSync()) {
    message_file.createSync();
    message_file.writeAsStringSync(json.encode(message_file_default));
  }

  if (args.isEmpty) {
    printMessage(helpMessage);
    return;
  }

  if (args[0] == 'templates') {
    if (!hasTemplates()) {
      printMessage(noTemplateMessage);
      return;
    }
    print('');
    printMessage(templatesMessage
        .toString()
        .replaceAll('%templates%', '${templates.length}'));
    print('');
    templates.forEach((t) {
      printMessage(
          templateLineMessage.toString().replaceAll('%template_name%', t));
    });
    print('');
    return;
  }

  if (args[0] == 'open') {
    await Process.run(openExplorerCommandMessage, [gem_dir.path]);
    return;
  }

  if (!hasTemplates()) {
    printMessage(noTemplateMessage);
    return;
  }

  if (args.length < 2) {
    printMessage(templateUseMessage);
    return;
  }

  // if (args[0] == 'new') {
  //   if (args.length == 1) {
  //     printMessage(newTemplateMessage);
  //     return;
  //   }
  //   return;
  // }

  var template_name = args[0];
  var project_name = args[1];

  if (!hasTemplate(template_name)) {
    printMessage(projectNotFoundMessage);
    return;
  }

  if (Directory.fromUri(
          Uri.file('${Directory.current.path}$file_separator$project_name'))
      .existsSync()) {
    printMessage(destinationExistsMessage);
    return;
  }

  var template = Template(name: template_name, project_name: project_name);

  stdout.write(openProjectInEditorMessage);
  var response = stdin.readLineSync();
  response = response!.isEmpty ? 'Y' : response.toUpperCase();
  
  template.open_editor = response == 'Y';
  await template.install();
}
