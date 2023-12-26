class DrawerItem {
  int _index;
  String _id;
  String _name;

  DrawerItem(this._index, this._id, this._name);

  String get name => _name;
  String get id => _id;
  int get index => _index;
}
