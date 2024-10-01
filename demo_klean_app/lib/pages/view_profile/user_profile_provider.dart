import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/pages/view_profile/widgets/user_profile_form.dart';
import 'package:KleanApp/utils/request.dart';
import 'package:KleanApp/utils/token_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfileProvider with ChangeNotifier {
  int? userId;
  String? username;
  DateTime? dateOfBirth;
  String? contactMobile;
  String? contactEmail;
  String? contactTel;
  String? addressState;
  String? addressSuburb;
  String? addressDetail;
  String? postCode;
  bool editMode = false;

  late TextEditingController dateOfBirthController = TextEditingController();
  late TextEditingController mobileController = TextEditingController();
  late TextEditingController telController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController addressDetailController = TextEditingController();

  String? dobError;
  String? addressStateError;
  String? addressSuburbError;
  String? addressDetailError;

  void initEditorController() {
    dateOfBirthController =
        TextEditingController(text: _formatDate(dateOfBirth ?? DateTime.now()));
    mobileController = TextEditingController(text: contactMobile ?? "");
    telController = TextEditingController(text: contactTel ?? "");
    emailController = TextEditingController(text: contactEmail ?? "");
    addressDetailController = TextEditingController(text: addressDetail ?? "");
  }

  final List<Map<String, dynamic>> _states = VNAddress.getStates();
  List<Map<String, dynamic>>? _suburbs;

  final request = Request();

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void changeMode() {
    editMode = !editMode;
    notifyListeners();
  }

  void enableEditMode() {
    editMode = true;
    notifyListeners();
  }

  void SaveAll() {
    editMode = false;
    updateProfile1();
    notifyListeners();
  }

  List<DropdownMenuItem<Object>>? initStates() {
    return _states
        .map((state) =>
            DropdownMenuItem(value: state['id'], child: Text(state['state'])))
        .toList();
  }

  List<DropdownMenuItem<Object>>? initSuburbs() {
    return _suburbs
        ?.map((suburb) =>
            DropdownMenuItem(value: suburb['id'], child: Text(suburb['name'])))
        .toList();
  }

  Future<dynamic> fetchData() async {
    String? token = await TokenService.getToken();
    Map<String, dynamic>? tokenData = await TokenService.getTokenData();
    var uId = int.parse(tokenData?['nameidentifier']);

    dynamic response = await request.get("api/Profile/GetProfile/$uId", token)
        as Map<String, dynamic>;
    userId = uId;
    username = response['username'];
    dateOfBirth = DateTime.parse(response['dateOfBirth']);
    contactMobile = response['contactMobile'] ?? "";
    contactTel = response['contactTel'] ?? "";
    contactEmail = response['contactEmail'] ?? "";
    addressState = response['addressState'];
    addressSuburb = response['addressSuburb'];
    addressDetail = response['addressDetail']?.toString() ?? "";
    postCode = response['postCode']?.toString() ?? "";
    if (addressState != null) {
      _suburbs = VNAddress.getSuburbs(int.parse(addressState ?? ""));
    }

    notifyListeners();
  }

  handleStateChange(val) {
    addressState = val.toString();
    _suburbs = VNAddress.getSuburbs(int.parse(addressState.toString()));
    addressSuburb = null;
    notifyListeners();
  }

  handleSuburbChange(val) {
    addressSuburb = val.toString();
    postCode = VNAddress.getPostCode(int.parse(addressState.toString()),
        int.parse(addressSuburb.toString()));
    notifyListeners();
  }

  void updateProfile1() {
    dobError = null;
    addressStateError = null;
    addressSuburbError = null;
    addressDetailError = null;

    if (addressState == null || addressState!.isEmpty) {
      addressStateError = "State is required";
      return;
    }
    if (addressSuburb == null || addressSuburb!.isEmpty) {
      addressSuburbError = "Suburb is required";
      return;
    }

    if (addressDetailController.text.isEmpty) {
      addressDetailError = "Address detail is required";
      return;
    }
    contactMobile = mobileController.text;
    contactTel = telController.text;

    addressDetail = addressDetailController.text;
    print(
        '$dateOfBirth $contactMobile $contactTel $addressState $addressSuburb $addressDetail');
  }

  Future<void> pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dateOfBirth) {
      dateOfBirth = picked;
      dateOfBirthController.text =
          DateFormat('yyyy/MM/dd').format(picked);
    }
  }

  bool _isInputValid(String val, {int minLength = 8}) {
    return val.isNotEmpty && val.length >= minLength;
  }

  void updateProfile({
    required String mobile,
    required String email,
    required String addressState,
    required String addressSuburb,
    required String addressDetail,
  }) {
    contactMobile = mobile;
    contactTel = email;
    addressState = addressState;
    addressSuburb = addressSuburb;
    addressDetail = addressDetail;

    print(
        '$contactMobile $contactTel $addressState $addressSuburb $addressDetail');

    changeMode();

    notifyListeners(); // Thông báo cho tất cả các widget đang lắng nghe
  }
}
