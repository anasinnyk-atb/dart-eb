part of aws.sdk.dynamodb;

class DynamoDbClient extends Client {
  String service = 'DynamoDB';

  DynamoDbClient(credentials): super(credentials);

  getItem(dynamic data) {
    return this.call('GetItem', data);
  }
}

void main() {
  new DynamoDbClient(new Credentials())..getItem({
    'TableName': 'dev-atypical-checkout',
    'Key': {
      'uuid': {'S': 'fa3645ed-2b2e-4c56-bdcf-5b19cafaa777'},
    }
  }).then((response) => print('${response.statusCode}\n${response.body}'));
}
