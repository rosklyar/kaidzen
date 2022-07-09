class Boards {
  static const String DO = "To Do";
  static const String DOING = "In Progress";
  static const String DONE = "Done";
}

enum Category {
  CAREER_AND_FINANCES("Career and finances"),
  HEALTH("Health"),
  PERSONAL_DEVELOPMENT("Personal development"),
  RELATIONSHIPS("Relatioships"),
  LEISURE("Leisure");

  const Category(this.description);
  final String description;
}
