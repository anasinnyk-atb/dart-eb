part of aws.sdk;

class Credentials {
  String secret = Platform.environment['AWS_SECRET_ACCESS_KEY'];
  String id = Platform.environment['AWS_ACCESS_KEY_ID'];
  String region = Platform.environment['AWS_REGION'];
}
