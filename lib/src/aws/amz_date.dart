part of aws.sdk;

class AmzDate {
  DateTime now = new DateTime.now().toUtc();
  String _v(int value) => value < 10 ? '0$value' : value.toString();
  String toDateString() => '${this.now.year}${this._v(this.now.month)}${this._v(this.now.day)}';
  String toTimeString() => '${this._v(this.now.hour)}${this._v(this.now.minute)}${this._v(this.now.second)}';
  String toString() => '${this.toDateString()}T${this.toTimeString()}Z';
}
