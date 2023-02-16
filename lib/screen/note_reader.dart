// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  String? title;
  String? desc;
  bool edit = false;

  final CollectionReference ref =
      FirebaseFirestore.instance.collection("Notes");
  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc["color_id"];
    title = widget.doc['note_title'];
    desc = widget.doc['note_content'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorId],
      floatingActionButton: edit
          ? FloatingActionButton(
              onPressed: save,
              child: Icon(Icons.check),
            )
          : null,
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[colorId],
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              )),
          IconButton(
              onPressed: delete,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                title = value;
              },
              initialValue: widget.doc['note_title'],
              enabled: edit,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            // Text(
            //   widget.doc["note_title"],
            //   style: AppStyle.mainTitle,
            // ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            const SizedBox(
              height: 28,
            ),

            TextFormField(
              onChanged: (val) {
                desc = val;
              },
              initialValue: widget.doc["note_content"],
              enabled: edit,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description',
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }

  void delete() async {
    FirebaseFirestore.instance.collection("Notes").doc('user').delete();
    Navigator.pop(context);
  }

  void save() async {
    FirebaseFirestore.instance.collection("Notes").doc('user').update({
      "note_title": title!.trim(),
      "note_content": desc!.trim(),
    });
    Navigator.pop(context);
  }
}
