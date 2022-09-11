import 'package:caller_app/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Telephony telephony = Telephony.instance;
  late String currentNumber;
  String Number = "";
  int selected = -1;
  bool isLoading = false;
  void showInSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Message Sent"),
    ));
  }

  void _sendSMS(String message, List<String> recipents) async {
    print(message);
    print(recipents);
    String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
   showInSnackBar();

  }

  void saveNumber(String number) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString("number", number);
  }

  void getNumber() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String num = (prefs.getString('number') ?? "");
    Number = num;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    telephony.requestPhoneAndSmsPermissions;
    getNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             isLoading ?Container(
               child: const CircularProgressIndicator(

               ),
             ) : Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex:2,
                        child: Container(
                          child: Row(
                            children: [

                              Expanded(
                                flex:8,
                                child: Container(
                                  child: TextFormField(
                  keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Number',

                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        currentNumber = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: ElevatedButton(
                                    onPressed :(){

                                      setState(() {
                                        if(currentNumber != ""){
                                          Number = currentNumber ;
                                        }
                                        saveNumber(Number);
                                      });
                                    },
                                    child: const Text(
                                      "Add"
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            Number,
                            style: const TextStyle(
                              fontSize: 50,
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 100.0,
                          child: ElevatedButton(

                              onPressed: (){

                          _sendSMS(message1, [Number]);
                          }, child: const Text("Message 1")

                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                          child: ElevatedButton(

                              onPressed: (){
                            _sendSMS(message2, [Number]);
                          }, child: const Text("Message 2")

                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                          child: ElevatedButton(

                              onPressed: (){
                            _sendSMS(message3, [Number]);
                          }, child: const Text("Message 3")

                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),

    );
  }
}