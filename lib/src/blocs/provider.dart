import 'package:flutter/widgets.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/pages/notification_order_details_page_bloc.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';

class Provider extends InheritedWidget {
  final _loginBloc = LoginBloc();
  final _orderBlocProvider = OrderBlocProvider();
  final _notificationOrderDetailsPageBloc =
      new NotificationOrderDetailsPageBloc();
  final _productBlocProvider = ProductBlocProvider();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static OrderBlocProvider orderBlocProviderOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._orderBlocProvider;
  }

  static NotificationOrderDetailsPageBloc notificationOrderDetailsPageBloc(
      BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._notificationOrderDetailsPageBloc;
  }

  static ProductBlocProvider productBlocProviderOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._productBlocProvider;
  }
}
