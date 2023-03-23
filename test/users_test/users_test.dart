import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  final String path = 'http://localhost:4466';
  final Faker faker = Faker();

  test('GET ALL USERS', () async {
    final resposeAllUsers = await dio.get('$path/user');
    expect(resposeAllUsers.statusCode, 200);
    expect(resposeAllUsers.data, isNotEmpty);
  });

  test('ADD USER', () async {
    final user = {
      'email': faker.internet.email(),
      'password': faker.internet.password(),
      'name': faker.person.name(),
    };
    final resposeAllUsers = await dio.post('$path/user', data: user);
    expect(resposeAllUsers.statusCode, 201);
    expect(resposeAllUsers.data, isNotEmpty);
  });

  test('GET USER BY ID', () async {
    final resposeAllUsers = await dio.get('$path/user/2');
    expect(resposeAllUsers.statusCode, 200);
    expect(resposeAllUsers.data, isNotEmpty);
  });

  test('UPDATE USER', () async {
    final user = {
      'id': 2,
      'email': faker.internet.email(),
      'password': faker.internet.password(),
      'name': faker.person.name(),
    };
    final resposeAllUsers = await dio.put('$path/user', data: user);

    expect(resposeAllUsers.data, isNotEmpty);
  });

  test('DELETE USER BY ID', () async {
    final resposeAllUsers = await dio.delete('$path/user/1');
    expect(resposeAllUsers.data, 'DELETE USER BY ID {id: 1}');
  });
}
