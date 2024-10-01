import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/utils/request.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();

  int _step = 1;
  int? _addressState;
  int? _addressSuburb;
  String? _postCode;
  DateTime? _dateOfBirth;
  List<Map<String, dynamic>>? _suburbs;
  final List<Map<String, dynamic>> _states = VNAddress.getStates();

  // State variables for validation messages
  String? _userIdError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dobError;
  String? _addressDetailError;

  bool _isInputValid(String val, {int minLength = 8}) {
    return val.isNotEmpty && val.length >= minLength;
  }

  Future<void> _pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  void _clearErrors() {
    setState(() {
      _userIdError = null;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _dobError = null;
      _addressDetailError = null;
    });
  }

  bool _isStepValid() {
    switch (_step) {
      case 1:
        if (!_isInputValid(_userIdController.text)) {
          _userIdError = 'User ID is required and must be 8 characters.';
          return false;
        }
        break;

      case 2:
        if (!_isInputValid(_usernameController.text)) {
          _usernameError =
              'Username is required and must be at least 8 characters.';
          return false;
        }
        break;

      case 3:
        if (!_isInputValid(_passwordController.text)) {
          _passwordError =
              'Password is required and must be at least 8 characters.';
          return false;
        }
        if (_passwordController.text != _confirmPasswordController.text) {
          _confirmPasswordError = 'Passwords do not match.';
          return false;
        }
        break;

      case 4:
        if (_dateOfBirth == null) {
          _dobError = 'Date of birth is required.';
          return false;
        }
        break;

      case 5:
        if (_addressDetailController.text.isEmpty) {
          _addressDetailError = 'Address detail is required';
          return false;
        }
        _handleSubmit();
        break;
    }

    return true;
  }

  void _nextStep() {
    setState(() {
      // Reset validation messages
      _clearErrors();
      if (_isStepValid() && _step < 5) {
        setState(() {
          _step++;
        });
      }
    });
  }

  void _prevStep() {
    if (_step > 1) setState(() => _step--);
  }

  Widget _buildStepFields() {
    switch (_step) {
      case 1:
        return _buildUserIdField();
      case 2:
        return _buildUsernameField();
      case 3:
        return _buildPasswordFields();
      case 4:
        return _buildDOBField();
      case 5:
        return _buildAddressField();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              h24,
              Text('Register a new account',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              h16,
              const Divider(),
              if (_step > 1) _buildPreviousButton(),
              SizedBox(
                height: 240,
                width: 296,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [h16, _buildStepFields()],
                ),
              ),
              h24,
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    int? maxLength,
    String? errorMessage,
    TextInputType keyboardType = TextInputType.text,
    Function? onValid,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      onTapOutside: (pointer) {
        FocusScope.of(context).unfocus();
      },
      onChanged: (val) {
        onValid != null ? onValid() : null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: errorMessage,
        suffixIcon: controller.text.isNotEmpty && _isInputValid(controller.text)
            ? const Icon(
                Icons.check,
                color: AppColors.success,
              )
            : null,
      ),
    );
  }

  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;

  Widget _buildUserIdField() {
    return _buildInputField(
        controller: _userIdController,
        label: 'User ID',
        hintText: 'Enter 8-digit ID',
        icon: Icons.verified_user_sharp,
        errorMessage: _userIdError,
        keyboardType: TextInputType.number,
        maxLength: 8,
        onValid: () => setState(() {
              _userIdError = null;
            }));
  }

  Widget _buildUsernameField() {
    return _buildInputField(
        controller: _usernameController,
        label: 'Username',
        hintText: 'Enter username',
        icon: Icons.person,
        errorMessage: _usernameError,
        keyboardType: TextInputType.text,
        onValid: () => setState(() {
              _usernameError = null;
            }));
  }

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_visiblePassword,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTapOutside: (pointer) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Enter password",
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            errorText: _passwordError,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _visiblePassword = !_visiblePassword;
                  });
                },
                icon: Icon(_visiblePassword
                    ? Icons.visibility_off
                    : Icons.visibility)),
          ),
        ),
        h16,
        TextFormField(
          controller: _confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_visibleConfirmPassword,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTapOutside: (pointer) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            labelText: "Confirm Password",
            hintText: "Re-enter password",
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            errorText: _confirmPasswordError,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _visibleConfirmPassword = !_visibleConfirmPassword;
                  });
                },
                icon: Icon(_visibleConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility)),
          ),
        ),
      ],
    );
  }

  Widget _buildDOBField() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        hintText: 'Select your date of birth',
        errorText: _dobError,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _pickDOB(context),
    );
  }

  Widget _buildAddressField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton(
          value: _addressState,
          isExpanded: true,
          hint: const Text('Select state'),
          icon: const Icon(Icons.location_on),
          items: _states
              .map((state) => DropdownMenuItem(
                  value: state['id'], child: Text(state['state'])))
              .toList(),
          onChanged: (val) {
            setState(() {
              _addressState = val as int?;
              _suburbs = VNAddress.getSuburbs(_addressState);
              _addressSuburb = null;
            });
          },
        ),
        h16,
        DropdownButton(
          value: _addressSuburb,
          isExpanded: true,
          hint: const Text('Select suburb'),
          icon: const Icon(Icons.location_on),
          items: _suburbs
              ?.map((suburb) => DropdownMenuItem(
                  value: suburb['id'], child: Text(suburb['name'])))
              .toList(),
          onChanged: (val) {
            setState(() {
              _addressSuburb = val as int?;
              _postCode =
                  VNAddress.getPostCode(_addressState!, _addressSuburb!);
            });
          },
        ),
        h16,
        _buildInputField(
            controller: _addressDetailController,
            hintText: 'Enter address detail',
            icon: Icons.map,
            label: 'Details',
            errorMessage: _addressDetailError,
            onValid: () => setState(() {
                  _addressDetailError = null;
                })),
        h16,
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
        width: 296,
        child: ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              _nextStep();
            },
            child: Text(_step < 5 ? 'Continue' : 'Submit')));
  }

  Widget _buildPreviousButton() {
    return TextButton.icon(
      onPressed: _prevStep,
      icon: const Icon(Icons.arrow_back),
      label: const Text('Back',
          style:
              TextStyle(color: Colors.black, decoration: TextDecoration.none)),
    );
  }

  void _handleSubmit() async {
    try {
      final request = Request();

      final response = await request.post(
          'api/Auth/RegisterByGuest',
          {
            'username': _usernameController.text,
            'password': _passwordController.text,
            'userId': _userIdController.text,
            'dateOfBirth': _dateOfBirth?.toIso8601String(),
            'addressDetail': _addressDetailController.text,
            'addressState': _addressState.toString(),
            'addressSuburb': _addressSuburb.toString(),
            'postCode': _postCode
          },
          null);

      if (response['StatusCode'] != null && response['StatusCode'] == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['Message'].toString())));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Register Successs')));
        context.go('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
