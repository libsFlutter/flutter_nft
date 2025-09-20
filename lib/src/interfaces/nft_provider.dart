import '../models/nft.dart';
import '../models/nft_metadata.dart';
import '../core/nft_types.dart';

/// Abstract interface for NFT operations across different blockchains
abstract class NFTProvider {
  /// Unique identifier for this provider
  String get id;

  /// Human-readable name of the provider
  String get name;

  /// Version of the provider
  String get version;

  /// Supported blockchain network
  BlockchainNetwork get network;

  /// Whether this provider is currently available
  bool get isAvailable;

  /// Initialize the provider
  Future<void> initialize();

  /// Dispose the provider
  Future<void> dispose();

  /// Get NFTs owned by a specific address
  Future<List<NFT>> getNFTsByOwner(String ownerAddress);

  /// Get NFT by token ID and contract address
  Future<NFT?> getNFT(String tokenId, String contractAddress);

  /// Get multiple NFTs by their IDs
  Future<List<NFT>> getNFTs(List<String> tokenIds, String contractAddress);

  /// Mint a new NFT
  Future<String> mintNFT({
    required String toAddress,
    required NFTMetadata metadata,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  });

  /// Transfer NFT to another address
  Future<String> transferNFT({
    required String tokenId,
    required String fromAddress,
    required String toAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  });

  /// Burn (destroy) an NFT
  Future<String> burnNFT({
    required String tokenId,
    required String ownerAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  });

  /// Approve another address to transfer NFT
  Future<String> approveNFT({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  });

  /// Check if an address is approved for a specific NFT
  Future<bool> isApproved({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
  });

  /// Get metadata for an NFT
  Future<NFTMetadata> getNFTMetadata({
    required String tokenId,
    required String contractAddress,
  });

  /// Update metadata for an NFT (if supported)
  Future<bool> updateNFTMetadata({
    required String tokenId,
    required String ownerAddress,
    required NFTMetadata metadata,
    required String contractAddress,
  });

  /// Get supported currencies for this provider
  List<SupportedCurrency> getSupportedCurrencies();

  /// Estimate gas/transaction fees for an operation
  Future<double> estimateTransactionFee({
    required String operation,
    required Map<String, dynamic> params,
  });

  /// Get transaction status
  Future<TransactionStatus> getTransactionStatus(String transactionHash);

  /// Get transaction details
  Future<Map<String, dynamic>> getTransactionDetails(String transactionHash);

  /// Search NFTs by criteria
  Future<List<NFT>> searchNFTs({
    String? name,
    String? description,
    Map<String, dynamic>? attributes,
    String? contractAddress,
    int? limit,
    int? offset,
  });

  /// Get contract information
  Future<Map<String, dynamic>> getContractInfo(String contractAddress);

  /// Verify if a contract is valid for this provider
  Future<bool> isValidContract(String contractAddress);
}
