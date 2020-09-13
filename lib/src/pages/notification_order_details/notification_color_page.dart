import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';

class NotificationColorPage extends StatefulWidget {
  // const NotificationColorPage({Key key}) : super(key: key);

  @override
  _NotificationColorPageState createState() => _NotificationColorPageState();
}

class _NotificationColorPageState extends State<NotificationColorPage> {
  AudioPlayer audioPlugin = AudioPlayer();

  Future<Null> _load() async {
    final ByteData data = await rootBundle.load('assets/sounds/ringtone.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/ringtone.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.uri.toString();
    // print('finished loading, uri=$mp3Uri');
    _playSound();
  }

  void _playSound() {
    if (mp3Uri != null) {
      audioPlugin.play(mp3Uri, isLocal: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    audioPlugin.stop();
    // channel.sink.close();
    super.dispose();
  }

  String mp3Uri;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: InkWell(
        onTap: () {
          audioPlugin.stop();
          // audioPlugin.dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        child: Container(
          width: size.width,
          height: size.height,
          color: primaryColor,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/orden.png',
                height: 200,
              ),
              SizedBox(height: 30),
              Text(
                'Pedido Nuevo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Text(
                  'Toca cualquier parte de la pantalla para ver el pedido.',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
