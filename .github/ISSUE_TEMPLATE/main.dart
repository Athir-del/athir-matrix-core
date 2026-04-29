import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ConnectionScreen(),
    );
  }
}

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final ApiService _apiService = ApiService();
  String _status = "التطبيق جاهز للربط";
  bool _isConnecting = false;

  // وظيفة إنشاء الربط
  Future<void> _startLinking() async {
    setState(() {
      _isConnecting = true;
      _status = "جاري إنشاء الربط...";
    });

    final result = await _apiService.connectAndFetch();

    setState(() {
      _status = result;
      _isConnecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إتمام إنتاج التطبيق')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _isConnecting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _startLinking,
                    child: const Text('إنشاء الربط الآن')),
          ],
        ),
      ),
    );
  }
}
