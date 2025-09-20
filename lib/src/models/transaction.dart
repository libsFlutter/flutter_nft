import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/nft_types.dart';

part 'transaction.g.dart';

/// Blockchain transaction model
@JsonSerializable()
class NFTTransaction extends Equatable {
  /// Transaction hash/ID
  final String id;

  /// Blockchain network
  final BlockchainNetwork network;

  /// Transaction type
  final String type;

  /// From address
  final String from;

  /// To address
  final String to;

  /// Transaction amount
  final double amount;

  /// Currency
  final String currency;

  /// Transaction fee
  final double fee;

  /// Transaction status
  final TransactionStatus status;

  /// When the transaction was created
  final DateTime createdAt;

  /// When the transaction was confirmed
  final DateTime? confirmedAt;

  /// Block number (if confirmed)
  final int? blockNumber;

  /// Gas used (for Ethereum-like networks)
  final int? gasUsed;

  /// Gas price (for Ethereum-like networks)
  final double? gasPrice;

  /// Additional transaction data
  final Map<String, dynamic> data;

  /// Related NFT token ID (if applicable)
  final String? tokenId;

  /// Related contract address (if applicable)
  final String? contractAddress;

  const NFTTransaction({
    required this.id,
    required this.network,
    required this.type,
    required this.from,
    required this.to,
    required this.amount,
    required this.currency,
    required this.fee,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.blockNumber,
    this.gasUsed,
    this.gasPrice,
    this.data = const {},
    this.tokenId,
    this.contractAddress,
  });

  /// Create NFTTransaction from JSON
  factory NFTTransaction.fromJson(Map<String, dynamic> json) => _$NFTTransactionFromJson(json);

  /// Convert NFTTransaction to JSON
  Map<String, dynamic> toJson() => _$NFTTransactionToJson(this);

  /// Create a copy with updated fields
  NFTTransaction copyWith({
    String? id,
    BlockchainNetwork? network,
    String? type,
    String? from,
    String? to,
    double? amount,
    String? currency,
    double? fee,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    int? blockNumber,
    int? gasUsed,
    double? gasPrice,
    Map<String, dynamic>? data,
    String? tokenId,
    String? contractAddress,
  }) {
    return NFTTransaction(
      id: id ?? this.id,
      network: network ?? this.network,
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      fee: fee ?? this.fee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      blockNumber: blockNumber ?? this.blockNumber,
      gasUsed: gasUsed ?? this.gasUsed,
      gasPrice: gasPrice ?? this.gasPrice,
      data: data ?? this.data,
      tokenId: tokenId ?? this.tokenId,
      contractAddress: contractAddress ?? this.contractAddress,
    );
  }

  /// Check if transaction is pending
  bool get isPending => status == TransactionStatus.pending;

  /// Check if transaction is confirmed
  bool get isConfirmed => status == TransactionStatus.confirmed;

  /// Check if transaction failed
  bool get isFailed => status == TransactionStatus.failed;

  /// Check if transaction is cancelled
  bool get isCancelled => status == TransactionStatus.cancelled;

  /// Get formatted amount
  String get formattedAmount => '${amount.toStringAsFixed(4)} $currency';

  /// Get formatted fee
  String get formattedFee => '${fee.toStringAsFixed(6)} $currency';

  /// Get confirmation time
  Duration? get confirmationTime {
    if (confirmedAt == null) return null;
    return confirmedAt!.difference(createdAt);
  }

  /// Get formatted confirmation time
  String get formattedConfirmationTime {
    final duration = confirmationTime;
    if (duration == null) return 'Pending';
    
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds}s';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes}m';
    } else if (duration.inDays < 1) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
  }

  /// Get total cost (amount + fee)
  double get totalCost => amount + fee;

  /// Get formatted total cost
  String get formattedTotalCost => '${totalCost.toStringAsFixed(4)} $currency';

  @override
  List<Object?> get props => [
        id,
        network,
        type,
        from,
        to,
        amount,
        currency,
        fee,
        status,
        createdAt,
        confirmedAt,
        blockNumber,
        gasUsed,
        gasPrice,
        data,
        tokenId,
        contractAddress,
      ];
}
