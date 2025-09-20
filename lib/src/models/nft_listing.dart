import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/nft_types.dart';

part 'nft_listing.g.dart';

/// NFT listing on a marketplace
@JsonSerializable()
class NFTListing extends Equatable {
  /// Unique listing ID
  final String id;

  /// NFT token ID
  final String nftId;

  /// Contract address
  final String contractAddress;

  /// Blockchain network
  final BlockchainNetwork network;

  /// Listed price
  final double price;

  /// Currency of the price
  final String currency;

  /// Seller address
  final String sellerAddress;

  /// When the listing was created
  final DateTime createdAt;

  /// When the listing expires
  final DateTime? expiresAt;

  /// Current status of the listing
  final ListingStatus status;

  /// Buyer address (if sold)
  final String? buyerAddress;

  /// When the NFT was sold (if sold)
  final DateTime? soldAt;

  /// Marketplace provider ID
  final String marketplaceProvider;

  /// Additional properties
  final Map<String, dynamic> additionalProperties;

  const NFTListing({
    required this.id,
    required this.nftId,
    required this.contractAddress,
    required this.network,
    required this.price,
    required this.currency,
    required this.sellerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.buyerAddress,
    this.soldAt,
    required this.marketplaceProvider,
    this.additionalProperties = const {},
  });

  /// Create NFTListing from JSON
  factory NFTListing.fromJson(Map<String, dynamic> json) => _$NFTListingFromJson(json);

  /// Convert NFTListing to JSON
  Map<String, dynamic> toJson() => _$NFTListingToJson(this);

  /// Create a copy with updated fields
  NFTListing copyWith({
    String? id,
    String? nftId,
    String? contractAddress,
    BlockchainNetwork? network,
    double? price,
    String? currency,
    String? sellerAddress,
    DateTime? createdAt,
    DateTime? expiresAt,
    ListingStatus? status,
    String? buyerAddress,
    DateTime? soldAt,
    String? marketplaceProvider,
    Map<String, dynamic>? additionalProperties,
  }) {
    return NFTListing(
      id: id ?? this.id,
      nftId: nftId ?? this.nftId,
      contractAddress: contractAddress ?? this.contractAddress,
      network: network ?? this.network,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      soldAt: soldAt ?? this.soldAt,
      marketplaceProvider: marketplaceProvider ?? this.marketplaceProvider,
      additionalProperties: additionalProperties ?? this.additionalProperties,
    );
  }

  /// Check if listing is active
  bool get isActive => status == ListingStatus.active;

  /// Check if listing is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if listing is sold
  bool get isSold => status == ListingStatus.sold;

  /// Get formatted price
  String get formattedPrice => '${price.toStringAsFixed(4)} $currency';

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
        price,
        currency,
        sellerAddress,
        createdAt,
        expiresAt,
        status,
        buyerAddress,
        soldAt,
        marketplaceProvider,
        additionalProperties,
      ];
}
