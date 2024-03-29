import 'package:expensio/bar%20graph/individual_bar.dart';

class BarData {
  final double lunAmount;
  final double marAmount;
  final double merAmount;
  final double jeuAmount;
  final double venAmount;
  final double samAmount;
  final double dimAmount;

  BarData({
    required this.lunAmount,
    required this.marAmount,
    required this.merAmount,
    required this.jeuAmount,
    required this.venAmount,
    required this.samAmount,
    required this.dimAmount,
  });

  List<IndividualBar> barData = [];

  // initialiser la data bar

  void initializeBarData() {
    barData = [
      // lun
      IndividualBar(x: 0, y: lunAmount),

      // mar
      IndividualBar(x: 1, y: marAmount),

      // mer
      IndividualBar(x: 2, y: merAmount),

      // jeu
      IndividualBar(x: 3, y: jeuAmount),

      // ven
      IndividualBar(x: 4, y: venAmount),

      // sam
      IndividualBar(x: 5, y: samAmount),

      // dim
      IndividualBar(x: 6, y: dimAmount),
    ];
  }
}
