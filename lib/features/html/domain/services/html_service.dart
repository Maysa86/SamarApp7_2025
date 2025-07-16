import 'package:get/get.dart';
import '../repositories/html_repository_interface.dart';
import 'html_service_interface.dart';
import '../../../../util/html_type.dart';

class HtmlService implements HtmlServiceInterface {
  final HtmlRepositoryInterface htmlRepositoryInterface;
  HtmlService({required this.htmlRepositoryInterface});

  @override
  Future<Response> getHtmlText(HtmlType htmlType) async {
    return await htmlRepositoryInterface.getHtmlText(htmlType);
  }

}