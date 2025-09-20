import 'package:flutter_nft/flutter_nft.dart';

/// Mock NFT Provider for testing
class MockNFTProvider implements NFTProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final bool _isAvailable;
  final bool _shouldThrowError;

  MockNFTProvider({
    String? id,
    String? name,
    String? version,
    BlockchainNetwork? network,
    bool isAvailable = true,
    bool shouldThrowError = false,
  })  : _id = id ?? 'mock-nft-provider',
        _name = name ?? 'Mock NFT Provider',
        _version = version ?? '1.0.0',
        _network = network ?? BlockchainNetwork.ethereum,
        _isAvailable = isAvailable,
        _shouldThrowError = shouldThrowError;

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
    if (_shouldThrowError) {
      throw Exception('Mock initialization error');
    }
    // Mock initialization
  }

  @override
  Future<void> dispose() async {
    // Mock disposal
  }

  @override
  Future<List<NFT>> getNFTsByOwner(String ownerAddress) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return [
      NFT(
        id: 'nft-1',
        tokenId: '1',
        contractAddress: '0x123',
        owner: ownerAddress,
        creator: '0x789',
        network: _network,
        metadata: NFTMetadata(
          name: 'Mock NFT 1',
          description: 'A mock NFT for testing',
          image: 'https://example.com/image1.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        transactionHistory: ['tx1'],
      ),
    ];
  }

  @override
  Future<NFT?> getNFT(String tokenId, String contractAddress) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return NFT(
      id: 'nft-$tokenId',
      tokenId: tokenId,
      contractAddress: contractAddress,
      owner: '0x456',
      creator: '0x789',
      network: _network,
      metadata: NFTMetadata(
        name: 'Mock NFT $tokenId',
        description: 'A mock NFT for testing',
        image: 'https://example.com/image.png',
        attributes: {'rarity': 'common'},
        properties: {'type': 'digital'},
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'active',
      transactionHistory: ['tx1'],
    );
  }

  @override
  Future<List<NFT>> getNFTs(
      List<String> tokenIds, String contractAddress) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return tokenIds
        .map((id) => NFT(
              id: 'nft-$id',
              tokenId: id,
              contractAddress: contractAddress,
              owner: '0x456',
              creator: '0x789',
              network: _network,
              metadata: NFTMetadata(
                name: 'Mock NFT $id',
                description: 'A mock NFT for testing',
                image: 'https://example.com/image.png',
                attributes: {'rarity': 'common'},
                properties: {'type': 'digital'},
              ),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              status: 'active',
              transactionHistory: ['tx1'],
            ))
        .toList();
  }

  @override
  Future<String> mintNFT({
    required String toAddress,
    required NFTMetadata metadata,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return 'mock-tx-hash-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> transferNFT({
    required String tokenId,
    required String fromAddress,
    required String toAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return 'mock-transfer-tx-hash-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> burnNFT({
    required String tokenId,
    required String ownerAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return 'mock-burn-tx-hash-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> approveNFT({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return 'mock-approve-tx-hash-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<bool> isApproved({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return false;
  }

  @override
  Future<NFTMetadata> getNFTMetadata({
    required String tokenId,
    required String contractAddress,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return NFTMetadata(
      name: 'Mock NFT $tokenId',
      description: 'A mock NFT for testing',
      image: 'https://example.com/image.png',
      attributes: {'rarity': 'common'},
      properties: {'type': 'digital'},
    );
  }

  @override
  Future<bool> updateNFTMetadata({
    required String tokenId,
    required String ownerAddress,
    required NFTMetadata metadata,
    required String contractAddress,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return true;
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [Currency.eth];
  }

  @override
  Future<double> estimateTransactionFee({
    required String operation,
    required Map<String, dynamic> params,
  }) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return 0.001;
  }

  @override
  Future<TransactionStatus> getTransactionStatus(String transactionHash) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return TransactionStatus.confirmed;
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(
      String transactionHash) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return {
      'hash': transactionHash,
      'status': 'confirmed',
      'blockNumber': 12345,
    };
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
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return [
      NFT(
        id: 'search-result-1',
        tokenId: 'search-result-1',
        contractAddress: contractAddress ?? '0x123',
        owner: '0x789',
        creator: '0x456',
        network: _network,
        metadata: NFTMetadata(
          name: name ?? 'Search Result NFT',
          description: description ?? 'A search result NFT',
          image: 'https://example.com/search-image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        transactionHistory: ['tx1'],
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> getContractInfo(String contractAddress) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return {
      'address': contractAddress,
      'name': 'Mock NFT Contract',
      'symbol': 'MOCK',
      'totalSupply': 1000,
    };
  }

  @override
  Future<bool> isValidContract(String contractAddress) async {
    if (_shouldThrowError) {
      throw NFTProviderNotAvailableException('Mock error');
    }
    return contractAddress.startsWith('0x');
  }
}
