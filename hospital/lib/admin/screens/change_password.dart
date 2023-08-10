import 'package:flutter/material.dart';
import 'package:hospital/components/button.dart';
import 'package:hospital/models/Admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final Admin admin;
  const ChangePassword({super.key, required this.admin});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(33, 150, 243, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Button(
                  width: 400,
                  title: 'Save Changes',
                  onPressed: () {
                    _changePassword(
                        _currentPasswordController.text,
                        _newPasswordController.text,
                        _confirmPasswordController.text,
                        widget.admin,
                        widget.admin.token,
                        context
                    );
                  },
                  disable: true,
                  height: 50),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _changePassword( String currentPassword, String newPassword, String confirmPassword, Admin admin, String token ,BuildContext context ) async {
  final Uri api = Uri.parse('http://192.168.1.8:3000/admin/changePassword');
  try{
      final response = await http.post(api , body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'id': admin.id,
        'token': token,
      });
    _showChangepaswordDialog(context);
  }
  catch(e)
  {
    print(e);
  } 
}


void _showChangepaswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password Changed Successfully'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
