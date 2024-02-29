import 'package:equatable/equatable.dart';

import '../assets/constants.dart';
import '../assets/light_dark_theme.dart';

class Inspiration extends Equatable {
  final String title;
  final DevelopmentCategoryDark category;
  final Difficulty difficulty;

  const Inspiration(this.title, this.category, this.difficulty);

  @override
  List<Object?> get props => [title, category, difficulty];

  static Inspiration fromJson(json) => Inspiration(
        json['title'] as String,
        DevelopmentCategoryDark.values
            .firstWhere((element) => element.name == json['category']),
        Difficulty.values[json['size'] as int],
      );
}
