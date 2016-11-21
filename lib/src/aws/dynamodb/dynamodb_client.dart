part of aws.sdk.dynamodb;

class DynamoDbClient extends Client {
  String service = 'DynamoDB';

  DynamoDbClient(credentials): super(credentials);

  batchGetItem(dynamic data) => this.call('BatchGetItem', data);
  batchWriteItem(dynamic data) => this.call('BatchWriteItem', data);
  createTable(dynamic data) => this.call('CreateTable', data);
  deleteItem(dynamic data) => this.call('DeleteItem', data);
  deleteTable(dynamic data) => this.call('DeleteTable', data);
  describeLimits(dynamic data) => this.call('DescribeLimits', data);
  describeTable(dynamic data) => this.call('DescribeTable', data);
  getItem(dynamic data) => this.call('GetItem', data);
  listTables(dynamic data) => this.call('ListTables', data);
  putItem(dynamic data) => this.call('PutItem', data);
  query(dynamic data) => this.call('Query', data);
  scan(dynamic data) => this.call('Scan', data);
  updateItem(dynamic data) => this.call('UpdateItem', data);
  updateTable(dynamic data) => this.call('UpdateTable', data);
}
