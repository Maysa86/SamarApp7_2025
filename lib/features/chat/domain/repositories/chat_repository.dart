import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/api_client.dart';
import '../models/conversation_model.dart';
import 'chat_repository_interface.dart';
import '../../enums/user_type_enum.dart';
import '../../../../util/app_constants.dart';

class ChatRepository implements ChatRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future getList(
      {int? offset,
      bool conversationList = false,
      String? type,
      bool searchConversationalList = false,
      String? name}) async {
    if (conversationList) {
      return await _getConversationList(offset!, type!);
    } else if (searchConversationalList) {
      return await _searchConversationList(name!);
    }
  }

  Future<ConversationsModel?> _getConversationList(
      int offset, String type) async {
    ConversationsModel? conversationModel;
    Response response = await apiClient.getData(
        '${AppConstants.conversationListUri}?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      conversationModel = ConversationsModel.fromJson(response.body);
    }
    return conversationModel;
  }

  Future<ConversationsModel?> _searchConversationList(String name) async {
    ConversationsModel? searchConversationModel;
    Response response = await apiClient.getData(
        '${AppConstants.searchConversationListUri}?name=$name&limit=20&offset=1');
    if (response.statusCode == 200) {
      searchConversationModel = ConversationsModel.fromJson(response.body);
    }
    return searchConversationModel;
  }

  @override
  Future<Response> getMessages(
    int offset,
    int? userID,
    String userType,
    int? conversationID,
    int? orderId,
  ) async {
    return await apiClient.getData(
      '${AppConstants.messageListUri}?${conversationID != null ? 'conversation_id' : userType == UserType.admin.name ? 'admin_id' : userType == UserType.vendor.name ? 'vendor_id' : 'delivery_man_id'}=${conversationID ?? userID}&offset=$offset&limit=10${orderId != null ? '&order_id=$orderId' : ''}',
    );
  }

  @override
  Future<Response> sendMessage(
    String message,
    List<MultipartBody> images,
    int? userID,
    String userType,
    int? conversationID,
    int? orderId,
  ) async {
    Map<String, String> fields = {};
    fields.addAll({
      'message': message,
      'receiver_type': userType,
      'offset': '1',
      'limit': '10'
    });
    if (orderId != null) {
      fields.addAll({'order_id': orderId.toString()});
    }
    if (conversationID != null) {
      fields.addAll({'conversation_id': conversationID.toString()});
    } else {
      fields.addAll({'receiver_id': userID.toString()});
    }
    return await apiClient.postMultipartData(
        userType == UserType.admin.name
            ? '/api/v1/customer/message/admin/send'
            : AppConstants.sendMessageUri,
        fields,
        images);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
