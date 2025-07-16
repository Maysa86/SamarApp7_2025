import '../../../../interfaces/repository_interface.dart';
import '../models/popular_categories_model.dart';
import '../models/search_suggestion_model.dart';

abstract class SearchRepositoryInterface extends RepositoryInterface {
  Future<bool> saveSearchHistory(List<String> searchHistories);
  List<String> getSearchAddress();
  Future<bool> clearSearchHistory();
  @override
  Future getList(
      {int? offset,
      String? query,
      bool? isStore,
      bool isSuggestedItems = false});
  Future<SearchSuggestionModel?> getSearchSuggestions(String searchText);
  Future<List<PopularCategoryModel?>?> getPopularCategories();
}
