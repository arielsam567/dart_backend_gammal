abstract class BcryptService {
  String gerenateHash(String text);
  bool checkHash(String text, String hash);
}
