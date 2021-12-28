class MutableInt {
  int value = 1;

  MutableInt({this.value});

  Map<String, dynamic> toJson() => {
        'value': value,
      };

  factory MutableInt.fromJson(Map<String, dynamic> json) {
    return MutableInt(
      value: json['value'],
    );
  }

  void increment() {
    ++value;
  }

  void decrement() {
    --value;
  }
}
