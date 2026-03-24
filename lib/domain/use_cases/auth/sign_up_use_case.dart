import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User?> execute(String email, String password) async {
    return await repository.register(email, password);
  }
}