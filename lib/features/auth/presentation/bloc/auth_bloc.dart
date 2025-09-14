import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);

    // Check auth status when bloc is created
    add(AuthStatusChecked());
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      // Even if logout fails, we should consider user as unauthenticated
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = checkAuthStatusUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase(event.email);
      emit(PasswordResetSent(email: event.email));
      // After sending reset email, go back to unauthenticated state
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }
}
