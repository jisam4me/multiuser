import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class NewRegister extends StatefulWidget {

  const NewRegister({Key key}) : super(key: key);

  @override
  _NewRegisterState createState() => _NewRegisterState();
}


class _NewRegisterState extends State<NewRegister> {

  final _formKey = GlobalKey<FormState>();
  String txtName,txtEmail,txtPassword,txtRole="";
  final databaseReference =FirebaseDatabase.instance.reference().child("Users");
  final _auth = FirebaseAuth.instance;
  void _saveitem() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: txtEmail, password: txtPassword);
      if (newUser != null) {
        final FirebaseUser user = await _auth.currentUser();
        final userID = user.uid;
        _addUsers(userID);
      }
    } catch (e) {
      print('e');
    }
  }
      void _addUsers (String userID){

        databaseReference.child(userID).set({
          'name': txtName,
          'role': txtRole
        });

  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
          children: [ Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imagef/car.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: SingleChildScrollView(
                        child: Form(

                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.face,
                                      color: Colors.black,
                                    ),
                                  ),
                                  labelText: 'Name',
                                ),
                                onSaved: (value){
                                  txtName = value;
                                },
                                validator: validateName,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                  labelText: 'Email',
                                ),
                                onSaved: (value){
                                  txtEmail = value;
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
                                  txtPassword = value;
                                },
                                validator: validatePassword,

                              ),
                              SizedBox(height: 10.0,),
                              DropdownButtonFormField(decoration: InputDecoration(
                                labelText: 'Role'),
                                value: txtRole.isNotEmpty ? txtRole : null,
                                items: ['User','Provider'].map<DropdownMenuItem<String>>((String value){
                                  return DropdownMenuItem(value: value,child: Text(value),);
                                }).toList(),
                                onChanged: (value){
                                setState(() {
                                  txtRole = value.toString();
                                });
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(child: ElevatedButton(onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      _saveitem();
                                      _formKey.currentState.save();

                                    }else{
                                      print('error');
                                    }
                                  },
                                    style: ElevatedButton.styleFrom(primary: Colors.red,),
                                    child: Text('Signup'),)),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                            ],
                          ),
                        ),
                      ),

                    ),
                  )
                ],
              ),
            ),
          ),
          ]
      ),
    ),);

  }

  String validateName(String name) {
    if(name.isEmpty){
      return 'Enter Name';
      }else{
        return null;
    }
    }
  
  String validateEmail(String email) {
    if (email.isEmpty){
      return 'Enter Email';
  }else{
      return null;
    }
}

  String validatePassword(String password) {
    if (password.isEmpty){
      return 'Enter Password';
    }else{
      return null;
    }
  }
}
