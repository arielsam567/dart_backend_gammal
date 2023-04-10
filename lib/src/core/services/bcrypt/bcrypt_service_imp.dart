import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:bcrypt/bcrypt.dart';

class BCryptServiceImp implements BcryptService {
  @override
  bool checkHash(String text, String hash) {
    final bool checkPassword = BCrypt.checkpw(text, hash);
    return checkPassword;
  }

  @override
  String generateHash(String text) {
    final String hashed = BCrypt.hashpw(text, BCrypt.gensalt());
    return hashed;
  }
}
