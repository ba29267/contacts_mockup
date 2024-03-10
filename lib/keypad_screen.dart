import 'package:flutter/material.dart';
import 'contact.dart';
import 'search_screen.dart';
import 'add_contact_screen.dart';

class KeypadScreen extends StatefulWidget {
  const KeypadScreen({super.key});

  @override
  _KeypadScreenState createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  String typedNumbers = '';
  List<Contact> potentialContacts = [];
  final List<Contact> contacts = Contact.allContacts;

  void addToTypedNumbers(String number) {
    setState(() {
      if (typedNumbers.length < 12) {
        if (typedNumbers.length == 3 || typedNumbers.length == 7) {
          typedNumbers += '-';
          typedNumbers += number;
        } else {
          typedNumbers += number;
        }
      }
      potentialContacts = Contact.search(typedNumbers);
    });
  }
  void showAddContactScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
  }

  void clearTypedNumbers() {
    setState(() {
      typedNumbers = '';
      potentialContacts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keypad'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                showAddContactScreen(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(contacts: contacts)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 200.0,
              child: ListView.builder(
                itemCount: potentialContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      potentialContacts[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      potentialContacts[index].phoneNumber,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        typedNumbers = potentialContacts[index].phoneNumber;
                        potentialContacts.clear();
                      });
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 75.0,
              child: Center(
                child: Text(
                  typedNumbers,
                  style: const TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.25,
                padding: const EdgeInsets.all(30.0),
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(12, (index) {
                  if (index < 9) {
                    return GestureDetector(
                      onTap: () => addToTypedNumbers('${index + 1}'),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<String> specialKeys = ['*', '0', '#'];
                    return GestureDetector(
                      onTap: () => addToTypedNumbers(specialKeys[index - 9]),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: Text(
                            specialKeys[index - 9],
                            style: const TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (typedNumbers.isNotEmpty) {
                              setState(() {
                                typedNumbers = typedNumbers.substring(0, typedNumbers.length - 1);
                              });
                            }
                          },
                          icon: const Icon(Icons.video_call_rounded),
                          color: Colors.white,
                          iconSize: 36.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 36.0,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (typedNumbers.isNotEmpty) {
                              setState(() {
                                typedNumbers = typedNumbers.substring(0, typedNumbers.length - 1);
                              });
                            }
                          },
                          icon: const Icon(Icons.backspace),
                          color: Colors.white,
                          iconSize: 36.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
