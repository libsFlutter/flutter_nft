import 'package:flutter_yuku/flutter_yuku.dart';
import '../providers/nft_provider_manager.dart';
import 'nft_exceptions.dart';

/// Main NFT client that provides a unified interface for NFT operations
/// across multiple blockchain networks
class NFTClient {
  static final NFTClient _instance = NFTClient._internal();
  factory NFTClient() => _instance;
  NFTClient._internal();

  /// Get the singleton instance
  static NFTClient get instance => _instance;

  final NFTProviderManager _providerManager = NFTProviderManager.instance;
  bool _isInitialized = false;

  /// Whether the client is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the NFT client
  Future<void> initialize() async {
    if (_isInitialized) {
      throw NFTException('NFT client is already initialized');
    }

    try {
      await _providerManager.initializeAllProviders();
      _isInitialized = true;
    } catch (e) {
      throw NFTException('Failed to initialize NFT client: $e');
    }
  }

  /// Dispose the NFT client
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      await _providerManager.disposeAllProviders();
      _isInitialized = false;
    } catch (e) {
      throw NFTException('Failed to dispose NFT client: $e');
    }
  }

  /// Register an NFT provider
  void registerNFTProvider(NFTProvider provider) {
    _providerManager.registerNFTProvider(provider);
  }

  /// Register a wallet provider
  void registerWalletProvider(WalletProvider provider) {
    _providerManager.registerWalletProvider(provider);
  }

  /// Register a marketplace provider
  void registerMarketplaceProvider(MarketplaceProvider provider) {
    _providerManager.registerMarketplaceProvider(provider);
  }

  /// Get NFT provider for a specific network
  NFTProvider getNFTProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final provider = _providerManager.getNFTProviderByNetwork(network);
    if (provider == null) {
      throw NFTProviderNotFoundException(
        'No NFT provider found for network: ${network.name}',
      );
    }
    return provider;
  }

  /// Get wallet provider for a specific network
  WalletProvider getWalletProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final provider = _providerManager.getWalletProviderByNetwork(network);
    if (provider == null) {
      throw NFTProviderNotFoundException(
        'No wallet provider found for network: ${network.name}',
      );
    }
    return provider;
  }

  /// Get marketplace provider for a specific network
  MarketplaceProvider getMarketplaceProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final provider = _providerManager.getMarketplaceProviderByNetwork(network);
    if (provider == null) {
      throw NFTProviderNotFoundException(
        'No marketplace provider found for network: ${network.name}',
      );
    }
    return provider;
  }

  /// Get supported networks
  Set<BlockchainNetwork> getSupportedNetworks() {
    return _providerManager.getSupportedNetworks();
  }

  /// Check if a network is supported
  bool isNetworkSupported(BlockchainNetwork network) {
    return _providerManager.isNetworkSupported(network);
  }

  /// Get provider statistics
  Map<String, dynamic> getProviderStats() {
    return _providerManager.getProviderStats();
  }

  /// Get all available NFT providers
  List<NFTProvider> getAvailableNFTProviders() {
    return _providerManager.getAvailableNFTProviders();
  }

  /// Get all available wallet providers
  List<WalletProvider> getAvailableWalletProviders() {
    return _providerManager.getAvailableWalletProviders();
  }

  /// Get all available marketplace providers
  List<MarketplaceProvider> getAvailableMarketplaceProviders() {
    return _providerManager.getAvailableMarketplaceProviders();
  }

  /// Ensure the client is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw NFTException(
        'NFT client is not initialized. Call initialize() first.',
      );
    }
  }
}
