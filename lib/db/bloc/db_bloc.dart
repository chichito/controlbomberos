import 'dart:async';

import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'db_event.dart';
part 'db_state.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DbState()) {
    on<DBInitialStatusEvent>(_onDBInitialStatusEvent);
    on<DBShutdownEvent>(_onDBShutdownEvent);
  }

  Future<void> _onDBInitialStatusEvent(
    DBInitialStatusEvent event,
    Emitter<DbState> emit,
  ) async {
    try {
      emit(DBInitialStatusState());
      await SQLiteHelper().initDB();
      await SQLiteHelper().insertInitialData();
      emit(DBConnectedState());
    } catch (e) {
      emit(DBErrorState(e.toString()));
    }
  }

  FutureOr<void> _onDBShutdownEvent(
    DBShutdownEvent event,
    Emitter<DbState> emit,
  ) {
    emit(DBErrorState('Database shutdown'));
  }
}
