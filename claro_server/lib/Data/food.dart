class Food{
  String name;
  String? description;
  int wheigthPerPortion;
  int pricePerPortion;
  Food(this.name,this.wheigthPerPortion,this.pricePerPortion);
  static Food getDefault = Food("Empty", 0, 0);
}