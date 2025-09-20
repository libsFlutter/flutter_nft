import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/nft_types.dart';

part 'nft_offer.g.dart';

/// NFT offer on a marketplace
@JsonSerializable()
class NFTOffer extends Equatable {
  /// Unique offer ID
  final String id;

  /// NFT token ID
  final String nftId;

  /// Contract address
  final String contractAddress;

  /// Blockchain network
  final BlockchainNetwork network;

  /// Offer amount
  final double amount;

  /// Currency of the offer
  final String currency;

  /// Buyer address
  final String buyerAddress;

  /// When the offer was created
  final DateTime createdAt;

  /// When the offer expires
  final DateTime? expiresAt;

  /// Current status of the offer
  final OfferStatus status;

  /// When the offer was accepted/rejected (if applicable)
  final DateTime? respondedAt;

  /// Marketplace provider ID
  final String marketplaceProvider;

  /// Additional properties
  final Map<String, dynamic> additionalProperties;

  const NFTOffer({
    required this.id,
    required this.nftId,
    required this.contractAddress,
    required this.network,
    required this.amount,
    required this.currency,
    required this.buyerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.respondedAt,
    required this.marketplaceProvider,
    this.additionalProperties = const {},
  });

  /// Create NFTOffer from JSON
  factory NFTOffer.fromJson(Map<String, dynamic> json) => _$NFTOfferFromJson(json);

  /// Convert NFTOffer to JSON
  Map<String, dynamic> toJson() => _$NFTOfferToJson(this);

  /// Create a copy with updated fields
  NFTOffer copyWith({
    String? id,
    String? nftId,
    String? contractAddress,
    BlockchainNetwork? network,
    double? amount,
    String? currency,
    String? buyerAddress,
    DateTime? createdAt,
    DateTime? expiresAt,
    OfferStatus? status,
    DateTime? respondedAt,
    String? marketplaceProvider,
    Map<String, dynamic>? additionalProperties,
  }) {
    return NFTOffer(
      id: id ?? this.id,
      nftId: nftId ?? this.nftId,
      contractAddress: contractAddress ?? this.contractAddress,
      network: network ?? this.network,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      respondedAt: respondedAt ?? this.respondedAt,
      marketplaceProvider: marketplaceProvider ?? this.marketplaceProvider,
      additionalProperties: additionalProperties ?? this.additionalProperties,
    );
  }

  /// Check if offer is active
  bool get isActive => status == OfferStatus.pending;

  /// Check if offer is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if offer is accepted
  bool get isAccepted => status == OfferStatus.accepted;

  /// Check if offer is rejected
  bool get isRejected => status == OfferStatus.rejected;

  /// Get formatted amount
  String get formattedAmount => '${amount.toStringAsFixed(4)} $currency';

  /// Get time until expiration
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return Duration.zero;
    return expiresAt!.difference(now);
  }

  /// Get formatted time until expiration
  String get formattedTimeUntilExpiration {
    final duration = timeUntilExpiration;
    if (duration == null) return 'No expiration';
    if (duration == Duration.zero) return 'Expired';
    
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  List<Object?> get props => [
        id,
        nftId,
        contractAddress,
        network,
        amount,
        currency,
        buyerAddress,
        createdAt,
        expiresAt,
        status,
        respondedAt,
        marketplaceProvider,
        additionalProperties,
      ];
}
