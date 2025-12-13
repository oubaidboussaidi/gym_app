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

  Future<void> _deleteUser(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
        try {
            await _userService.deleteUser(userId);
            _loadUsers();
        } catch (e) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
        }
    }
  }

  void _showCreateUserDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                // Manually calling register via AuthService instance but ignoring local login effect if needed
                // Actually AuthService.register updates local state. 
                // Creating a simplified register call here is safer.
                await UserService().createUser(emailCtrl.text, passCtrl.text, nameCtrl.text); // Need to add createUser to UserService!
                if (mounted) {
                   Navigator.pop(context);
                   _loadUsers();
                }
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: $e")));
              }
            }, 
            child: const Text("Create")
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateUserDialog,
        child: const Icon(Icons.add),
      ),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _changeRole(user),
                            ),
                            IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(user.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
