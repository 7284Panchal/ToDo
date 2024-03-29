import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/style.dart';
import 'package:todo_application/message.dart';
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
    injector.map<Style>(
      (i) => StyleImplementation(),
      isSingleton: true,
    );

    //messages
    injector.map<Message>(
      (i) => MessageImplementation(),
      isSingleton: true,
    );

    //preference_helper
    injector.map<PreferenceHelper>(
      (i) => PreferenceHelperImplementation(),
      isSingleton: true,
    );

    //todo_data_service
    injector.map<TodoDataService>(
      (i) => TodoDataServiceImplementation(
            preferenceHelper: i.get<PreferenceHelper>(),
          ),
      isSingleton: true,
    );

    //todo_view_model
    injector.map<TodoViewModel>(
      (i) => TodoViewModelImplementation(
            todoDataService: i.get<TodoDataService>(),
          ),
      isSingleton: true,
    );
  }
}
