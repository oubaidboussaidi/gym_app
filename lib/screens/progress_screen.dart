import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/user_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final UserService _userService = UserService();
  final AuthService _auth = AuthService();
  
  // Example stats controller
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _squatController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // In a real app, we'd fetch the latest user object here or pass it in.
    // For now, initializing empty.
  }

  Future<void> _saveProgress() async {
    setState(() => _isLoading = true);
    // TODO: Ideally we need the real userId here.
    // Assuming backend endpoint /users/:id works and we can get ID from Auth token decode or stored user
    // For this prototype, if we don't have ID, we might fail.
    // Let's assume AuthService has a way to get userID or we rely on token.
    
    // Fallback ID or need to fetch it. (Prototype limitation: assuming we know ID or endpoint handles 'me')
    // If backend uses /users/me, that's better. If /users/:id, we need the ID.
    // Let's assume we can't save without ID.
    
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Progress saved! (Prototype Mock)")),
       );
       setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Progress", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _buildStatCard("Body Weight", Icons.monitor_weight, _weightController, "kg"),
             const SizedBox(height: 15),
             _buildStatCard("Squat Max", Icons.fitness_center, _squatController, "kg"),
             
             const SizedBox(height: 30),
             
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: _isLoading ? null : _saveProgress,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.black87,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                 child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Update Progress", style: TextStyle(fontSize: 18, color: Colors.white)),
               ),
             )
           ],
         ),
      ),
    );
  }

  Widget _buildStatCard(String title, IconData icon, TextEditingController controller, String suffix) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.deepPurple, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 5),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "0",
                    suffixText: suffix,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
