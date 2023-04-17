import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stylish/model/campaign_data.dart';
import 'package:stylish/model/category_data.dart';

@immutable
class HomeBlocState extends Equatable {
  const HomeBlocState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeBlocState {}

class HomeLoaded extends HomeBlocState {
  final List<CampaignData> campaignList;
  final List<CategoryData> categoryList;

  HomeLoaded({
    required this.campaignList,
    required this.categoryList,
  });

  @override
  List<Object> get props => [campaignList, categoryList];
}
