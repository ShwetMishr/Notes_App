import 'package:database_in_flutter/Data/local/db_helper.dart';
import 'package:flutter/material.dart';
class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {

  TextEditingController titleController=TextEditingController();
  TextEditingController desController=TextEditingController();

  List<Map<String,dynamic>> allNotes=[];
  DBHelper?dbRef;

  @override
  void initState() {
    super.initState();
    dbRef=DBHelper.getInstance;
    getNotes();
  }

  void getNotes()async{
    allNotes=await dbRef!.getAllNotes();
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" Notes Application "),centerTitle: true,backgroundColor: Colors.red,),
      // all note visible here
      body: allNotes.isNotEmpty ? ListView.builder(
        itemCount: allNotes.length,
          itemBuilder: (_,index){
          return ListTile(
            leading: Text('${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}'),
            title:Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
            subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
            trailing: SizedBox(
              width: 50,
              child: Row(
                children: [
                  InkWell(
                    onTap: (){

                    },
                      child: Icon(Icons.edit)),
                  InkWell(
                    onTap: ()async {
                      bool check=await dbRef!.deleteNote(sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                      if(check){
                        getNotes();
                      }
                    },
                      child: Icon(Icons.delete)),

                ],
              ),
            ),
          );


          }):Center(
        child: Text("No Notes Yet!!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
        // // All Note to be Added from Here
        // bool check=await dbRef!.addNote(mTitle: "Person fav Note Note", mDesc: "Love You");
        // if(check){
        //   getNotes();
        // }
         String errorMsg="";
          showModalBottomSheet(
              context: context, builder: (context){
                return Container(
                  padding: EdgeInsets.all(11),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Add Note",style: TextStyle(fontSize: 25),),
                      SizedBox(
                        height: 21,
                      ),
                      SizedBox(
                    height: 21,
                ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Enter Title Here",
                            label: Text("Title"),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11))),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      TextField(
                        controller: desController,
                        maxLines: 4,
                        decoration: InputDecoration(

                            hintText: "Enter Title Here",
                            label: Text("Description"),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11))),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(onPressed: () async{
                              var Title=titleController.text;
                              var Desc=titleController.text;

                              if(Title.isNotEmpty && Desc.isNotEmpty){
                                bool check=await dbRef!.addNote(mTitle: Title, mDesc: Desc);
                                if(check){
                                  getNotes();
                                }
                                Navigator.pop(context);
                              }
                              else{
                                errorMsg="Please fill all required blank ";
                                setState(() {

                                });
                              }
                              titleController.clear();
                              desController.clear();




                            }, child: Text("Add Note")),
                          ),
                          SizedBox(width: 11,),
                          Expanded(
                            child:OutlinedButton(onPressed: (){
                              Navigator.pop(context);

                          }, child: Text("Cancel Note")),
                          ),
                          Text(errorMsg)
                        ],

                      ),
                    ],

                  ),
                );

              });
      },child: Icon(Icons.add),),


    );
  }
}
