import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProfileProvider>(context, listen: false);
      provider.fetchData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: const BoxDecoration(
          color: AppColors.bgSecondaryLight,
          borderRadius:
              BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildProfileField('User ID', provider.userId.toString(),
                handleChanged: () {}),
            _buildProfileField('Username', provider.username,
                handleChanged: () {}),
            _buildDOBField("Date of Birth",
                _formatDate(provider.dateOfBirth ?? DateTime.now()),
                enableEdit: true),
            _buildProfileField('Mobile', provider.contactMobile,
                enableEdit: true,
                controller: provider.mobileController,
                keyboardType: TextInputType.number,
                hintText: 'Enter mobile', handleChanged: (val) {
              provider.contactMobile = val;
              print(val);
            }),
            _buildProfileField('Email', provider.contactEmail,
                enableEdit: true,
                controller: provider.emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter email', handleChanged: (val) {
              provider.contactEmail = val;
            }),
            _buildProfileField('Tel', provider.contactTel,
                enableEdit: true,
                controller: provider.telController,
                hintText: 'Enter tel', handleChanged: (val) {
              provider.contactTel = val;
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "State",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                h4,
                DropdownButton(
                  value: provider.addressState != null
                      ? int.parse(provider.addressState!)
                      : null,
                  isExpanded: true,
                  hint: const Text("Select state"),
                  icon: const Icon(Icons.location_on),
                  items: provider.initStates(),
                  onChanged: (val) {
                    provider.handleStateChange(val);
                  },
                ),
                if (provider.addressStateError != null &&
                    provider.addressStateError!.isNotEmpty)
                  Text(
                    provider.addressStateError!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                const Divider(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Suburb",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                h4,
                DropdownButton(
                  value: provider.addressSuburb != null
                      ? int.parse(provider.addressSuburb!)
                      : null,
                  isExpanded: true,
                  hint: const Text("Select suburb"),
                  icon: const Icon(Icons.location_on),
                  items: provider.initSuburbs(),
                  onChanged: (val) {
                    provider.handleSuburbChange(val);
                  },
                ),
                if (provider.addressSuburbError != null &&
                    provider.addressSuburbError!.isNotEmpty)
                  Text(
                    provider.addressSuburbError!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                const Divider(),
              ],
            ),
            _buildProfileField('Address Detail', provider.addressDetail,
                enableEdit: true,
                controller: provider.addressDetailController,
                errorMessage: provider.addressDetailError,
                hintText: 'Enter address detail', handleChanged: (val) {
              provider.addressDetail = val;
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDOBField(String label, String? value,
      {bool enableEdit = false,
      String hintText = '',
      TextEditingController? controller,
      String? errorMessage}) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 4),
                provider.editMode && enableEdit
                    ? SizedBox(
                        width: 296,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: provider.dateOfBirthController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select your date of birth',
                                errorText: provider.dobError,
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: const OutlineInputBorder(),
                              ),
                              onTap: () => provider.pickDOB(context),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        value ?? "",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    UserProfileProvider provider = Provider.of<UserProfileProvider>(context);

    if (picked != null && picked != provider.dateOfBirth) {
      provider.dateOfBirth = picked;
      provider.dateOfBirthController.text =
          DateFormat('yyyy/MM/dd').format(picked);
    }
  }

  Widget _buildInputField(
      {required TextEditingController controller,
      required String hintText,
      String? errorMessage,
      TextInputType keyboardType = TextInputType.text,
      required Function handleChanged}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (val) {
        handleChanged(val);
      },
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
    );
  }

  Widget _buildProfileField(String label, String? value,
      {bool enableEdit = false,
      String hintText = '',
      TextEditingController? controller,
      String? errorMessage,
      required Function handleChanged,
      TextInputType keyboardType = TextInputType.text}) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 4),
                provider.editMode && enableEdit
                    ? SizedBox(
                        width: 296,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildInputField(
                              controller: controller ?? TextEditingController(),
                              hintText: hintText,
                              errorMessage: errorMessage,
                              handleChanged: handleChanged,
                              keyboardType: keyboardType
                            )
                          ],
                        ),
                      )
                    : Text(
                        value ?? "",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
