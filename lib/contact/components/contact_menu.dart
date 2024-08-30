import 'package:flutter/material.dart';

// Data dummy kontak
class Contact {
  final String name;
  final String phone;
  final String email;
  final IconData icon;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
    required this.icon,
  });
}

// Daftar data dummy kontak
final List<Contact> dummyContacts = [
  Contact(
    name: "John Doe",
    phone: "+1 123 456 7890",
    email: "john.doe@example.com",
    icon: Icons.person,
  ),
  Contact(
    name: "Jane Smith",
    phone: "+1 987 654 3210",
    email: "jane.smith@example.com",
    icon: Icons.person,
  ),
  Contact(
    name: "Company XYZ",
    phone: "+1 555 444 3333",
    email: "info@companyxyz.com",
    icon: Icons.business,
  ),
];

class ContactMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: dummyContacts.map((contact) {
        return ContactMenuItem(
          icon: contact.icon,
          name: contact.name,
          phone: contact.phone,
          email: contact.email,
        );
      }).toList(),
    );
  }
}

class ContactMenuItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String phone;
  final String email;

  ContactMenuItem({
    required this.icon,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
