part of 'db_bloc.dart';

class DbState {}

class DBInitialStatusState extends DbState {}

class DBConnectedState extends DbState {}

class DBErrorState extends DbState {
  final String message;
  DBErrorState(this.message);
}
