abstract class BcryptService {
  String generateHash(String text);
  bool checkHash(String text, String hash);
}
