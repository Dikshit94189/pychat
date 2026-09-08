import 'package:chatypy/models/conversation_model.dart';
import 'package:chatypy/models/token_model.dart';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../models/message_model.dart';
import '../models/user_models.dart';

class ApiService{
  late final Dio dio;

  ApiService(){
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Accept': 'application/json',
        },
      )
    );
  }


  // =========================  LOGIN  =========================
  Future<TokenModel> login(String email , String password) async{
    final response = await dio.post('/users/login',data: FormData.fromMap({
      'username': email,
      'password': password,
    }),);
    return TokenModel.fromJson(response.data);
  }

// =========================  GET CURRENT USER =========================

  Future<UserModel> getCurrentUser(
      String token,
      ) async {
    final response = await dio.get(
      '/users/me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return UserModel.fromJson(response.data);
  }

  Future<ConversationModel> createConversation(String token , int receiverId) async {
    final response = await dio.post(
      '/conversations/',
      data: {
        'receiver_id': receiverId,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return ConversationModel.fromJson(response.data);
  }

// =========================  SEND MESSAGE =========================

  Future<MessageModel> sendMessage(
      String token,
      int conversationId,
      String message,
      ) async {
    final response = await dio.post(
      '/messages/',
      data: {
        'conversation_id': conversationId,
        'message': message,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return MessageModel.fromJson(response.data);
  }

  // =========================  GET MESSAGES  =========================

  Future<List<MessageModel>> getMessages(
      String token,
      int conversationId,
      ) async {
    final response = await dio.get(
      '/messages/$conversationId',
      options: Options(
        headers: {'Authorization': 'Bearer $token',},
      ),
    );
    final List data = response.data;
    return data.map((json) => MessageModel.fromJson(json),).toList();
  }

}