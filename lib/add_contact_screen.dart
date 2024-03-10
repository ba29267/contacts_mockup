import 'package:flutter/material.dart';
import 'contact.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Add Contact',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const AddContactForm(),
    );
  }
}

class AddContactForm extends StatefulWidget {
  const AddContactForm({super.key});

  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name',labelStyle: TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number',labelStyle: TextStyle(color: Colors.white)),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              String formattedPhoneNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (formattedPhoneNumber.length > 10) {
                formattedPhoneNumber = formattedPhoneNumber.substring(0, 10);
              }
              if (formattedPhoneNumber.length >= 3) {
                formattedPhoneNumber = '${formattedPhoneNumber.substring(0, 3)}-${formattedPhoneNumber.substring(3, formattedPhoneNumber.length)}';
              }
              if (formattedPhoneNumber.length >= 7) {
                formattedPhoneNumber = '${formattedPhoneNumber.substring(0, 7)}-${formattedPhoneNumber.substring(7, formattedPhoneNumber.length)}';
              }
              _phoneNumberController.value = _phoneNumberController.value.copyWith(
                text: formattedPhoneNumber,
                selection: TextSelection.collapsed(offset: formattedPhoneNumber.length),
              );
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: const ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.grey) ),
            onPressed: () {
              String name = _nameController.text.trim();
              String phoneNumber = _phoneNumberController.text.trim();
              if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                bool nameExists = Contact.allContacts.any((contact) => contact.name == name);
                bool phoneNumberExists = Contact.allContacts.any((contact) => contact.phoneNumber == phoneNumber);
                if (nameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact with this name already exists.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (phoneNumberExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact with this phone number already exists.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  Contact newContact = Contact(
                    name: name,
                    phoneNumber: phoneNumber,
                  );
                  Contact.allContacts.add(newContact);
                  Contact.notifyListeners();
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Add',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

