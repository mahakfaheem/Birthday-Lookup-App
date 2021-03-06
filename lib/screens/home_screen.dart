import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahakfaheem_mdp_crud_app/database/database.dart';
import 'package:mahakfaheem_mdp_crud_app/models/birthday_lookup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mahakfaheem_mdp_crud_app/screens/signin_screen.dart';


import 'add_new_screen.dart';

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
        ),
      ),
    );
  }
}





class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //get all note from our database
  late Future<List<Note>> _noteList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).primaryColor,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormat.format(note.date!)}-${note.priority}',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).primaryColor,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note);
                _updateNoteList();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddNoteScreen(
                  updateNoteList : _updateNoteList(),
                  note: note,

                ),
              ),
            ),
          ),
          Divider(
            height: 5.0,
            color: Colors.black54,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],


      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) =>
              AddNoteScreen(
                updateNoteList: _updateNoteList,
              )));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;
            return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Upcoming Birthdays',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 33.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '$completedNoteCount of ${snapshot.data.length}',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildNote(snapshot.data![index - 1]);
                });

          }
          ),
    );

  }
}

