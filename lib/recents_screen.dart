import 'package:flutter/material.dart';
import 'contact.dart';
import 'add_contact_screen.dart';
import 'search_screen.dart';

class Call {
  final String name;
  final String phoneNumber;
  final DateTime time;
  final bool outgoing;

  Call({
    required this.name,
    required this.phoneNumber,
    required this.time,
    required this.outgoing,
  });
}
final List<Contact> contacts = Contact.allContacts;
void showAddContactScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddContactScreen()),
  );
}
class RecentsScreen extends StatelessWidget {
  final List<Call> recentCalls = [
    Call(
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      outgoing: true,
    ),
    Call(
      name: 'Jane Smith',
      phoneNumber: '456-789-0123',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      outgoing: true,
    ),
    Call(
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      time: DateTime.now().subtract(const Duration(hours: 12)),
      outgoing: true,
    ),
    Call(
      name: 'Jane Smith',
      phoneNumber: '456-789-0123',
      time: DateTime.now().subtract(const Duration(days: 1)),
      outgoing: false,
    ),
    Call(
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      time: DateTime.now().subtract(const Duration(days: 3)),
      outgoing: false,
    ),
    Call(
      name: 'Jane Smith',
      phoneNumber: '456-789-0123',
      time: DateTime.now().subtract(const Duration(days: 5)),
      outgoing: false,
    ),
    Call(
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      time: DateTime.now().subtract(const Duration(days: 12)),
      outgoing: true,
    ),
    Call(
      name: 'Jane Smith',
      phoneNumber: '456-789-0123',
      time: DateTime.now().subtract(const Duration(days: 21)),
      outgoing: false,
    ),
    Call(
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      time: DateTime.now().subtract(const Duration(days: 30)),
      outgoing: true,
    ),
    Call(
      name: 'Jane Smith',
      phoneNumber: '456-789-0123',
      time: DateTime.now().subtract(const Duration(days: 45)),
      outgoing: false,
    ),
  ];

   RecentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(75),
              padding: const EdgeInsets.all(75),
              child:const Center(
                child: Text(
                  'Phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.black,
            title: const Text('Recents',style: TextStyle(color: Colors.white),),
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.sort,
                  color: Colors.white,),
                onPressed: () {
                },
              ),
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
                icon: const Icon(Icons.more_vert,
                  color: Colors.white,),
                onPressed: () {
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final call = recentCalls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Icon(
                        call.outgoing ? Icons.call_made : Icons.call_received,
                        color: call.outgoing ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        call.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        call.phoneNumber,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        _formatDate(call.time),
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                      },
                    ),
                  ),
                );
              },
              childCount: recentCalls.length,
            ),
          ),

        ],
      ),
    );
  }
  String _formatDate(DateTime time) {
    Duration difference = DateTime.now().difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
