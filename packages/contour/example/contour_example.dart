import 'package:contour/contour.dart';

void main() {
  final hello = string().min(10);
  print(hello.parse('Hello World!'));
}
