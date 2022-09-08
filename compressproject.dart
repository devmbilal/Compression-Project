import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:lzstring/lzstring.dart';
import 'dart:convert';
import 'dart:math';

void main() async {
  int x = 0;

  print('Make sure filepath must be correct');
  String filepath = 'assets/sample2.json';
  //Reading Data from Json File
  var response = await readJsonFile(filepath);
  print('Original Data:$response');
  var data = json.encode(response);
  print('EncodedData: $data');
  //Generating Random Number to add it at the end of String as Error Bit
  Random random = Random();
  x = random.nextInt(10);
  print('Now $x % of String Length is added as Error bit to the end of String');
  var errorbit = (x % data.length);
  data = data + errorbit.toString();
  // Compression using Lempel Ziv Algorithm
  var compressed = await LZString.compressToBase64(data);
  print('Compressed Base 64 String: $compressed');
  String? decompressedString = LZString.decompressFromBase64Sync(compressed);
  print('DecompressedString: $decompressedString');
  // Decoding Data
  final decoded = decodedata(decompressedString!, errorbit.toString());
  print('DecodedData: $decoded');
}

Future readJsonFile(String filePath) async {
  try {
    var response = await File(filePath).readAsString();
    return response;
  } catch (e) {
    print('Unable to load Json File !! Invalid Filepath');
  }
}

String decodedata(String data, String errorbit) {
  if (data[data.length - 1] == errorbit) {
    print('The Data is Decoded without any error');
    data = data.replaceAll(errorbit, " ");
    return json.decode(data);
  } else {
    print('There is an error in Decoding the Data');
    return '';
  }
}
