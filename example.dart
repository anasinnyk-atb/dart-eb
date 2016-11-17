import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  String method = 'POST';
  String secret = Platform.environment['AWS_SECRET_ACCESS_KEY'];
  String access = Platform.environment['AWS_ACCESS_KEY_ID'];
  String region = Platform.environment['AWS_REGION'] ?? 'us-west-2';
  String service = 'dynamodb';
  String type = 'aws4_request';
  String contentType = 'application/x-amz-json-1.0';
  String amzTarget = 'DynamoDB_20120810.GetItem';
  String signedHeaders = 'content-type;host;x-amz-date;x-amz-target';
  String url = 'https://${service}.${region}.amazonaws.com/';
  Uri uri = Uri.parse(url);
  dynamic payload = {
      'Key': {
        'uuid': {'S': 'fa3645ed-2b2e-4c56-bdcf-5b19cafaa777'}
      },
      'TableName': 'dev-atypical-checkout'
  };

  String payloadHash = sha256.convert(UTF8.encode(JSON.encode(payload))).toString();
  String algorithm = 'AWS4-HMAC-SHA256';
  DateTime now = new DateTime.now().toUtc();
  String date = '${now.year}'
      '${now.month < 10 ? '0${now.month}' : now.month}'
      '${now.day < 10 ? '0${now.day}' : now.day}';
  String amzDate = '${date}T'
      '${now.hour < 10 ? '0${now.hour}' : now.hour}'
      '${now.minute < 10 ? '0${now.minute}' : now.minute}'
      '${now.second < 10 ? '0${now.second}' : now.second}'
      'Z';
  String canonicalHeaders = 'content-type:${contentType}; charset=utf-8\nhost:${uri.host}\nx-amz-date:${amzDate}\nx-amz-target:${amzTarget}\n';
  List<String> credentialScope = [date, region, service, type];

  Digest signKey = (new Hmac(
    sha256,
    (new Hmac(
      sha256,
      (new Hmac(
        sha256,
        (new Hmac(sha256, UTF8.encode('AWS4$secret')))
          .convert(UTF8.encode(date)).bytes
      )).convert(UTF8.encode(region)).bytes
    )).convert(UTF8.encode(service)).bytes
  )).convert(UTF8.encode(type));
  print(signKey);

  String canonicalRequest = [method, uri.path, uri.query, canonicalHeaders, signedHeaders, payloadHash].join('\n');
  String str2Sign = [algorithm, amzDate, credentialScope.join('/'), sha256.convert(UTF8.encode(canonicalRequest))].join('\n');
  String signature = (new Hmac(sha256, signKey.bytes)).convert(UTF8.encode(str2Sign)).toString();
  print([canonicalRequest, str2Sign, signature].join('\n'));

  Map<String, String> headers = new Map();
  List<String> auth = [
    'Credential=${[access, credentialScope.join('/')].join('/')}',
    'SignedHeaders=$signedHeaders',
    'Signature=$signature',
  ];
  headers['Authorization'] = '$algorithm ${auth.join(', ')}';
  headers['Content-Type'] = contentType;
  headers['X-Amz-Date'] = amzDate;
  headers['X-Amz-Target'] = amzTarget;

  print(headers);
  //print(secret);
  //print(access);

  http.post(
      url,
      body: JSON.encode(payload),
      headers: headers
  ).then(
      (response) {
          print(response.statusCode);
          print(response.body);
      }
  ).catchError((error) {
      print(error);
  });
}
