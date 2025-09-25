import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_yuku/flutter_yuku.dart';
import '../core/nft_exceptions.dart';

/// Real Solana NFT Provider implementation
class SolanaNFTProvider implements NFTProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final String _rpcUrl;
  final bool _isAvailable;

  SolanaNFTProvider({String? id, String? name, String? version, String? rpcUrl})
    : _id = id ?? 'solana-nft-provider',
      _name = name ?? 'Solana NFT Provider',
      _version = version ?? '1.0.0',
      _network = BlockchainNetwork.solana,
      _rpcUrl = rpcUrl ?? 'https://api.mainnet-beta.solana.com',
      _isAvailable = true;

  @override
  String get id => _id;

  @override
  String get name => _name;

  @override
  String get version => _version;

  @override
  BlockchainNetwork get network => _network;

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<void> initialize() async {
    // Solana RPC doesn't require initialization
  }

  @override
  Future<void> dispose() async {
    // No cleanup needed
  }

  @override
  Future<List<NFT>> getNFTsByOwner(String ownerAddress) async {
    try {
      final response = await _makeRpcRequest('getTokenAccountsByOwner', [
        ownerAddress,
        {
          'programId':
              'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA', // SPL Token Program
        },
        {'encoding': 'jsonParsed'},
      ]);

      if (response['result'] != null) {
        final accounts = response['result']['value'] as List<dynamic>;
        final nfts = <NFT>[];

        for (final account in accounts) {
          try {
            final accountData = account['account']['data']['parsed']['info'];
            final mint = accountData['mint'];
            final amount = accountData['tokenAmount']['amount'];

            // Only include NFTs (amount = 1)
            if (amount == '1') {
              final nft = await _getNFTByMint(mint);
              if (nft != null) {
                nfts.add(nft);
              }
            }
          } catch (e) {
            // Skip invalid accounts
            continue;
          }
        }

        return nfts;
      } else {
        return [];
      }
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFTs by owner: $e');
    }
  }

  @override
  Future<NFT?> getNFT(String tokenId, String contractAddress) async {
    try {
      return await _getNFTByMint(tokenId);
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFT: $e');
    }
  }

  @override
  Future<List<NFT>> getNFTs(
    List<String> tokenIds,
    String contractAddress,
  ) async {
    try {
      final nfts = <NFT>[];
      for (final tokenId in tokenIds) {
        final nft = await _getNFTByMint(tokenId);
        if (nft != null) {
          nfts.add(nft);
        }
      }
      return nfts;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFTs: $e');
    }
  }

  @override
  Future<String> mintNFT({
    required String toAddress,
    required NFTMetadata metadata,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      // Solana NFT minting requires complex transaction building
      // This would need integration with Solana SDK
      throw NFTProviderNotAvailableException(
        'NFT minting requires Solana SDK integration',
      );
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to mint NFT: $e');
    }
  }

  @override
  Future<String> transferNFT({
    required String tokenId,
    required String fromAddress,
    required String toAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      // Solana NFT transfer requires complex transaction building
      // This would need integration with Solana SDK
      throw NFTProviderNotAvailableException(
        'NFT transfer requires Solana SDK integration',
      );
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to transfer NFT: $e');
    }
  }

  @override
  Future<String> burnNFT({
    required String tokenId,
    required String ownerAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      // Solana NFT burning requires complex transaction building
      // This would need integration with Solana SDK
      throw NFTProviderNotAvailableException(
        'NFT burning requires Solana SDK integration',
      );
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to burn NFT: $e');
    }
  }

  @override
  Future<String> approveNFT({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      // Solana doesn't have approval mechanism like Ethereum
      throw NFTProviderNotAvailableException(
        'Approval not supported on Solana',
      );
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to approve NFT: $e');
    }
  }

  @override
  Future<bool> isApproved({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
  }) async {
    // Solana doesn't have approval mechanism like Ethereum
    return false;
  }

  @override
  Future<NFTMetadata> getNFTMetadata({
    required String tokenId,
    required String contractAddress,
  }) async {
    try {
      final metadata = await _getMetadataFromMint(tokenId);
      return metadata;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFT metadata: $e');
    }
  }

  @override
  Future<bool> updateNFTMetadata({
    required String tokenId,
    required String ownerAddress,
    required NFTMetadata metadata,
    required String contractAddress,
  }) async {
    try {
      // Solana metadata updates require complex transaction building
      // This would need integration with Solana SDK
      throw NFTProviderNotAvailableException(
        'Metadata updates require Solana SDK integration',
      );
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to update NFT metadata: $e',
      );
    }
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [
      SupportedCurrency(
        symbol: 'SOL',
        name: 'Solana',
        decimals: 9,
        contractAddress: null,
      ),
      SupportedCurrency(
        symbol: 'USDC',
        name: 'USD Coin',
        decimals: 6,
        contractAddress: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
      ),
      SupportedCurrency(
        symbol: 'USDT',
        name: 'Tether USD',
        decimals: 6,
        contractAddress: 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB',
      ),
    ];
  }

  @override
  Future<double> estimateTransactionFee({
    required String operation,
    required Map<String, dynamic> params,
  }) async {
    try {
      // Solana has very low transaction fees (around 0.000005 SOL)
      return 0.000005;
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to estimate transaction fee: $e',
      );
    }
  }

  @override
  Future<TransactionStatus> getTransactionStatus(String transactionHash) async {
    try {
      final response = await _makeRpcRequest('getTransaction', [
        transactionHash,
        {'encoding': 'jsonParsed'},
      ]);

      if (response['result'] != null) {
        final transaction = response['result'];
        if (transaction['meta'] != null) {
          final err = transaction['meta']['err'];
          return err == null
              ? TransactionStatus.confirmed
              : TransactionStatus.failed;
        }
      }

      return TransactionStatus.pending;
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to get transaction status: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(
    String transactionHash,
  ) async {
    try {
      final response = await _makeRpcRequest('getTransaction', [
        transactionHash,
        {'encoding': 'jsonParsed'},
      ]);

      if (response['result'] != null) {
        final transaction = response['result'];
        return {
          'hash': transactionHash,
          'slot': transaction['slot'],
          'blockTime': transaction['blockTime'],
          'fee': transaction['meta']?['fee'],
          'status': transaction['meta']?['err'] == null ? 'success' : 'failed',
          'network': 'solana',
        };
      } else {
        throw Exception('Transaction not found');
      }
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to get transaction details: $e',
      );
    }
  }

  @override
  Future<List<NFT>> searchNFTs({
    String? name,
    String? description,
    Map<String, dynamic>? attributes,
    String? contractAddress,
    int? limit,
    int? offset,
  }) async {
    // This would require indexing service integration
    // For now, return empty list
    return [];
  }

  @override
  Future<Map<String, dynamic>> getContractInfo(String contractAddress) async {
    try {
      // Solana doesn't have contracts like Ethereum
      // This would return collection information instead
      return {
        'collectionAddress': contractAddress,
        'network': _network.toString(),
        'chainId': 101, // Solana mainnet
      };
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get contract info: $e');
    }
  }

  @override
  Future<bool> verifyContract(String contractAddress) async {
    try {
      // Solana doesn't have contracts like Ethereum
      // This would verify if the address is a valid collection
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<NFT>> getOwnedNFTs(String address) => getNFTsByOwner(address);

  @override
  Future<bool> isValidContract(String contractAddress) =>
      verifyContract(contractAddress);

  // Private helper methods

  Future<Map<String, dynamic>> _makeRpcRequest(
    String method,
    List<dynamic> params,
  ) async {
    final requestBody = {
      'jsonrpc': '2.0',
      'id': 1,
      'method': method,
      'params': params,
    };

    final response = await http.post(
      Uri.parse(_rpcUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('RPC request failed: ${response.statusCode}');
    }
  }

  Future<NFT?> _getNFTByMint(String mint) async {
    try {
      // Get token account info
      final response = await _makeRpcRequest('getTokenAccountsByOwner', [
        mint,
        {'programId': 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA'},
        {'encoding': 'jsonParsed'},
      ]);

      if (response['result'] != null &&
          response['result']['value'].isNotEmpty) {
        final account = response['result']['value'][0];
        final owner = account['account']['data']['parsed']['info']['owner'];

        // Get metadata
        final metadata = await _getMetadataFromMint(mint);

        return NFT(
          id: mint,
          tokenId: mint,
          contractAddress: '', // Solana doesn't have contracts
          owner: owner,
          creator: owner, // Would need to track creator separately
          network: _network,
          metadata: metadata,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: 'active',
          transactionHistory: [],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<NFTMetadata> _getMetadataFromMint(String mint) async {
    try {
      // This would require integration with Metaplex metadata program
      // For now, return default metadata
      return NFTMetadata(
        name: 'Solana NFT',
        description: 'A Solana NFT',
        image: '',
        attributes: {},
        properties: {'mint': mint, 'network': 'solana'},
      );
    } catch (e) {
      return NFTMetadata(
        name: 'Unknown NFT',
        description: 'Metadata unavailable',
        image: '',
        attributes: {},
        properties: {},
      );
    }
  }
}
