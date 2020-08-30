import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class StatusChipFactory extends StatelessWidget {
  final String status;
  const StatusChipFactory({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _showChip(status);
  }

  Widget _showChip(String status) {
    // StatusChip chip;
    if (status == 'Rechazado') {
      return _createChip(status, Colors.red);
    }
    if (status == 'Cancelado') {
      return _createChip(status, Colors.red);
    }
    return _createChip(status, Colors.green);
  }

  Widget _createChip(String text, Color color) {
    return Container(
      padding: paddingChips,
      decoration: BoxDecoration(borderRadius: radiusChips, color: color),
      child: Text(
        text,
        style: textStyleStatusChip,
      ),
    );
  }
}
