import 'package:test/test.dart';
import '../../../lib/src/aws/sdk.dart';
import '../../../lib/src/aws/dynamodb/index.dart';

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
