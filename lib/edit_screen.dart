import 'package:flutter/material.dart';
import 'contact.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onUpdateContact;

  const EditContactScreen({super.key, required this.contact, required this.onUpdateContact});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneNumberController = TextEditingController(text: widget.contact.phoneNumber);
    _phoneNumberController.addListener(() {
      final text = _phoneNumberController.text;
      final formattedText = formatPhoneNumber(text);
      if (text != formattedText) {
        _phoneNumberController.value = _phoneNumberController.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number', labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (value.replaceAll('-', '').length != 10) {
                    return 'Phone number must be 10 digits long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedContact = Contact(
                      name: _nameController.text,
                      phoneNumber: _phoneNumberController.text,
                    );
                    Contact.updateContact(updatedContact);
                    widget.onUpdateContact(updatedContact);
                    Navigator.pop(context, updatedContact);
                  }
                },
                child: const Icon(Icons.save),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String formatPhoneNumber(String text) {
    text = text.replaceAll('-', '');
    if (text.length > 3 && text.length < 7) {
      return '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length >= 7) {
      return '${text.substring(0, 3)}-${text.substring(3, 6)}-${text.substring(6)}';
    }
    return text;
  }
}
