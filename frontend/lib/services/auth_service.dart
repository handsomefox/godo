// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class BaseApiService {
  static const String _base = 'http://localhost:8080';
  static const String _api = '$_base/api/v1';
  final String _authPath = '$_api/auth';
  final String _tasksPath = '$_api/task';

  final Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Future<http.Response> insertTask(Task task, User user) async {
    String encodedTask = jsonEncode(task.toJson());
    http.Response response = await http.post(Uri.parse('$_tasksPath/tasks'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${user.accessToken}'
        },
        body: encodedTask);
    return response;
  }

  Future<void> removeTask(Task task, User user) async {
    if (task.id != null) {
      String str = task.id as String;
      await http.delete(
        Uri.parse('$_tasksPath/tasks/$str'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${user.accessToken}',
        },
      );
      return;
    }
  }
}

class AuthApiService extends BaseApiService {
  // Returns the result and tokens
  Future<http.Response?> register(
      String name, String email, String password) async {
    String encodedRegisterBody = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      http.Response response = await http.post(
        Uri.parse('${super._authPath}/register'),
        headers: super._headers,
        body: encodedRegisterBody,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Returns the result and tokens
  Future<http.Response?> login(String email, String password) async {
    String encodedLoginBody = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      http.Response response = await http.post(
        Uri.parse('${super._authPath}/login'),
        headers: super._headers,
        body: encodedLoginBody,
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}

class UserApiService extends BaseApiService {
  UserApiService({required this.user});

  final User user;

  Future<List<Task>> fetchTasks(BuildContext context) async {
    http.Response response = await http.get(
      Uri.parse('${super._tasksPath}/tasks'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${user.refreshToken}',
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unauthorized)),
      );
      return [];
    }
    var tasksBody = jsonDecode(response.body)['tasks'];

    List<dynamic> tasksList = tasksBody as List<dynamic>;
    return tasksList
        .map((var e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class User {
  User({
    required this.email,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromRequestBody(String body) {
    Map<String, dynamic> decodedBody = jsonDecode(body) as Map<String, dynamic>;
    return User(
      email: decodedBody['email'] as String,
      name: decodedBody['name'] as String,
      accessToken: decodedBody['access_token'] as String,
      refreshToken: decodedBody['refresh_token'] as String,
    );
  }

  String email;
  String name;
  String accessToken;
  String refreshToken;

  Future<List<Task>> fetchTasks(BuildContext context) async {
    UserApiService api = UserApiService(user: this);
    return api.fetchTasks(context);
  }
}
