import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/helper/services/auth_service.dart';

import '../style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late String title;
  late String desc;
  bool edit = false;

  final CollectionReference ref = FirebaseFirestore.instance.collection("user");

  @override
  void initState() {
    super.initState();
    title = widget.doc['note_title'];
    desc = widget.doc['note_content'];
  }

  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc["color_id"];

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
            ),
          ),
          IconButton(
            onPressed: () {
              showDeleteConfirmationDialog();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
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

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteNote();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deleteNote() async {
    AuthService authService = AuthService();
    DocumentReference notecol = FirebaseFirestore.instance
        .collection("Notes")
        .doc(authService.firebaseAuth.currentUser!.uid)
        .collection('notes')
        .doc(widget.doc.id);

    notecol.delete();

    Navigator.pop(context);
  }

  void save() async {
    AuthService authService = AuthService();
    DocumentReference notecol = FirebaseFirestore.instance
        .collection("Notes")
        .doc(authService.firebaseAuth.currentUser!.uid)
        .collection('notes')
        .doc(widget.doc.id);

    try {
      await notecol.update({
        "note_title": title.trim(),
        "note_content": desc.trim(),
      });
      Navigator.pop(context);
    } catch (e) {
      // Handle error, if any
      print("Error updating note: $e");
      // You can show a snackbar or an error dialog to inform the user about the failure.
    }
  }
}
