import 'package:flutter/material.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/services/user_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final users = await _userService.getAllUsers();
      setState(() { _users = users; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _changeRole(User user) async {
    final newRole = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select New Role'),
        children: [
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'user'), child: const Text('User')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'coach'), child: const Text('Coach')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'admin'), child: const Text('Admin')),
        ],
      ),
    );

    if (newRole != null && newRole != user.role) {
      try {
        await _userService.updateUserRole(user.id, newRole);
        _loadUsers(); // Refresh
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Role updated to $newRole")));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(user.role[0].toUpperCase()),
                          backgroundColor: user.isCoach ? Colors.blue : (user.isAdmin ? Colors.red : Colors.grey),
                        ),
                        title: Text(user.email),
                        subtitle: Text("Role: ${user.role.toUpperCase()} | Name: ${user.firstName}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _changeRole(user),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
