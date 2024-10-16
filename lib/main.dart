import 'package:flutter/material.dart';
import 'package:better_faster_stronger/services/database_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Database Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  final DatabaseService _dbService = DatabaseService.instance;

  int id = 0;
  String name = "";
  String surname = "";

  @override
  Widget build(BuildContext context) {
    
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Id',
                      ),
                    ),
                    const SizedBox(height: 20,),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 20,),

                    TextFormField(
                      controller: surnameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Surname',
                      ),
                    ),
                    const SizedBox(height: 20,),

                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            _dbService.addRegister(nameController.text, surnameController.text);
                          },
                          child: const Text('Insert'),
                        ),
                        const SizedBox(width: 20,),

                        ElevatedButton(
                          onPressed: () async {
                            
                          },
                          child: const Text('Update'),
                        ),
                        const SizedBox(width: 20,),

                        ElevatedButton(
                          onPressed: () async {
                          
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                  ]
                ),
              ),
            ),
            const SizedBox(width: 100,),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Id',
                    ),
                  )
                ),
                const SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: () async {
                    
                  },
                  child: const Text('Get register'),
                ),
                const SizedBox(height: 100,),

                Text('ID: $id'),
                const SizedBox(height: 10,),
                Text('Name: $name'),
                const SizedBox(height: 10,),
                Text('Surname: $surname'),
                const SizedBox(height: 10,),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Nothing',
        child: const Icon(Icons.accessible_forward_outlined),
      ),
    );
  }
}