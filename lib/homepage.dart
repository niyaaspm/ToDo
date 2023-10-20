import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  DateTime selectdate = DateTime.now();
  String a = "select date";
  TextEditingController itemname = TextEditingController();

  void sendData() {
    FirebaseFirestore.instance.collection('todo').add(
      {
        'item': itemname.text,
        'date': selectdate,
      },
    ).then(
      (value) => Navigator.pop(context),
    );
    itemname.clear();
  }

  // TextEditingController datee = TextEditingController();

  // void deletetodo(docId) {
  //   todo.doc(docId).delete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          title: Center(
              child: const Text(
            " todo",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          )),
          titleTextStyle: TextStyle(color: Color.fromARGB(255, 255, 248, 248)),
          backgroundColor: Color.fromARGB(255, 107, 34, 70),
        ),
        backgroundColor: Color.fromARGB(255, 210, 229, 245),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                actions: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: selectdate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000))
                              .then((value) {
                            selectdate = value!;
                          });
                        },
                        child: ValueListenableBuilder(
                          valueListenable: date,
                          builder: (context, value, child) {
                            return Text(
                                '${value.day}/${value.month}/${value.year}');
                          },
                        ),
                      ),
                      TextField(
                        controller: itemname,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Write your Notes"),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            sendData();
                          },
                          child: Text("ok"))
                    ],
                  )
                ],
                title: const Text("Add todo list"),
                contentPadding: const EdgeInsets.all(10.0),
              ),
            );
          },
          child: Icon(Icons.app_registration_sharp),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('todo').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot todosnap =
                        snapshot.data!.docs[index];
                    DateTime date = (todosnap['date'] as Timestamp).toDate();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 255, 237, 39),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 96, 94, 94),
                                  blurRadius: 15,
                                  spreadRadius: 10)
                            ]),
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(todosnap['item']),
                            subtitle: Text(
                                '${date.day.toString()}/${date.month.toString()}/${date.year.toString()}'),
                            trailing: IconButton(
                              color: Color.fromARGB(255, 255, 53, 39),
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
