import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Firebase cloud firestore Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _streamSubscription;

  @override
  Widget build(BuildContext context) {
    // IDS
    print(firestore.collection('users').id);
    print(firestore.collection('users').doc().id);

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  addToNewData();
                },
                child: Text('add To Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                )),
            ElevatedButton(
                onPressed: () {
                  addToNewDataWithSet();
                },
                child: Text('Add to Data with Set'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent)),
            ElevatedButton(
                onPressed: () {
                  updateToNewDataWithSet();
                },
                child: Text('Update to Data'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.yellow)),
            ElevatedButton(
                onPressed: () {
                  deleteToNewDataWithSet();
                },
                child: Text('Delete to Data'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
            ElevatedButton(
                onPressed: () {
                  readToNewDataWithSet();
                },
                child: Text('Read to Data one time'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
            ElevatedButton(
                onPressed: () {
                  readRalTimeToNewDataWithSet();
                },
                child: Text('Read to Data RealTime'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
            ElevatedButton(
                onPressed: () {
                  stopStream();
                },
                child: Text('Stop Stream'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent)),
            ElevatedButton(
                onPressed: () {
                  batchWord();
                },
                child: Text('Batch Word'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent)),
            ElevatedButton(
                onPressed: () {
                  transactionWord();
                },
                child: Text('Transaction Word'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  void addToNewData() async {
    Map<String, dynamic> _addUser = {};
    _addUser['name'] = 'eda';
    _addUser['age'] = '24';
    _addUser['isStudent'] = 'false';
    _addUser['address'] = {
      'street': '943 59th Street',
      'streetLine2': '',
      'city': 'Brooklyn',
      'state': 'NY',
      'Zip': '11222'
    };
    _addUser['colors'] = FieldValue.arrayUnion(['blue', 'green']);
    _addUser['createAt'] = FieldValue.serverTimestamp();
    await firestore.collection('users').add(_addUser);
  }

  Future<void> addToNewDataWithSet() async {
    var _newDocID = firestore.collection('users').doc().id;
    await firestore
        .doc('users/$_newDocID')
        .set({'name': 'Fatma Sara', 'userID': _newDocID});

    await firestore.doc('users/Y507Xq9N7GCUI6ntZnMX').set(
        {'school': 'brooklyn college', 'age': FieldValue.increment(1)},
        SetOptions(merge: true));
  }

  Future<void> updateToNewDataWithSet() async {
    await firestore
        .doc('users/Y507Xq9N7GCUI6ntZnMX')
        .update({'name': 'guncel Eda', 'isStudent': 'true'});
  }

  Future<void> deleteToNewDataWithSet() async {
    await firestore.doc('users/Y507Xq9N7GCUI6ntZnMX').delete();
  }

  Future<void> readToNewDataWithSet() async {
    var _usersDocuments = await firestore.collection('users').get();
    print(_usersDocuments.size.toString());
    print(_usersDocuments.docs.length.toString());
    for (var eleman in _usersDocuments.docs) {
      print('Document ID: ${eleman.id}');
      Map userMap = eleman.data();
      print(userMap['name']);
    }
    var _suleymanDoc = await firestore.doc('users/Dh0XYbXnj5UMgqpa08ja').get();
    print(_suleymanDoc.data()!['address']['street']);
  }

  Future<void> readRalTimeToNewDataWithSet() async {
    var userStream = await firestore.collection('users').snapshots();
    _streamSubscription = userStream.listen((event) {
      event.docChanges.forEach((element) {
        print(element.doc.data().toString());
      });
    });
  }

  Future<void> stopStream() async {
    await _streamSubscription?.cancel();
  }

  void batchWord() async{
    WriteBatch _batch= firestore.batch();
    CollectionReference _counterColRef = firestore.collection('counter');

    // Create 100 items with together. If can wrong create in 100 items, for example 51 th item will be stop and then all items is not creating database
    /*for(int  number=0; number<100;number++){
      var _newDoc=_counterColRef.doc();
      _batch.set(_newDoc, {'counter':++number, 'id' : _newDoc.id});
    }*/
    
    /*var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element){
      _batch.update(element.reference, {'creatAt': FieldValue.serverTimestamp()});
    });*/

    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element){
      _batch.delete(element.reference);
    });

    await _batch.commit();
  }

  void transactionWord() {


  }
}
