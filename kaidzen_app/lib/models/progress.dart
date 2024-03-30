import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final int points;
  final int level;
  final int totalPoints;

  Progress(this.level, this.points, this.totalPoints);

  @override
  List<Object?> get props => [level, points, totalPoints];
}
