import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Server extends StatefulWidget {
  @override
  _ServerState createState() => _ServerState();
}

// class Token {
//   final String channel;

//   Token({this.channel});

//   factory Token.fromJson(Map<String, dynamic> json) {
//     return Token(channel: json['channel']);
//   }
// }

var Token = '';

class _ServerState extends State<Server> {
  Map data;
  List UsersData;
  Map token;

  var channel = '';
  var startTime = '';
  var endTime = '';
  var meetingDate = '';
  final channelController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  // getUsers() async {
  //   http.Response response = await http.get('http://10.0.2.2:4000/api/users');
  //   data = json.decode(response.body);
  //   setState(() {
  //     UsersData = data['users'];
  //   });
  // }

  Map<String, String> headers = {'content-type': 'application/json'};
  void getToken(String cname, String eTime, String mDate) async {
    http.Response response = await http.post('http://10.0.2.2:3000/rtcToken',
        headers: headers,
        body: '{"channel":"${cname}","eTime":"${eTime}","mDate":"${mDate}"}');
    token = json.decode(response.body);

    setState(() {
      Token = token['token'];
    });
    print(Token);
    // print(token['expireTimeMinute']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return IndexPage();
                  }))
                },
            child: Icon(Icons.arrow_forward_ios)),
        title: Text('Make a Meeting'),
        backgroundColor: Colors.indigo[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                trailing: FlatButton(
                    color: Colors.lightBlue,
                    onPressed: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return IndexPage();
                          }))
                        },
                    child: Text(
                      'Join Meeting',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 300.0,
                decoration: BoxDecoration(color: Colors.amber),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _fromKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter unique meeting name'),
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'channel name must be enter';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              channel = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter meeting date MM DD YYYY'),
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Date must be enter here';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              meetingDate = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter Start Time Here HH:MM'),
                            onSaved: (String value) {
                              startTime = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter End Time Here HH:MM'),
                            onSaved: (String value) {
                              endTime = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FlatButton(
                              color: Colors.blueGrey,
                              onPressed: () {
                                if (_fromKey.currentState.validate()) {
                                  _fromKey.currentState.save();
                                  print(channel);
                                  getToken(channel, endTime, meetingDate);
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ))
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: Center(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: TextField(
      //             controller: channelController,
      //           ),
      //         ),
      //         FlatButton(
      //             color: Colors.amber,
      //             onPressed: () => {
      //                   getToken(channelController.text),
      //                   print(channelController.text)
      //                 },
      //             child: Text('Save')),
      //       ],
      //     ),
      //   ),
      // )
      // body: ListView.builder(
      //     itemCount: UsersData == null ? 0 : UsersData.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Card(
      //         child: Row(
      //           children: [
      //             CircleAvatar(
      //               backgroundImage: NetworkImage(UsersData[index]['avatar']),
      //             )
      //           ],
      //         ),
      //       );
      //     }));
    );
  }
}
