import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Form'),
        ),
        body: DynamicForm(),
      ),
    );
  }
}

class DynamicForm extends StatefulWidget {
  const DynamicForm({super.key});
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _items = [];
  final List<TextEditingController> _controllers = [];

  void _addNewItem() {
    setState(() {
      _controllers.add(TextEditingController());
      _controllers.add(TextEditingController());
      _items.add({'title': '', 'info': ''});
    });
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // 保存処理をここに追加
      print(_items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              for (int i = 0; i < _items.length; i += 2)
                Column(
                  children: [
                    TextFormField(
                      controller: _controllers[i],
                      decoration:
                          InputDecoration(labelText: 'Title ${i ~/ 2 + 1}'),
                      onSaved: (value) {
                        _items[i]['title'] = value ?? '';
                      },
                    ),
                    TextFormField(
                      controller: _controllers[i + 1],
                      decoration:
                          InputDecoration(labelText: 'Info ${i ~/ 2 + 1}'),
                      onSaved: (value) {
                        _items[i + 1]['info'] = value ?? '';
                      },
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: _addNewItem,
                child: Text('行を追加'),
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('保存'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length ~/ 2,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_items[index * 2]['title']!),
                subtitle: Text(_items[index * 2 + 1]['info']!),
              );
            },
          ),
        ),
      ],
    );
  }
}
