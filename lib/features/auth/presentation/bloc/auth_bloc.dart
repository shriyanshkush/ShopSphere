import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;


  AuthBloc(this.repo) : super(AuthInitial()) {
    on<AppStarted>((_, emit) async {
      final loggedIn = await repo.isLoggedIn();
      emit(loggedIn ? AuthAuthenticated() : AuthUnauthenticated());
    });


    on<LoginRequested>((e, emit) async {
      emit(AuthLoading());
      try {
        await repo.login(e.email, e.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError('Login failed'));
      }
    });


    on<SignupRequested>((e, emit) async {
      emit(AuthLoading());
      try {
        await repo.signup(e.name, e.email, e.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError('Signup failed'));
      }
    });
  }
}