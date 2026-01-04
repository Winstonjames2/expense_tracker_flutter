import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayNameText extends StatelessWidget {
  const DisplayNameText({super.key});

  Future<String> _getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayName') ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FutureBuilder<String>(
          future: _getDisplayName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.white);
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(color: Colors.white, fontSize: 16),
              );
            } else {
              return Text(
                snapshot.data!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
