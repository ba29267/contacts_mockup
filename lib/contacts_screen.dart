import 'package:flutter/material.dart';
import 'contact.dart';
import 'search_screen.dart';
import 'add_contact_screen.dart';
import 'details_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = Contact.allContacts;

  @override
  void initState() {
    super.initState();
    Contact.listener = _updateContacts;
  }

  @override
  void dispose() {
    super.dispose();
    Contact.listener = null;
  }

  void _updateContacts() {
    setState(() {
      contacts = Contact.allContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    contacts.sort((a, b) => a.name.compareTo(b.name));
    Map<String, List<Contact>> groupedContacts = groupContactsByFirstLetter();

    int totalContacts = contacts.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(75),
              padding: const EdgeInsets.all(50),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Phone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Contacts: $totalContacts',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Contacts',
              style: TextStyle(color: Colors.white),
            ),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddContactScreen()),
                  ).then((_) {
                    _updateContacts();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(contacts: contacts)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  String letter = groupedContacts.keys.elementAt(index);
                  List<Contact> contactsForLetter = groupedContacts[letter]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          color: Colors.grey[900],
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              letter,
                              style: const TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      ...contactsForLetter.map((contact) =>
                          ContactTile(contact: contact, updateContact: updateContact),),
                      const SizedBox(height: 12.0),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 12.0),
                    ],
                  );
                },
                childCount: groupedContacts.keys.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Map<String, List<Contact>> groupContactsByFirstLetter() {
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.name.substring(0, 1).toUpperCase();
      if (!groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }
    return groupedContacts;
  }

  void showDetailsScreen(BuildContext context, Contact contact) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(contact: contact)),
    );
    if (updatedContact != null) {
      updateContact(updatedContact);
    }
  }

  void updateContact(Contact updatedContact) {
    setState(() {
      int index = contacts.indexWhere((c) => c.name == updatedContact.name);
      if (index != -1) {
        contacts[index] = updatedContact;
      }
    });
  }

}
class ContactTile extends StatefulWidget {
  final Contact contact;
  final Function(Contact) updateContact;

  const ContactTile({super.key, required this.contact, required this.updateContact});

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(widget.contact.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(
                      widget.contact.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 20.0),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Phone: ${widget.contact.phoneNumber}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildIconButton(Icons.call, Colors.green, widget.contact),
                          buildIconButton(Icons.message, Colors.blue, widget.contact),
                          buildIconButton(Icons.video_call, Colors.green, widget.contact),
                          buildIconButton(Icons.info, Colors.grey, widget.contact),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIconButton(IconData icon, Color color, Contact contact) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () async {
          if (icon == Icons.info) {
            final updatedContact = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen(contact: contact)),
            );
            if (updatedContact != null) {
              widget.updateContact(updatedContact);
            }
          }
        },
      ),
    );
  }

}
