import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class StatusChipFactory extends StatelessWidget {
  final int statusId;
  const StatusChipFactory({Key key, this.statusId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this._createChip(this.statusId).create(context);
  }

  StatusChip _createChip(int statusId) {
    StatusChip chip;
    if (statusId == 5) {
      chip = DeliveredStatusChip();
    } else if (statusId == 15) {
      chip = InProcessStatusChip();
    } else if (statusId == 16) {
      chip = RefusedStatusChip();
    } else {
      chip = NormalStatusChip();
    }
    return chip;
  }
}

abstract class StatusChip {
  Widget create(BuildContext context);
}

class DeliveredStatusChip extends StatusChip {
  @override
  Widget create(BuildContext context) {
    return Container(
      padding: paddingChips,
      decoration: BoxDecoration(borderRadius: radiusChips, color: colorSuccess),
      child: Text(
        'Aceptado',
        style: textStyleStatusChip,
      ),
    );
  }
}

class InProcessStatusChip extends StatusChip {
  @override
  Widget create(BuildContext context) {
    return Container(
      padding: paddingChips,
      decoration:
          BoxDecoration(borderRadius: radiusChips, color: colorInformation),
      child: Text(
        'En proceso',
        style: textStyleStatusChip,
      ),
    );
  }
}

class RefusedStatusChip extends StatusChip {
  @override
  Widget create(BuildContext context) {
    return Container(
      padding: paddingChips,
      decoration:
          BoxDecoration(borderRadius: radiusChips, color: colorInformation),
      child: Text(
        'Rechazado',
        style: textStyleStatusChip,
      ),
    );
  }
}

class NormalStatusChip extends StatusChip {
  @override
  Widget create(BuildContext context) {
    return Container(
      padding: paddingChips,
      decoration:
          BoxDecoration(borderRadius: radiusChips, color: Colors.grey[850]),
      child: Text(
        'Normal',
        style: textStyleStatusChip,
      ),
    );
  }
}
