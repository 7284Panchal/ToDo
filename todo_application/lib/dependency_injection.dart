import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/style.dart';
import 'package:todo_application/views/message.dart';
import 'package:todo_application/data/preference_helper.dart';
import 'package:todo_application/data_service/todo_data_service.dart';
import 'package:todo_application/view_models/todo_view_model.dart';

class DependencyInjection {
  static final DependencyInjection _dependencyInjection =
      DependencyInjection._internal();

  factory DependencyInjection() {
    return _dependencyInjection;
  }

  DependencyInjection._internal();

  void configureDependency() {
    Injector injector = Injector.getInjector();

    //style
    injector.map<IStyle>(
      (i) => Style(),
      isSingleton: true,
    );

    //messages
    injector.map<IMessage>(
      (i) => Message(),
      isSingleton: true,
    );

    //preference_helper
    injector.map<IPreferenceHelper>(
      (i) => PreferenceHelper(),
      isSingleton: true,
    );

    //todo_data_service
    injector.map<ITodoDataService>(
      (i) => TodoDataService(
            iPreferenceHelper: i.get<IPreferenceHelper>(),
          ),
      isSingleton: true,
    );

    //todo_view_model
    injector.map<ITodoViewModel>(
      (i) => TodoViewModel(
            todoDataService: i.get<ITodoDataService>(),
          ),
      isSingleton: true,
    );
  }
}
