import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_metadata.g.dart';

/// Standard NFT metadata following OpenSea and other marketplace standards
@JsonSerializable()
class NFTMetadata extends Equatable {
  /// Name of the NFT
  final String name;

  /// Description of the NFT
  final String description;

  /// URL to the image
  final String image;

  /// URL to the external link
  final String? externalUrl;

  /// Animation URL (for animated NFTs)
  final String? animationUrl;

  /// YouTube video URL
  final String? youtubeUrl;

  /// Background color (hex color)
  final String? backgroundColor;

  /// Attributes/traits of the NFT
  final Map<String, dynamic> attributes;

  /// Properties (additional metadata)
  final Map<String, dynamic> properties;

  /// Categories or tags
  final List<String> categories;

  /// Creator information
  final Map<String, dynamic>? creator;

  /// Collection information
  final Map<String, dynamic>? collection;

  /// Royalties information
  final Map<String, dynamic>? royalties;

  const NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    this.externalUrl,
    this.animationUrl,
    this.youtubeUrl,
    this.backgroundColor,
    required this.attributes,
    required this.properties,
    this.categories = const [],
    this.creator,
    this.collection,
    this.royalties,
  });

  /// Create NFTMetadata from JSON
  factory NFTMetadata.fromJson(Map<String, dynamic> json) => _$NFTMetadataFromJson(json);

  /// Convert NFTMetadata to JSON
  Map<String, dynamic> toJson() => _$NFTMetadataToJson(this);

  /// Create a copy of the metadata with updated fields
  NFTMetadata copyWith({
    String? name,
    String? description,
    String? image,
    String? externalUrl,
    String? animationUrl,
    String? youtubeUrl,
    String? backgroundColor,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? properties,
    List<String>? categories,
    Map<String, dynamic>? creator,
    Map<String, dynamic>? collection,
    Map<String, dynamic>? royalties,
  }) {
    return NFTMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      externalUrl: externalUrl ?? this.externalUrl,
      animationUrl: animationUrl ?? this.animationUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      attributes: attributes ?? this.attributes,
      properties: properties ?? this.properties,
      categories: categories ?? this.categories,
      creator: creator ?? this.creator,
      collection: collection ?? this.collection,
      royalties: royalties ?? this.royalties,
    );
  }

  /// Get attribute value by key
  dynamic getAttribute(String key) => attributes[key];

  /// Get property value by key
  dynamic getProperty(String key) => properties[key];

  /// Check if NFT has animation
  bool get hasAnimation => animationUrl != null && animationUrl!.isNotEmpty;

  /// Check if NFT has external URL
  bool get hasExternalUrl => externalUrl != null && externalUrl!.isNotEmpty;

  /// Get formatted attributes as a list
  List<Map<String, dynamic>> get formattedAttributes {
    return attributes.entries.map((entry) {
      return {
        'trait_type': entry.key,
        'value': entry.value,
      };
    }).toList();
  }

  /// Get rarity score based on attributes
  double get rarityScore {
    double score = 0.0;
    attributes.forEach((key, value) {
      // Simple rarity calculation - can be enhanced
      if (value is num) {
        score += value.toDouble();
      } else if (value is String) {
        score += value.length.toDouble();
      }
    });
    return score;
  }

  @override
  List<Object?> get props => [
        name,
        description,
        image,
        externalUrl,
        animationUrl,
        youtubeUrl,
        backgroundColor,
        attributes,
        properties,
        categories,
        creator,
        collection,
        royalties,
      ];
}
