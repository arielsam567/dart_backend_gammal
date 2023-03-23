abstract class RemoteDatabase {
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String query, {
    Map<String, String> variables = const {},
  });
}
