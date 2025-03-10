import 'package:firfir_tera/Domain/Repository%20Interface/authRepository.dart';
import 'package:firfir_tera/application/bloc/auth/auth_bloc.dart';
import 'package:firfir_tera/application/bloc/auth/auth_even.dart';
import 'package:firfir_tera/application/bloc/formStutes/form_submistion_status.dart';
import 'package:firfir_tera/application/bloc/login/login_event.dart';
import 'package:firfir_tera/application/bloc/login/login_state.dart';
import 'package:firfir_tera/infrastructure/services/authService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthBloc authBloc;

  LoginBloc({required this.authRepo, required this.authBloc})
      : super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(
          username: event.username, formStatus: const InitialFormStatus()));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(
          password: event.password, formStatus: const InitialFormStatus()));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final String? token =
            await authRepo.login(state.username, state.password);
        final String? userId = await authRepo.getUserId();
        final String? role = await authRepo.getRole();

        if (token != null) {
          emit(state.copyWith(formStatus: SubmissionSuccess()));
          authBloc.add(LoggedIn(token, userId!, role!));
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(Exception('Failed to login'))));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    });
  }
}
