import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.signInWithGoogle();
  }
}