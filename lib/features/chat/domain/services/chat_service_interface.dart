import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../api/api_client.dart';
import '../models/conversation_model.dart';

abstract class ChatServiceInterface {
  Future<ConversationsModel?> getConversationList(int offset, String type);
  Future<ConversationsModel?> searchConversationList(String name);
  Future<Response> getMessages(
      int offset,
      int? userID,
      String userType,
      int? conversationID,
      int? orderId,
      );
  Future<Response> sendMessage(
      String message,
      List<MultipartBody> images,
      int? userID,
      String userType,
      int? conversationID,
      int? orderId,
      );
  int setIndex(List<Conversation?>? conversations);
  bool checkSender(List<Conversation?>? conversations);
  int findOutConversationUnreadIndex(
      List<Conversation?>? conversations, int? conversationID);
  Future<XFile> compressImage(XFile file);
  List<MultipartBody> processMultipartBody(List<XFile> chatImage);
}
