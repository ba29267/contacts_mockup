import 'dart:io';

class Contact {
  String name;
  String phoneNumber;
  File photo;

  static Set<String> usedNames = {};

  Contact({
    required this.name,
    required this.phoneNumber,
    File? photo,
  }) : photo = photo ?? File('assets/default.png') {
    usedNames.add(name);
  }

  static List<Contact> allContacts = [
    Contact(name: 'Joh Do', phoneNumber: '123-456-7990'),
    Contact(name: 'Jae Smit', phoneNumber: '456-799-0123'),
    Contact(name: 'Ali John', phoneNumber: '787-032-3456'),
    Contact(name: 'Jo Do', phoneNumber: '123-455-7590'),
    Contact(name: 'Ja Smith', phoneNumber: '456-888-0123'),
    Contact(name: 'Alice son', phoneNumber: '789-333-3456'),
    Contact(name: 'John Done', phoneNumber: '123-456-9999'),
    Contact(name: 'ane mith', phoneNumber: '456-779-0323'),
    Contact(name: 'Ace son', phoneNumber: '889-412-3456'),
    Contact(name: 'John Doe', phoneNumber: '123-456-7890'),
    Contact(name: 'Jane Smith', phoneNumber: '456-789-0123'),
    Contact(name: 'Alice Johnson', phoneNumber: '789-012-3456'),
  ];

  static void create({
    required String name,
    required String phoneNumber,
    File? photo,
  }) {

    if (usedNames.contains(name)) {
      throw Exception('Name already exists');
    }
    if (phoneNumber.length != 10) {
      throw Exception('Phone number must be 10 digits long');
    }
    Contact newContact = Contact(
      name: name,
      phoneNumber: phoneNumber,
      photo: photo,
    );
    allContacts.add(newContact);
    usedNames.add(name);
  }

  static void update({
    required String oldName,
    required String newName,
    String? phoneNumber,
    File? photo,
  }) {

    if (newName != oldName && usedNames.contains(newName)) {
      throw Exception('Name already exists');
    }
    int index = allContacts.indexWhere((c) => c.name == oldName);
    if (index != -1) {
      if (phoneNumber != null && phoneNumber.length != 10) {
        throw Exception('Phone number must be 10 digits long');
      }
      usedNames.remove(oldName);
      if (newName != oldName) {
        usedNames.add(newName);
      }
      Contact contact = allContacts[index];
      contact.name = newName;
      contact.phoneNumber = phoneNumber ?? contact.phoneNumber;
      contact.photo = photo ?? contact.photo;
      notifyListeners();
    }
  }

  static void updateContact(Contact updatedContact) {
    final index = allContacts.indexWhere((contact) => contact.name == updatedContact.name);
    if (index != -1) {
      allContacts[index] = updatedContact;
    }
  }

  static void delete(String name) {
    allContacts.removeWhere((contact) => contact.name == name);
    usedNames.remove(name);
    notifyListeners();
  }

  static List<Contact> search(String keyword) {
    return allContacts.where((contact) =>
    contact.name.toLowerCase().contains(keyword.toLowerCase()) ||
        contact.phoneNumber.contains(keyword)).toList();
  }

  String getFormattedPhoneNumber() {
    if (phoneNumber.length == 10) {
      return phoneNumber.replaceRange(3, 3, '-').replaceRange(7, 7, '-');
    } else {
      return phoneNumber;
    }
  }

  static void Function()? listener;

  static void notifyListeners() {
    if (listener != null) {
      listener!();
    }
  }
}

