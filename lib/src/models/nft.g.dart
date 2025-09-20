// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFT _$NFTFromJson(Map<String, dynamic> json) => NFT(
      id: json['id'] as String,
      tokenId: json['tokenId'] as String,
      contractAddress: json['contractAddress'] as String,
      network: $enumDecode(_$BlockchainNetworkEnumMap, json['network']),
      metadata: NFTMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      owner: json['owner'] as String,
      creator: json['creator'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as String,
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      valueCurrency: json['valueCurrency'] as String?,
      transactionHistory: (json['transactionHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      additionalProperties:
          json['additionalProperties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$NFTToJson(NFT instance) => <String, dynamic>{
      'id': instance.id,
      'tokenId': instance.tokenId,
      'contractAddress': instance.contractAddress,
      'network': _$BlockchainNetworkEnumMap[instance.network]!,
      'metadata': instance.metadata,
      'owner': instance.owner,
      'creator': instance.creator,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'currentValue': instance.currentValue,
      'valueCurrency': instance.valueCurrency,
      'transactionHistory': instance.transactionHistory,
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
