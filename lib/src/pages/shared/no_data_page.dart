import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  String message;
  NoDataPage(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image(context),
          SizedBox(
            height: 20.0,
          ),
          _text(context, message),
/*           _text(context, 'que mostrar'),
 */
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return new Image.asset(
      'assets/images/onbording.png',
      fit: BoxFit.cover,
    );
  }

  Widget _text(BuildContext context, String text) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w400),
      ),
    );
  }
}
