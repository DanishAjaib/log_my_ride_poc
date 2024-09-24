import 'package:flutter/material.dart';

class NewFriendDialog extends StatefulWidget {
  const NewFriendDialog({super.key});

  @override
  State<NewFriendDialog> createState() => _NewFriendDialogState();
}

class _NewFriendDialogState extends State<NewFriendDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new friend'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the email of the friend you want to add'),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // add friend
            },
            child: const Text('Add Friend'),
          ),
        ],
      ),
    );
  }
}
