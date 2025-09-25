import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_yuku/flutter_yuku.dart';
import '../core/nft_types.dart';
import '../core/nft_exceptions.dart';

/// Real OpenSea Marketplace Provider implementation
class OpenSeaMarketplaceProvider implements MarketplaceProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final String _apiKey;
  final String _baseUrl;
  final bool _isAvailable;

  OpenSeaMarketplaceProvider({
    String? id,
    String? name,
    String? version,
    String? apiKey,
    String? baseUrl,
  }) : _id = id ?? 'opensea-marketplace-provider',
       _name = name ?? 'OpenSea Marketplace Provider',
       _version = version ?? '1.0.0',
       _network = BlockchainNetwork.ethereum,
       _apiKey = apiKey ?? '',
       _baseUrl = baseUrl ?? 'https://api.opensea.io/api/v1',
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
    // OpenSea API doesn't require initialization
  }

  @override
  Future<void> dispose() async {
    // No cleanup needed
  }

  @override
  Future<List<NFTListing>> getActiveListings({
    String? contractAddress,
    String? sellerAddress,
    String? collectionId,
    double? minPrice,
    double? maxPrice,
    String? currency,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (contractAddress != null) {
        queryParams['asset_contract_address'] = contractAddress;
      }
      if (sellerAddress != null) {
        queryParams['owner'] = sellerAddress;
      }
      if (collectionId != null) {
        queryParams['collection_slug'] = collectionId;
      }
      if (currency != null) {
        queryParams['payment_asset_type'] = currency;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/assets',
      ).replace(queryParameters: queryParams);
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final assets = data['assets'] as List<dynamic>;

        return assets.map((asset) => _parseAssetToListing(asset)).toList();
      } else {
        throw MarketplaceException(
          'Failed to get active listings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to get active listings: $e');
    }
  }

  @override
  Future<List<NFTListing>> getUserListings(String userAddress) async {
    return await getActiveListings(sellerAddress: userAddress);
  }

  @override
  Future<NFTListing?> getListing(String listingId) async {
    try {
      final uri = Uri.parse('$_baseUrl/asset/$listingId');
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final asset = jsonDecode(response.body) as Map<String, dynamic>;
        return _parseAssetToListing(asset);
      } else {
        return null;
      }
    } catch (e) {
      throw MarketplaceException('Failed to get listing: $e');
    }
  }

  @override
  Future<String> createListing({
    required String nftId,
    required String contractAddress,
    required double price,
    required String currency,
    required String sellerAddress,
    int? expirationDays,
    int? durationDays,
    Map<String, dynamic>? additionalParams,
  }) async {
    // OpenSea doesn't provide direct API for creating listings
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Creating listings requires OpenSea SDK integration',
    );
  }

  @override
  Future<bool> cancelListing(String listingId) async {
    // OpenSea doesn't provide direct API for canceling listings
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Canceling listings requires OpenSea SDK integration',
    );
  }

  @override
  Future<String> buyNFT({
    required String listingId,
    required String buyerAddress,
    double? price,
    Map<String, dynamic>? additionalParams,
  }) async {
    // OpenSea doesn't provide direct API for buying NFTs
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException('Buying NFTs requires OpenSea SDK integration');
  }

  @override
  Future<List<NFTOffer>> getActiveOffers({
    String? contractAddress,
    String? nftId,
    String? buyerAddress,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (contractAddress != null) {
        queryParams['asset_contract_address'] = contractAddress;
      }
      if (nftId != null) {
        queryParams['token_id'] = nftId;
      }
      if (buyerAddress != null) {
        queryParams['maker'] = buyerAddress;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/orders',
      ).replace(queryParameters: queryParams);
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final orders = data['orders'] as List<dynamic>;

        return orders.map((order) => _parseOrderToOffer(order)).toList();
      } else {
        throw MarketplaceException(
          'Failed to get active offers: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to get active offers: $e');
    }
  }

  @override
  Future<List<NFTOffer>> getUserOffers(String userAddress) async {
    return await getActiveOffers(buyerAddress: userAddress);
  }

  @override
  Future<List<NFTOffer>> getNFTOffers(
    String nftId,
    String contractAddress,
  ) async {
    return await getActiveOffers(
      nftId: nftId,
      contractAddress: contractAddress,
    );
  }

  @override
  Future<NFTOffer?> getOffer(String offerId) async {
    try {
      final uri = Uri.parse('$_baseUrl/order/$offerId');
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final order = jsonDecode(response.body) as Map<String, dynamic>;
        return _parseOrderToOffer(order);
      } else {
        return null;
      }
    } catch (e) {
      throw MarketplaceException('Failed to get offer: $e');
    }
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
    // OpenSea doesn't provide direct API for making offers
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Making offers requires OpenSea SDK integration',
    );
  }

  @override
  Future<bool> acceptOffer(String offerId) async {
    // OpenSea doesn't provide direct API for accepting offers
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Accepting offers requires OpenSea SDK integration',
    );
  }

  @override
  Future<bool> rejectOffer(String offerId) async {
    // OpenSea doesn't provide direct API for rejecting offers
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Rejecting offers requires OpenSea SDK integration',
    );
  }

  @override
  Future<bool> cancelOffer(String offerId) async {
    // OpenSea doesn't provide direct API for canceling offers
    // This would require integration with their SDK or smart contracts
    throw MarketplaceException(
      'Canceling offers requires OpenSea SDK integration',
    );
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
    try {
      final queryParams = <String, String>{};

      if (name != null) {
        queryParams['search'] = name;
      }
      if (contractAddress != null) {
        queryParams['asset_contract_address'] = contractAddress;
      }
      if (currency != null) {
        queryParams['payment_asset_type'] = currency;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/assets',
      ).replace(queryParameters: queryParams);
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final assets = data['assets'] as List<dynamic>;

        return assets.map((asset) => _parseAssetToListing(asset)).toList();
      } else {
        throw MarketplaceException(
          'Failed to search listings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to search listings: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMarketplaceStats() async {
    try {
      final uri = Uri.parse('$_baseUrl/collections');
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'totalCollections': data['collections']?.length ?? 0,
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        throw MarketplaceException(
          'Failed to get marketplace stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to get marketplace stats: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCollectionStats(
    String contractAddress,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/collection/$contractAddress/stats');
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw MarketplaceException(
          'Failed to get collection stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to get collection stats: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserActivity(String userAddress) async {
    try {
      final uri = Uri.parse('$_baseUrl/events').replace(
        queryParameters: {'account_address': userAddress, 'limit': '50'},
      );
      final response = await _makeRequest(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'events': data['asset_events'] ?? [],
          'totalEvents': data['asset_events']?.length ?? 0,
        };
      } else {
        throw MarketplaceException(
          'Failed to get user activity: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw MarketplaceException('Failed to get user activity: $e');
    }
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [
      SupportedCurrency(
        symbol: 'ETH',
        name: 'Ethereum',
        decimals: 18,
        contractAddress: null,
      ),
      SupportedCurrency(
        symbol: 'WETH',
        name: 'Wrapped Ethereum',
        decimals: 18,
        contractAddress: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
      ),
      SupportedCurrency(
        symbol: 'USDC',
        name: 'USD Coin',
        decimals: 6,
        contractAddress: '0xA0b86a33E6441b8C4C8C0d4Ce0a7d303e52DbF0E',
      ),
      SupportedCurrency(
        symbol: 'DAI',
        name: 'Dai Stablecoin',
        decimals: 18,
        contractAddress: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
      ),
    ];
  }

  @override
  bool isCurrencySupported(String currency) {
    final supportedCurrencies = getSupportedCurrencies();
    return supportedCurrencies.any(
      (c) => c.symbol.toUpperCase() == currency.toUpperCase(),
    );
  }

  @override
  Future<Map<String, double>> getMarketplaceFees() async {
    return {
      'opensea_fee': 0.025, // 2.5%
      'creator_fee': 0.0, // Variable per collection
      'network_fee': 0.0, // Gas fees
    };
  }

  @override
  Future<Map<String, double>> calculateFees({
    required double price,
    required String currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    final fees = await getMarketplaceFees();
    final openseaFee = price * fees['opensea_fee']!;

    return {
      'opensea_fee': openseaFee,
      'creator_fee': 0.0, // Would need collection info to calculate
      'total_fees': openseaFee,
      'net_amount': price - openseaFee,
    };
  }

  // Private helper methods

  Future<http.Response> _makeRequest(Uri uri) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (_apiKey.isNotEmpty) {
      headers['X-API-KEY'] = _apiKey;
    }

    return await http.get(uri, headers: headers);
  }

  NFTListing _parseAssetToListing(Map<String, dynamic> asset) {
    final tokenId = asset['token_id']?.toString() ?? '';
    final contractAddress = asset['asset_contract']?['address'] ?? '';
    final owner = asset['owner']?['address'] ?? '';
    final name = asset['name'] ?? 'Unknown NFT';
    final imageUrl = asset['image_url'] ?? '';

    // Parse price if available
    double price = 0.0;
    String currency = 'ETH';

    if (asset['sell_orders'] != null && asset['sell_orders'].isNotEmpty) {
      final sellOrder = asset['sell_orders'][0];
      final currentPrice = sellOrder['current_price'];
      if (currentPrice != null) {
        price = double.tryParse(currentPrice.toString()) ?? 0.0;
        currency = sellOrder['payment_token_contract']?['symbol'] ?? 'ETH';
      }
    }

    return NFTListing(
      id: '${contractAddress}_$tokenId',
      nftId: tokenId,
      contractAddress: contractAddress,
      network: _network,
      sellerAddress: owner,
      price: price,
      currency: currency,
      status: price > 0 ? ListingStatus.active : ListingStatus.cancelled,
      createdAt:
          DateTime.tryParse(asset['created_date'] ?? '') ?? DateTime.now(),
      marketplaceProvider: _id,
      additionalProperties: {
        'name': name,
        'image_url': imageUrl,
        'description': asset['description'] ?? '',
        'traits': asset['traits'] ?? [],
      },
    );
  }

  NFTOffer _parseOrderToOffer(Map<String, dynamic> order) {
    final orderHash = order['order_hash'] ?? '';
    final maker = order['maker']?['address'] ?? '';
    final currentPrice = order['current_price'];
    final paymentToken = order['payment_token_contract'];

    double amount = 0.0;
    String currency = 'ETH';

    if (currentPrice != null) {
      amount = double.tryParse(currentPrice.toString()) ?? 0.0;
      currency = paymentToken?['symbol'] ?? 'ETH';
    }

    return NFTOffer(
      id: orderHash,
      nftId: order['asset']?['token_id']?.toString() ?? '',
      contractAddress: order['asset']?['asset_contract']?['address'] ?? '',
      network: _network,
      buyerAddress: maker,
      amount: amount,
      currency: currency,
      status: OfferStatus.pending,
      createdAt:
          DateTime.tryParse(order['created_date'] ?? '') ?? DateTime.now(),
      marketplaceProvider: _id,
      additionalProperties: {
        'order_hash': orderHash,
        'expiration_time': order['expiration_time'],
        'side': order['side'],
      },
    );
  }
}
