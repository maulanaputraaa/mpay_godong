import 'dart:math' as math;

class User {
  final String email;
  final String password;
  late double saldo;

  User({required this.email, required this.password}) {
    randomSaldo();
  }

  void setSaldo(double saldo) {
    this.saldo = saldo;
  }

  void randomSaldo() {
    saldo = 100000 + (200000 * (math.Random().nextDouble()));
  }
}
