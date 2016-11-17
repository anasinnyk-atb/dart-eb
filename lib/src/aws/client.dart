part of aws.sdk;

abstract class Client {
  final String version = '20120810';
  final String contentType = 'application/x-amz-json-1.0';
  final String algorithm = 'AWS4-HMAC-SHA256';
  final String date = new AmzDate().toDateString();
  final String amzDate = new AmzDate().toString();
  final String signType = 'aws4_request';

  String service;
  Credentials credentials;
  Uri url;

  Client(Credentials credentials) {
    this.credentials = credentials;
    this.url = Uri.parse('https://${this.service}.${this.credentials.region}.amazonaws.com/');
  }

  call(String method, dynamic payload) => http.post(
      this.url.toString(),
      body: JSON.encode(payload),
      headers: this._prepareHeaders(method, payload)
  );

  Map<String, String> _signedHeaders(String method) => {
    'content-type': '${this.contentType}; charset=utf-8',
    'host': this.url.host,
    'x-amz-date': this.amzDate.toString(),
    'x-amz-target': this._amzTarget(method),
  };

  dynamic _prepareHeaders(String method, dynamic payload) => {
    'Authorization': this.algorithm + ' ' + this._auth(method, payload),
    'Content-Type': this.contentType,
    'X-Amz-Date': this.amzDate,
    'X-Amz-Target': this._amzTarget(method),
  };

  String _amzTarget(String method) => '${this.service}_${this.version}.$method';

  Map<String, String> _authParams(String method, dynamic payload) => {
    'Credential': [
      this.credentials.id,
      this.date,
      this.credentials.region,
      this.service.toLowerCase(),
      this.signType
    ].join('/'),
    'SignedHeaders': this._signedHeaders(method).keys.join(';'),
    'Signature': _hmac(
        _hmac(
            _hmac(
                _hmac(
                    _hmac(UTF8.encode('AWS4${this.credentials.secret}'), this.date).bytes,
                    this.credentials.region
                ).bytes,
                this.service.toLowerCase()
            ).bytes,
            this.signType
        ).bytes,
        [
          this.algorithm,
          this.amzDate,
          [this.date, this.credentials.region, this.service.toLowerCase(), this.signType].join('/'),
          _sha256(
              [
                'POST',
                this.url.path,
                this.url.query,
                this._canonicalHeaders(method),
                this._signedHeaders(method).keys.join(';'),
                _sha256(JSON.encode(payload))
              ].join('\n')
          )
        ].join('\n')
    ),
  };
  String _canonicalHeaders(String method) => this.map2Str(this._signedHeaders(method)) + '\n';
  String _auth(String m, dynamic p) => this.map2Str(this._authParams(m, p), concat:'=', join:', ');
  Digest _hmac(List<int> key, String value) => (new Hmac(sha256, key)).convert(UTF8.encode(value));
  String _sha256(String value) => sha256.convert(UTF8.encode(value)).toString();
  String map2Str(Map<String, String> map, {String concat: ':', String join: '\n'}) {
    List<String> result = [];
    map.forEach((String k, String v) => result.add('$k$concat$v'));
    return result.join(join);
  }
}
