import 'package:biblio/main.dart';

import 'package:biblio/screens/home/resources.dart';
import 'package:biblio/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MainPage extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<MainPage> {
  TextEditingController number = TextEditingController();
  TextEditingController usermessage = TextEditingController();
//Your code here

  final AuthService _auth = AuthService();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('HersAlert'),
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (newIndex) {
            setState(() => _index = newIndex);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Resouces()));
          },
          currentIndex: _index,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.green,
          selectedItemColor: Colors.yellow,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            //   BottomNavigationBarItem(
            //   icon: new Icon(Icons.contacts),
            // title: new Text('Contacts'),
            //),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), title: Text('Resources')),
          ],
        ),
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Column(children: <Widget>[
              ClipOval(
                child: Material(
                  color: Colors.red, // button color
                  child: InkWell(
                    splashColor: Colors.blue, // inkwell color
                    child: SizedBox(
                        width: 56, height: 56, child: Icon(Icons.menu)),
                    onTap: () {
                      sendSMS();

                      _makePhoneCall(true);
                    },
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Change Number'),
                onPressed: () {
                  createAlertDialognumber(context);
                },
              ),
              RaisedButton(
                child: Text('Change Message'),
                onPressed: () {
                  createAlertDialogmessage(context);
                },
              ),
            ])),
      ),
    );
  }

  createAlertDialognumber(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change Number"),
            content: TextField(
              controller: number,
              decoration: InputDecoration(hintText: "Enter Number"),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  createAlertDialogmessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change Message"),
            content: TextField(
              controller: usermessage,
              decoration: InputDecoration(hintText: "Enter Message"),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  sendSMS() {
    print("IN SMS METHOD");

    SmsSender sender = new SmsSender();
    String address = number.text; //number.value.toString();
    String messagedata = usermessage.text;

    SmsMessage message = new SmsMessage(address, messagedata);

    sender.sendSms(message);

    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
  }

  Future<void> _makePhoneCall(bool direct) async {
    String contact = number.text;
    if (direct == true) {
      bool res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = number.text; //'tel:$contact';
      if (await UrlLauncher.canLaunch(telScheme)) {
        await UrlLauncher.launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }
}
