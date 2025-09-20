// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTMetadata _$NFTMetadataFromJson(Map<String, dynamic> json) => NFTMetadata(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      externalUrl: json['externalUrl'] as String?,
      animationUrl: json['animationUrl'] as String?,
      youtubeUrl: json['youtubeUrl'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>,
      properties: json['properties'] as Map<String, dynamic>,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      creator: json['creator'] as Map<String, dynamic>?,
      collection: json['collection'] as Map<String, dynamic>?,
      royalties: json['royalties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NFTMetadataToJson(NFTMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'externalUrl': instance.externalUrl,
      'animationUrl': instance.animationUrl,
      'youtubeUrl': instance.youtubeUrl,
      'backgroundColor': instance.backgroundColor,
      'attributes': instance.attributes,
      'properties': instance.properties,
      'categories': instance.categories,
      'creator': instance.creator,
      'collection': instance.collection,
      'royalties': instance.royalties,
    };
