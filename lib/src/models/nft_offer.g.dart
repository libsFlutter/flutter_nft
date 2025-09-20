// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTOffer _$NFTOfferFromJson(Map<String, dynamic> json) => NFTOffer(
      id: json['id'] as String,
      nftId: json['nftId'] as String,
      contractAddress: json['contractAddress'] as String,
      network: $enumDecode(_$BlockchainNetworkEnumMap, json['network']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      buyerAddress: json['buyerAddress'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      status: $enumDecode(_$OfferStatusEnumMap, json['status']),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      marketplaceProvider: json['marketplaceProvider'] as String,
      additionalProperties:
          json['additionalProperties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$NFTOfferToJson(NFTOffer instance) => <String, dynamic>{
      'id': instance.id,
      'nftId': instance.nftId,
      'contractAddress': instance.contractAddress,
      'network': _$BlockchainNetworkEnumMap[instance.network]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'buyerAddress': instance.buyerAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'status': _$OfferStatusEnumMap[instance.status]!,
      'respondedAt': instance.respondedAt?.toIso8601String(),
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

const _$OfferStatusEnumMap = {
  OfferStatus.pending: 'pending',
  OfferStatus.accepted: 'accepted',
  OfferStatus.rejected: 'rejected',
  OfferStatus.expired: 'expired',
  OfferStatus.cancelled: 'cancelled',
};
