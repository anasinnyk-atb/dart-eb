part of aws.sdk.dynamodb;

class DynamoDbClient extends Client {
  String service = 'DynamoDB';

  DynamoDbClient(credentials): super(credentials);

  getItem(dynamic data) {
    return this.call('GetItem', data);
  }
}
