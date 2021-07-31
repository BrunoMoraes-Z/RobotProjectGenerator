void printMessage(input) {
  if (input is String) {
    print(input);
  } else {
    (input as List).forEach((element) => print(element));
  }
}