class SuburbType {
  int id;
  String name;
  String postCode;
  SuburbType(this.id, this.name, this.postCode);
}

class StateType {
  int id;
  String state;
  List<SuburbType> suburbs;

  StateType(this.id, this.state, this.suburbs);
}

class VNAddress {
  static final List<SuburbType> _canThoSuburbs = [
    SuburbType(1, 'Ninh Kieu', '651'),
    SuburbType(2, 'Cai Rang', '652'),
    SuburbType(3, 'Binh Thuy', '653'),
  ];

  static final List<SuburbType> _bacLieuSuburbs = [
    SuburbType(4, 'Hoa Binh', '941'),
    SuburbType(5, 'Hong Dan', '942'),
    SuburbType(6, 'Phuoc Long', '943'),
  ];

  static final List<SuburbType> _socTrangSuburbs = [
    SuburbType(7, 'Chau Thanh', '831'),
    SuburbType(8, 'My Tu', '832'),
    SuburbType(9, 'My Xuyen', '833'),
  ];

  static List<StateType> address = [
    StateType(1, 'Can Tho', _canThoSuburbs),
    StateType(2, 'Bac Lieu', _bacLieuSuburbs),
    StateType(3, 'Soc Trang', _socTrangSuburbs),
  ];

  static List<Map<String, dynamic>> getStates() {
    return address
        .map((state) => {'id': state.id, 'state': state.state})
        .toList();
  }

  static List<Map<String, dynamic>> getSuburbs(int? stateId) {
    StateType st = address.firstWhere((s) => s.id == stateId);
    return st.suburbs
        .map(
            (sub) => {'id': sub.id, 'name': sub.name, 'postCode': sub.postCode})
        .toList();
  }

  static String? getState(int stateId) {
    return address.firstWhere((s) => s.id == stateId).state;
  }

  static String? getSuburb(int stateId, int suburbId) {
    StateType st = address.firstWhere((s) => s.id == stateId);
    return st.suburbs.firstWhere((sub) => sub.id == suburbId).name;
  }

  static String? getPostCode(int stateId, int suburbId) {
    try {
      StateType st = address.firstWhere((s) => s.id == stateId);
      SuburbType sub = st.suburbs.firstWhere((sb) => sb.id == suburbId);
      return sub.postCode;
    } catch (e) {
      return null;
    }
  }
}
