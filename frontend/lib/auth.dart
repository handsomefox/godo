// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseApi {
  static String base = "http://localhost:8080";
  static String api = base + "/api/v1";
  var authPath = api + "/auth";
  var tasksPath = api + "/task";

  var headers = {
    "Content-Type": "application/json; charset=utf-8",
  };

  Future<http.Response> addTask(Task task, User user) async {
    var encoded = jsonEncode(task.toJson());
    var resp = await http.post(Uri.parse(tasksPath + "/tasks"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + user.token,
        },
        body: encoded);
    return resp;
  }

  Future<void> removeTask(Task task, User user) async {
    if (task.id != null) {
      var str = task.id as String;
      await http.delete(
        Uri.parse(tasksPath + "/tasks/" + str),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + user.token,
        },
      );
      return;
    }
  }
}

class AuthApi extends BaseApi {
  // Returns the result and tokens
  Future<http.Response?> register(
      String name, String email, String password) async {
    var body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      http.Response response = await http.post(
        Uri.parse(super.authPath + "/register"),
        headers: super.headers,
        body: body,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Returns the result and tokens
  Future<http.Response?> login(String email, String password) async {
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      http.Response response = await http.post(
        Uri.parse(super.authPath + "/login"),
        headers: super.headers,
        body: body,
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}

class UserApi extends BaseApi {
  final User user;
  UserApi({required this.user});

  Future<List<Task>> getTasks(BuildContext context) async {
    http.Response response = await http.get(
      Uri.parse(super.tasksPath + "/tasks"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + user.refresh,
        HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      },
    );
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unauthorized)),
      );
      return [];
    }
    var body = jsonDecode(response.body)["tasks"];

    var list = body as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class User {
  String email;
  String name;
  String token;
  String refresh;

  User({
    required this.email,
    required this.name,
    required this.token,
    required this.refresh,
  });

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);
    return User(
      email: json['email'],
      name: json['name'],
      token: json['access_token'],
      refresh: json['refresh_token'],
    );
  }

  Future<List<Task>> getTasks(BuildContext context) async {
    var api = UserApi(user: this);
    return await api.getTasks(context);
  }
}
