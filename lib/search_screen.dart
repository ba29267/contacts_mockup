import 'package:flutter/material.dart';
import 'contact.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Contact> contacts;
  const SearchScreen({super.key, required this.contacts});
  
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Contact> searchResults = [];
  Map<int, bool> expansionStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button icon
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter name or phone number',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      searchResults.clear();
                    } else {
                      searchResults = Contact.search(value);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final contact = searchResults[index];
                  final isExpanded = expansionStates[index] ?? false;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        expansionStates[index] = !isExpanded;
                      });
                    },
                    child: Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              contact.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              contact.phoneNumber,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 12.0),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.call, color: Colors.white),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.message, color: Colors.white),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.video_call, color: Colors.white),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.info, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailsScreen(contact: contact)),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
