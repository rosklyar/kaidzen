class AchievementSnapshot {
  final String title;
  final int setId;
  final String iconName;
  final String description;
  final bool isSecret;
  final double progress;
  final bool isCompleted;

  AchievementSnapshot({
    required this.title,
    required this.setId,
    required this.iconName,
    required this.description,
    required this.isSecret,
    required this.progress,
    required this.isCompleted,
  });
}
