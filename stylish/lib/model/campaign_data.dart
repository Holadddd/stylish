class CampaignData {
  final int id;
  final int productId;
  final String picture;
  final String story;

  CampaignData({
    required this.id,
    required this.productId,
    required this.picture,
    required this.story,
  });

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      id: json['id'],
      productId: json['product_id'],
      picture: json['picture'],
      story: json['story'],
    );
  }
}
