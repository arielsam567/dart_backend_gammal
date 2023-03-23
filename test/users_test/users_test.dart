import 'package:test/test.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  final String path = 'http://localhost:4466';

  test('GET ALL USERS', () async {
    final resposeAllUsers = await dio.get('$path/user');
    expect(resposeAllUsers.data, 'GET ALL USER');
  });

  test('ADD USER', () async {
    final resposeAllUsers = await dio.post('$path/user');
    expect(resposeAllUsers.data, 'ADD USER');
  });

  test('GET USER BY ID', () async {
    final resposeAllUsers = await dio.get('$path/user/1');
    expect(resposeAllUsers.data, 'GET USER BY ID {id: 1}');
  });

  test('UPDATE USER', () async {
    final resposeAllUsers = await dio.put('$path/user');
    expect(resposeAllUsers.data, 'UPDATE USER');
  });

  test('DELETE USER BY ID', () async {
    final resposeAllUsers = await dio.delete('$path/user/1');
    expect(resposeAllUsers.data, 'DELETE USER BY ID {id: 1}');
  });
}
