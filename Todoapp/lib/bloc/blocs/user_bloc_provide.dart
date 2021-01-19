import 'package:Todoapp/bloc/resources/repository.dart';

import '../resources/api.dart';
import 'package:Todoapp/models/classes/user.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();

  Observable<User> get getUser => _userGetter.stream;

  registerUser(String username, String firstname, String lastname,
      String password, String email) async {
    User user = await _repository.registerUser(
        username, firstname, lastname, password, email);
    _userGetter.sink.add(user);
  }

  //signinUser(String username, String password, String apiKey) async {
  //User user = await _repository.signinUser(username, password, apiKey);
  //_userGetter.sink.add(user);
  //}

  dispose() {
    _userGetter.close();
  }
}

final bloc = UserBloc();
