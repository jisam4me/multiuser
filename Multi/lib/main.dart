import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_userrole/NewRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multilevel_userrole/admin_page.dart';
import 'package:multilevel_userrole/user_page.dart';


void main() async {
  runApp(MaterialApp(
      // theme: ThemeData(
      //   // Define the default brightness and colors.
      //     //brightness: Brightness.dark,
      //     primaryColor: Colors.red,
      //   accentColor: Colors.redAccent,
      //     ),
      // debugShowCheckedModeBanner: false,
      home:
      // NewRegister()
      MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String txtemail,txtpassword;
  final _auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  void _signIn() async {
    try{
      final newUser = await _auth.signInWithEmailAndPassword(email: txtemail, password: txtpassword);
      if (newUser != null){
        final FirebaseUser user = await _auth.currentUser();
        final userID = user.uid;
        await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(userID)
        .once()
        .then((DataSnapshot snapshot){
          setState(() {
            if (snapshot.value['role']=='Provider'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Adminpage()));

            }else if(snapshot.value['role']=='User'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage()));

            }
          });
        });
      }else{
        print('fail');
      }

    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(

        children: [ Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imagef/road.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Email / Username',
                          ),
                          onSaved: (value){
                            txtemail = value;
                          },
                          validator: validateEmail,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Password',
                          ),
                            onSaved: (value){
                              txtpassword = value;
                            },
                            validator: validatePassword,

                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: (){
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                _signIn();
                              }
                            },
                            style: ElevatedButton.styleFrom(primary: Colors.red,),
                            child: Text('Login'),)),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewRegister()));
                        },
                          child: Text('Create New Account',
                          style: TextStyle(color: Colors.red),
                          ),)
                      ],
                    ),
                  ),

                ),
              )
            ],
          ),
        ),
      ]
      ),
    ));
  }

  String validateEmail(String email) {
    if (email.isEmpty){
      return 'Enter email address';
    }else{
      return null;
    }
  }

  String validatePassword(String password) {
    if (password.isEmpty){
      return 'Enter password';
    }else{
      return null;
    }
  }
}

