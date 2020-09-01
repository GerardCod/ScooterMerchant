import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class StatusChipWidget extends StatelessWidget {
  final int statusId;
  const StatusChipWidget({Key key, this.statusId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusChip(statusId).create(context);
  }
}

abstract class StatusChip {
  factory StatusChip(int statusId) {
    if (statusId == 3) {
      return ComingToMarketStatusChip();
    } else if (statusId == 4) {
      return RefusedStatusChip();
    } else if (statusId == 6) {
      return DeliveredStatusChip();
    } else if (statusId == 7) {
      return AtMarketStatusChip();
    } else if (statusId == 8) {
      return CanceledStatusChip();
    } else if (statusId == 14) {
      return WaitingOrderStatusChip();
    } else if (statusId == 15) {
      return PreparingOrderStatusChip();
    } else {
      return UndefinedStatusChip();
    }
  }

  Widget create(BuildContext context);
}

class DeliveredStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('Entregado', colorSuccess);
  }
}

class RefusedStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('Rechazado', colorDanger);
  }
}

class CanceledStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('Cancelado', colorDanger);
  }
}

class ComingToMarketStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('En camino al comercio', colorInformation);
  }
}

class AtMarketStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('En el comercio', colorInformation);
  }
}

class PreparingOrderStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('En preparación', colorInformation);
  }
}

class WaitingOrderStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('Recien pedido', colorInformation);
  }
}

class UndefinedStatusChip implements StatusChip {
  @override
  Widget create(BuildContext context) {
    return statusChip('Indefinido', Colors.grey[850]);
  }
}

Widget statusChip(String title, Color color) {
  return Container(
    padding: paddingChips,
    decoration: BoxDecoration(
      borderRadius: radiusChips,
      color: color,
    ),
    child: Text(
      title,
      style: textStyleStatusChip,
    ),
  );
}
