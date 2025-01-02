import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['LOCAL_SUPABASE_URL']!,
    anonKey: dotenv.env['LOCAL_SUPABASE_ANON_KEY']!,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

final supabase = Supabase.instance.client;

class _MainAppState extends State<MainApp> {
  late Future<List<Map<String, dynamic>>> _future;

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final response = await supabase.from('idols').select();
      print('Response: $response');
      print('Data fetched successfully: $response');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data'));
            }

            final idols = snapshot.data;
            return ListView.builder(
              itemCount: idols!.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  width: 100,
                  child: ListTile(
                    title: Text(idols[index]['name']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
