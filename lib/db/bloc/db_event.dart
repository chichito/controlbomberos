part of 'db_bloc.dart';

sealed class DbEvent {}

class DBInitialStatusEvent extends DbEvent {}

class DBShutdownEvent extends DbEvent {}
