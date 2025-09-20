// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTTransaction _$NFTTransactionFromJson(Map<String, dynamic> json) =>
    NFTTransaction(
      id: json['id'] as String,
      network: $enumDecode(_$BlockchainNetworkEnumMap, json['network']),
      type: json['type'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      fee: (json['fee'] as num).toDouble(),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      blockNumber: (json['blockNumber'] as num?)?.toInt(),
      gasUsed: (json['gasUsed'] as num?)?.toInt(),
      gasPrice: (json['gasPrice'] as num?)?.toDouble(),
      data: json['data'] as Map<String, dynamic>? ?? const {},
      tokenId: json['tokenId'] as String?,
      contractAddress: json['contractAddress'] as String?,
    );

Map<String, dynamic> _$NFTTransactionToJson(NFTTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'network': _$BlockchainNetworkEnumMap[instance.network]!,
      'type': instance.type,
      'from': instance.from,
      'to': instance.to,
      'amount': instance.amount,
      'currency': instance.currency,
      'fee': instance.fee,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'blockNumber': instance.blockNumber,
      'gasUsed': instance.gasUsed,
      'gasPrice': instance.gasPrice,
      'data': instance.data,
      'tokenId': instance.tokenId,
      'contractAddress': instance.contractAddress,
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

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.confirmed: 'confirmed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
};
