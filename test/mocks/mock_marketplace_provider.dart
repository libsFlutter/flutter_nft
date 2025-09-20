import 'package:flutter_nft/flutter_nft.dart';

/// Mock Marketplace Provider for testing
class MockMarketplaceProvider implements MarketplaceProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final bool _isAvailable;
  final bool _shouldThrowError;

  MockMarketplaceProvider({
    String? id,
    String? name,
    String? version,
    BlockchainNetwork? network,
    bool isAvailable = true,
    bool shouldThrowError = false,
  })  : _id = id ?? 'mock-marketplace-provider',
        _name = name ?? 'Mock Marketplace Provider',
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
  Future<List<NFTListing>> getActiveListings({
    String? contractAddress,
    String? sellerAddress,
    int? limit,
    int? offset,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock listings error');
    }
    return [
      NFTListing(
        id: 'listing-1',
        nftId: 'nft-1',
        contractAddress: contractAddress ?? '0x123',
        network: _network,
        sellerAddress: sellerAddress ?? '0x456',
        price: 1.5,
        currency: 'ETH',
        status: ListingStatus.active,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<List<NFTListing>> getUserListings(String userAddress) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock user listings error');
    }
    return [
      NFTListing(
        id: 'user-listing-1',
        nftId: 'nft-1',
        contractAddress: '0x123',
        network: _network,
        sellerAddress: userAddress,
        price: 2.0,
        currency: 'ETH',
        status: ListingStatus.active,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<NFTListing?> getListing(String listingId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock listing error');
    }
    return NFTListing(
      id: listingId,
      nftId: 'nft-1',
      contractAddress: '0x123',
      network: _network,
      sellerAddress: '0x456',
      price: 1.5,
      currency: 'ETH',
      status: ListingStatus.active,
      createdAt: DateTime.now(),
      marketplaceProvider: 'mock-marketplace',
    );
  }

  @override
  Future<String> createListing({
    required String nftId,
    required String contractAddress,
    required double price,
    required String currency,
    required String sellerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock create listing error');
    }
    return 'listing-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<bool> cancelListing(String listingId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock cancel listing error');
    }
    return true;
  }

  @override
  Future<String> buyNFT({
    required String listingId,
    required String buyerAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock buy NFT error');
    }
    return 'buy-tx-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<List<NFTOffer>> getActiveOffers({
    String? contractAddress,
    String? nftId,
    String? buyerAddress,
    int? limit,
    int? offset,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock offers error');
    }
    return [
      NFTOffer(
        id: 'offer-1',
        nftId: nftId ?? 'nft-1',
        contractAddress: contractAddress ?? '0x123',
        network: _network,
        buyerAddress: buyerAddress ?? '0x789',
        amount: 1.2,
        currency: 'ETH',
        status: OfferStatus.pending,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<List<NFTOffer>> getUserOffers(String userAddress) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock user offers error');
    }
    return [
      NFTOffer(
        id: 'user-offer-1',
        nftId: 'nft-1',
        contractAddress: '0x123',
        network: _network,
        buyerAddress: userAddress,
        amount: 1.0,
        currency: 'ETH',
        status: OfferStatus.pending,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<List<NFTOffer>> getNFTOffers(
      String nftId, String contractAddress) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock NFT offers error');
    }
    return [
      NFTOffer(
        id: 'nft-offer-1',
        nftId: nftId,
        contractAddress: contractAddress,
        network: _network,
        buyerAddress: '0x789',
        amount: 1.5,
        currency: 'ETH',
        status: OfferStatus.pending,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<NFTOffer?> getOffer(String offerId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock offer error');
    }
    return NFTOffer(
      id: offerId,
      nftId: 'nft-1',
      contractAddress: '0x123',
      network: _network,
      buyerAddress: '0x789',
      amount: 1.5,
      currency: 'ETH',
      status: OfferStatus.pending,
      createdAt: DateTime.now(),
      marketplaceProvider: 'mock-marketplace',
    );
  }

  @override
  Future<String> makeOffer({
    required String nftId,
    required String contractAddress,
    required double amount,
    required String currency,
    required String buyerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock make offer error');
    }
    return 'offer-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<bool> acceptOffer(String offerId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock accept offer error');
    }
    return true;
  }

  @override
  Future<bool> rejectOffer(String offerId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock reject offer error');
    }
    return true;
  }

  @override
  Future<bool> cancelOffer(String offerId) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock cancel offer error');
    }
    return true;
  }

  @override
  Future<List<NFTListing>> searchListings({
    String? name,
    String? description,
    Map<String, dynamic>? attributes,
    double? minPrice,
    double? maxPrice,
    String? currency,
    String? contractAddress,
    int? limit,
    int? offset,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock search error');
    }
    return [
      NFTListing(
        id: 'search-listing-1',
        nftId: 'nft-search-1',
        contractAddress: contractAddress ?? '0x123',
        network: _network,
        sellerAddress: '0x456',
        price: minPrice ?? 1.0,
        currency: currency ?? 'ETH',
        status: ListingStatus.active,
        createdAt: DateTime.now(),
        marketplaceProvider: 'mock-marketplace',
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> getMarketplaceStats() async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock stats error');
    }
    return {
      'totalListings': 100,
      'totalVolume': 1000.0,
      'averagePrice': 10.0,
      'activeOffers': 50,
    };
  }

  @override
  Future<Map<String, dynamic>> getCollectionStats(
      String contractAddress) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock collection stats error');
    }
    return {
      'contractAddress': contractAddress,
      'totalSupply': 1000,
      'floorPrice': 0.5,
      'totalVolume': 500.0,
      'activeListings': 25,
    };
  }

  @override
  Future<Map<String, dynamic>> getUserActivity(String userAddress) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock user activity error');
    }
    return {
      'userAddress': userAddress,
      'listings': 5,
      'offers': 3,
      'purchases': 2,
      'sales': 1,
    };
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [Currency.eth, Currency.sol, Currency.icp];
  }

  @override
  bool isCurrencySupported(String currency) {
    return ['ETH', 'SOL', 'ICP'].contains(currency.toUpperCase());
  }

  @override
  Future<Map<String, double>> getMarketplaceFees() async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock fees error');
    }
    return {
      'listingFee': 0.025,
      'transactionFee': 0.025,
      'royaltyFee': 0.05,
    };
  }

  @override
  Future<Map<String, double>> calculateFees({
    required double price,
    required String currency,
  }) async {
    if (_shouldThrowError) {
      throw MarketplaceException('Mock calculate fees error');
    }
    return {
      'platformFee': price * 0.025,
      'royaltyFee': price * 0.05,
      'totalFees': price * 0.075,
    };
  }
}
