import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api/api_client.dart';
import '../models/conversation_model.dart';
import '../repositories/chat_repository_interface.dart';
import 'chat_service_interface.dart';
import '../../enums/user_type_enum.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(int offset, String type) async {
    return await chatRepositoryInterface.getList(
        offset: offset, conversationList: true, type: type);
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.getList(
        searchConversationalList: true, name: name);
  }

  @override
  Future<Response> getMessages(
      int offset,
      int? userID,
      String userType,
      int? conversationID,
      int? orderId,
      ) async {
    return await chatRepositoryInterface.getMessages(
      offset,
      userID,
      userType,
      conversationID,
      orderId,
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
    return await chatRepositoryInterface.sendMessage(
      message,
      images,
      userID,
      userType,
      conversationID,
      orderId,
    );
  }

  @override
  int setIndex(List<Conversation?>? conversations) {
    int index0 = -1;
    for (int index = 0; index < conversations!.length; index++) {
      if (conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  bool checkSender(List<Conversation?>? conversations) {
    bool sender = false;
    for (int index = 0; index < conversations!.length; index++) {
      if (conversations[index]!.receiverType == UserType.admin.name) {
        sender = false;
        break;
      }
    }
    return sender;
  }

  @override
  int findOutConversationUnreadIndex(
      List<Conversation?>? conversations, int? conversationID) {
    int index0 = -1;
    for (int index = 0; index < conversations!.length; index++) {
      if (conversationID == conversations[index]!.id) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  Future<XFile> compressImage(XFile file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) {
      throw Exception('Image compression failed');
    }

    return XFile(compressedFile.path);
  }

  @override
  List<MultipartBody> processMultipartBody(List<XFile> chatImage) {
    List<MultipartBody> multipartImages = [];
    for (var image in chatImage) {
      multipartImages.add(MultipartBody('image[]', image));
    }
    return multipartImages;
  }
}
