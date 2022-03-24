class Constant {
  static MaterialRadius buttonRadius =
      MaterialRadius(small: 8, medium: 16, large: 24);
  static MaterialRadius textFieldRadius =
      MaterialRadius(small: 8, medium: 16, large: 24);
  static MaterialRadius containerRadius =
      MaterialRadius(small: 8, medium: 16, large: 24);
}

class MaterialRadius {
  late double small, medium, large;

  MaterialRadius({this.small = 8, this.medium = 16, this.large = 24});
}
