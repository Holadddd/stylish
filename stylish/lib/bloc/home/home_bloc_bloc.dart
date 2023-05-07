import 'package:bloc/bloc.dart';
import 'home_bloc_state.dart';
import 'home_bloc_event.dart';
import 'package:stylish/model/campaign_data.dart';
import 'package:stylish/model/category_data.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  ApiService apiService = ApiService();

  HomeBlocBloc() : super(HomeInitial()) {
    on<LoadEvent>((event, emit) async {
      final results =
          await Future.wait([apiService.getCampaigns(), apiService.getHots()]);

      final campaignData = results[0] as List<CampaignData>;
      final categoryData = results[1] as List<CategoryData>;

      emit(HomeLoaded(campaignList: campaignData, categoryList: categoryData));
    });
  }
}

// MARK: API
class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Dio _dio = Dio();

  String webUrl = "https://api.appworks-school.tw/api/1.0";

  Future<List<CampaignData>> getCampaigns() async {
    String endpoint = "/marketing/campaigns";
    try {
      Response response = await _dio.get(webUrl + endpoint);
      List<dynamic> data = response.data['data'];
      List<CampaignData> campaigns =
          data.map((json) => CampaignData.fromJson(json)).toList();
      return campaigns;
    } catch (e) {
      throw e;
    }
  }

  Future<List<CategoryData>> getHots() async {
    String endpoint = "/marketing/hots";
    try {
      Response response = await _dio.get(webUrl + endpoint);
      List<dynamic> data = response.data['data'];
      List<CategoryData> categoryList =
          data.map((json) => CategoryData.fromJson(json)).toList();
      return categoryList;
    } catch (e) {
      throw e;
    }
  }
}
