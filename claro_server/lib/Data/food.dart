class Food{
  String name;
  String? description;
  int _wheigthPerPortion;
  int get wheigthPerPortion => _wheigthPerPortion;
  set wheigthPerPortion(int value){
    value > 0 ? _wheigthPerPortion = value : _wheigthPerPortion = -value;
  }
  int _pricePerPortion;
  int get pricePerPortion => _pricePerPortion;
  set pricePerPortion(int value){
    value > 0 ? _pricePerPortion = value : _pricePerPortion = -value;
  }
  Food(this.name,this._wheigthPerPortion,this._pricePerPortion);
  static Food getDefault = Food("Empty", 0, 0);

  @override
  bool operator ==(Object other) {
    return other is Food ? other .hashCode == hashCode : false;
  }

  @override
  int get hashCode => name.hashCode * (wheigthPerPortion + 1) * (pricePerPortion + 1);
}