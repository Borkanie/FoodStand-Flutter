/// I meant it's food:)
class Food{
  static Food getDefault = Food("Empty", 0, 0);
  int _wheigthPerPortion;
  int _pricePerPortion;
  String name;
  String? description;
  Food(this.name,this._wheigthPerPortion,this._pricePerPortion);
  
  @override
  int get hashCode => name.hashCode * (wheigthPerPortion + 1) * (pricePerPortion + 1);
  
  int get pricePerPortion => _pricePerPortion;
  set pricePerPortion(int value){
    value > 0 ? _pricePerPortion = value : _pricePerPortion = -value;
  }

  int get wheigthPerPortion => _wheigthPerPortion;
  set wheigthPerPortion(int value){
    value > 0 ? _wheigthPerPortion = value : _wheigthPerPortion = -value;
  }

  @override
  bool operator ==(Object other) {
    return other is Food ? other .hashCode == hashCode : false;
  }
}