import 'package:flutter/material.dart';
import 'contact.dart';
import 'edit_screen.dart';


class DetailsScreen extends StatefulWidget {
  final Contact contact;

  const DetailsScreen({super.key, required this.contact});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Contact _updatedContact;

  @override
  void initState() {
    super.initState();
    _updatedContact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, _updatedContact);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Card(
              color: Colors.grey[900],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, size: 60, color: Colors.black),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      _updatedContact.name,
                      style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Phone ${_updatedContact.phoneNumber}',
                      style: const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildIconButton(Icons.call, Colors.green),
                        buildIconButton(Icons.message, Colors.blue),
                        buildIconButton(Icons.video_call, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: Colors.grey[900],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildOptionButton("Viber", Icons.videocam),
                    const SizedBox(height: 10.0),
                    buildOptionButton("WhatsApp", Icons.message),
                    const SizedBox(height: 10.0),
                    buildOptionButton("Telegram", Icons.message),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildGreyButton("History"),
                const SizedBox(height: 10),
                buildGreyButton("Storage Locations"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.star, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                _navigateToEditScreen();
              },
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.share, color: Colors.white),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget buildOptionButton(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(color: Colors.white)),
        Icon(icon, color: Colors.white),
      ],
    );
  }

  Widget buildGreyButton(String text) {
    return ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Contact"),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Contact.delete(_updatedContact.name);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
  void _navigateToEditScreen() async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditContactScreen(contact: _updatedContact, onUpdateContact: updateContactList)),
    );
    if (updatedContact != null) {
      setState(() {
        _updatedContact = updatedContact;
      });
    }
  }

  void updateContactList(Contact updatedContact) {
    Contact.updateContact(updatedContact);
  }


}
