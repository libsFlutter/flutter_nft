import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'nft_metadata.dart';
import '../core/nft_types.dart';

part 'nft.g.dart';

/// Universal NFT model that works across different blockchains
@JsonSerializable()
class NFT extends Equatable {
  /// Unique identifier of the NFT
  final String id;

  /// Token ID on the blockchain
  final String tokenId;

  /// Contract address or canister ID
  final String contractAddress;

  /// Blockchain network this NFT belongs to
  final BlockchainNetwork network;

  /// NFT metadata
  final NFTMetadata metadata;

  /// Current owner address
  final String owner;

  /// Creator address
  final String creator;

  /// When the NFT was created
  final DateTime createdAt;

  /// When the NFT was last updated
  final DateTime updatedAt;

  /// Current status of the NFT
  final String status;

  /// Current market value (if available)
  final double? currentValue;

  /// Currency of the current value
  final String? valueCurrency;

  /// Transaction history
  final List<String> transactionHistory;

  /// Additional properties specific to the blockchain
  final Map<String, dynamic> additionalProperties;

  const NFT({
    required this.id,
    required this.tokenId,
    required this.contractAddress,
    required this.network,
    required this.metadata,
    required this.owner,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.currentValue,
    this.valueCurrency,
    required this.transactionHistory,
    this.additionalProperties = const {},
  });

  /// Create NFT from JSON
  factory NFT.fromJson(Map<String, dynamic> json) => _$NFTFromJson(json);

  /// Convert NFT to JSON
  Map<String, dynamic> toJson() => _$NFTToJson(this);

  /// Create a copy of the NFT with updated fields
  NFT copyWith({
    String? id,
    String? tokenId,
    String? contractAddress,
    BlockchainNetwork? network,
    NFTMetadata? metadata,
    String? owner,
    String? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    double? currentValue,
    String? valueCurrency,
    List<String>? transactionHistory,
    Map<String, dynamic>? additionalProperties,
  }) {
    return NFT(
      id: id ?? this.id,
      tokenId: tokenId ?? this.tokenId,
      contractAddress: contractAddress ?? this.contractAddress,
      network: network ?? this.network,
      metadata: metadata ?? this.metadata,
      owner: owner ?? this.owner,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      currentValue: currentValue ?? this.currentValue,
      valueCurrency: valueCurrency ?? this.valueCurrency,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      additionalProperties: additionalProperties ?? this.additionalProperties,
    );
  }

  /// Check if NFT is owned by the given address
  bool isOwnedBy(String address) => owner.toLowerCase() == address.toLowerCase();

  /// Check if NFT is created by the given address
  bool isCreatedBy(String address) => creator.toLowerCase() == address.toLowerCase();

  /// Get the rarity of the NFT based on metadata
  NFTRarity get rarity {
    final rarityStr = metadata.attributes['Rarity']?.toString().toLowerCase();
    switch (rarityStr) {
      case 'common':
        return NFTRarity.common;
      case 'uncommon':
        return NFTRarity.uncommon;
      case 'rare':
        return NFTRarity.rare;
      case 'epic':
        return NFTRarity.epic;
      case 'legendary':
        return NFTRarity.legendary;
      case 'mythic':
        return NFTRarity.mythic;
      default:
        return NFTRarity.common;
    }
  }

  /// Get formatted current value
  String get formattedValue {
    if (currentValue == null || valueCurrency == null) return 'N/A';
    return '${currentValue!.toStringAsFixed(4)} $valueCurrency';
  }

  @override
  List<Object?> get props => [
        id,
        tokenId,
        contractAddress,
        network,
        metadata,
        owner,
        creator,
        createdAt,
        updatedAt,
        status,
        currentValue,
        valueCurrency,
        transactionHistory,
        additionalProperties,
      ];
}
