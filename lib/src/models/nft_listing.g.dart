// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTListing _$NFTListingFromJson(Map<String, dynamic> json) => NFTListing(
      id: json['id'] as String,
      nftId: json['nftId'] as String,
      contractAddress: json['contractAddress'] as String,
      network: $enumDecode(_$BlockchainNetworkEnumMap, json['network']),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      sellerAddress: json['sellerAddress'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      status: $enumDecode(_$ListingStatusEnumMap, json['status']),
      buyerAddress: json['buyerAddress'] as String?,
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
      marketplaceProvider: json['marketplaceProvider'] as String,
      additionalProperties:
          json['additionalProperties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$NFTListingToJson(NFTListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nftId': instance.nftId,
      'contractAddress': instance.contractAddress,
      'network': _$BlockchainNetworkEnumMap[instance.network]!,
      'price': instance.price,
      'currency': instance.currency,
      'sellerAddress': instance.sellerAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'status': _$ListingStatusEnumMap[instance.status]!,
      'buyerAddress': instance.buyerAddress,
      'soldAt': instance.soldAt?.toIso8601String(),
      'marketplaceProvider': instance.marketplaceProvider,
      'additionalProperties': instance.additionalProperties,
    };

const _$BlockchainNetworkEnumMap = {
  BlockchainNetwork.ethereum: 'ethereum',
  BlockchainNetwork.solana: 'solana',
  BlockchainNetwork.polygon: 'polygon',
  BlockchainNetwork.bsc: 'bsc',
  BlockchainNetwork.avalanche: 'avalanche',
  BlockchainNetwork.icp: 'icp',
  BlockchainNetwork.near: 'near',
  BlockchainNetwork.tron: 'tron',
  BlockchainNetwork.custom: 'custom',
};

const _$ListingStatusEnumMap = {
  ListingStatus.active: 'active',
  ListingStatus.sold: 'sold',
  ListingStatus.cancelled: 'cancelled',
  ListingStatus.expired: 'expired',
};
