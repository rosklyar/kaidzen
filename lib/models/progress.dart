import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final int points;
  final int level;

  Progress(this.level, this.points);

  @override
  List<Object?> get props => [level, points];
}
