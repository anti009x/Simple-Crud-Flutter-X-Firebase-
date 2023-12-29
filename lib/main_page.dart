import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_demo/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController pesanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController notlpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: StreamBuilder<DocumentSnapshot>(
            stream: users.doc('95Wsb6eFJ1R3WuaQZayJ').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                //return Text(snapshot.data.data()['age'].toString());
                return Text('Penyewaan Lapangan Futsal');
            },
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                //// VIEW DATA HERE
                //note: 1x
                //  FutureBuilder<QuerySnapshot>(
                //  future: users.get(),
                //   builder: (_, snapshot) {
                //    if (snapshot.hasData) {
                //    return Column(
                //   children: snapshot.data.docs
                //   .map((e) =>
                //    ItemCard(e.data()['name'], e.data()['age']))
                //    .toList(),
                //    );
                //   } else {
                //  return Text('Loading');
                //  }
                // }),
                //note: synced
                StreamBuilder<QuerySnapshot>(
                  stream: users.orderBy('jam', descending: true).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map((e) => ItemCard(
                                  e.data()['name'],
                                  e.data()['jam'],
                                  e.data()['pesan'],
                                  e.data()['tanggal'],
                                  e.data()['notlp'],
                                  onUpdate: () {
                                    users
                                        .doc(e.id)
                                        .update({'jam': e.data()['jam'] + 1});
                                  },
                                  onDelete: () {
                                    users
                                        .doc(e.id)
                                        .update({'jam': e.data()['jam'] - 1});
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return Text("Loading");
                    }
                  },
                ),
                SizedBox(
                  height: 10000,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 10)
                  ]),
                  width: double.infinity,
                  height: 250,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: jamController,
                              decoration: InputDecoration(hintText: "Jam"),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: pesanController,
                              decoration: InputDecoration(hintText: "Pesan"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: tanggalController,
                              decoration: InputDecoration(hintText: "Tanggal"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: notlpController,
                              decoration:
                                  InputDecoration(hintText: "NoTelephone"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: ElevatedButton(
                            child: Text(
                              'Add Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //// ADD DATA HERE
                              users.add({
                                'name': nameController.text,
                                'jam': int.tryParse(jamController.text) ?? 0,
                                'pesan': pesanController.text,
                                'tanggal': tanggalController.text,
                                'notlp': notlpController.text
                              });
                              nameController.text = '';
                              jamController.text = '';
                              pesanController.text = '';
                              tanggalController.text = '';
                              notlpController.text = '';
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
