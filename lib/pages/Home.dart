import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/pages/FindPage.dart';
import 'package:flutter_app_one/pages/LostPage.dart';
import 'package:flutter_app_one/pages/ContactPage.dart';
import 'package:flutter_app_one/pages/ProfilePage.dart';
import 'package:flutter_app_one/pages/ChatWithAI.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ContactPage(),
    const ProfilePage(),
    const ChatWithAI(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DaffoFind"),
        backgroundColor: const Color.fromARGB(255, 255, 132, 0),
        foregroundColor: Colors.white, // AppBar text/icon color
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 255, 132, 0),
        unselectedItemColor: const Color.fromARGB(255, 255, 132, 0).withOpacity(0.5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "ChatWithAI"),
        ],
      ),
    );
  }
}


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Function to delete a post from Firestore
  Future<void> _deletePost(String collection, String docId) async {
    await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
  }

  // Function to update a post in Firestore with a popup dialog
  Future<void> _updatePost(BuildContext context, String collection,
      String docId, Map<String, dynamic> data) async {
    TextEditingController nameController =
        TextEditingController(text: data['name']);
    TextEditingController locationController =
        TextEditingController(text: data['location']);
    TextEditingController dateController =
        TextEditingController(text: data['date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location")),
              TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: "Date")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(docId)
                    .update({
                  "name": nameController.text,
                  "location": locationController.text,
                  "date": dateController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner Image
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Banner.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Stream for Lost Posts
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('lost_posts')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: snapshot.data!.docs.map((doc) {
                  return _buildItemCard(
                    context: context,
                    docId: doc.id,
                    collection: 'lost_posts',
                    data: doc,
                    icon: Icons.wallet_giftcard,
                    color: Colors.red,
                  );
                }).toList(),
              );
            },
          ),

          // Stream for Found Posts
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('find_posts')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: snapshot.data!.docs.map((doc) {
                  return _buildItemCard(
                    context: context,
                    docId: doc.id,
                    collection: 'find_posts',
                    data: doc,
                    icon: Icons.phone_android,
                    color: Colors.green,
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),

          // Buttons for Creating Posts
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Found Post Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt, size: 24),
                    label: const Text(
                      "Found Post",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Lost Post Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LostPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.location_on, size: 24),
                    label: const Text(
                      "Lost Post",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card Widget for displaying a post item
  Widget _buildItemCard({
    required BuildContext context,
    required String docId,
    required String collection,
    required QueryDocumentSnapshot data,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text("\uD83D\uDCCD ${data['location']}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 5),
                  Text("\uD83D\uDCC5 ${data['date']}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _updatePost(
                  context, collection, docId, data.data() as Map<String, dynamic>),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePost(collection, docId),
            ),
          ],
        ),
      ),
    );
  }
}