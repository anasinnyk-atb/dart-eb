import 'package:test/test.dart';
import '../../../src/aws/sdk.dart';
import '../../../src/aws/dynamodb/index.dart';

void main() {
  test('Test API call to DynamoDB by client', () {
    new DynamoDbClient(new Credentials())..getItem({
      'TableName': 'ExistingTable',
      'Key': {
        'Id': {'S': 'existingId'},
      }
    }).then((response) => expect(response.statusCode, equals(200)));
  });
}
