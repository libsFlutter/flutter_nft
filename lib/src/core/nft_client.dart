import '../interfaces/nft_provider.dart';
import '../interfaces/wallet_provider.dart';
import '../interfaces/marketplace_provider.dart';
import '../providers/nft_provider_manager.dart';
import '../core/nft_exceptions.dart';
import '../core/nft_types.dart';

/// Main client for NFT operations across multiple blockchains
class NFTClient {
  final NFTProviderManager _providerManager;
  final Map<BlockchainNetwork, String> _defaultProviders;

  NFTClient._internal(this._providerManager, this._defaultProviders);

  /// Create a new NFT client with default provider manager
  factory NFTClient() {
    return NFTClient._internal(
      NFTProviderManager.instance,
      <BlockchainNetwork, String>{},
    );
  }

  /// Create a new NFT client with custom provider manager
  factory NFTClient.withManager(
    NFTProviderManager providerManager,
    Map<BlockchainNetwork, String> defaultProviders,
  ) {
    return NFTClient._internal(providerManager, defaultProviders);
  }

  /// Set default provider for a network
  void setDefaultProvider(BlockchainNetwork network, String providerId) {
    _defaultProviders[network] = providerId;
  }

  /// Get default provider for a network
  String? getDefaultProvider(BlockchainNetwork network) {
    return _defaultProviders[network];
  }

  /// Get NFT provider for a specific network
  NFTProvider? getNFTProvider(BlockchainNetwork network) {
    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _providerManager.getNFTProvider(providerId);
      if (provider != null) return provider;
    }
    
    return _providerManager.getNFTProviderByNetwork(network);
  }

  /// Get wallet provider for a specific network
  WalletProvider? getWalletProvider(BlockchainNetwork network) {
    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _providerManager.getWalletProvider(providerId);
      if (provider != null) return provider;
    }
    
    return _providerManager.getWalletProviderByNetwork(network);
  }

  /// Get marketplace provider for a specific network
  MarketplaceProvider? getMarketplaceProvider(BlockchainNetwork network) {
    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _providerManager.getMarketplaceProvider(providerId);
      if (provider != null) return provider;
    }
    
    return _providerManager.getMarketplaceProviderByNetwork(network);
  }

  /// Initialize all providers
  Future<void> initialize() async {
    await _providerManager.initializeAllProviders();
  }

  /// Dispose all providers
  Future<void> dispose() async {
    await _providerManager.disposeAllProviders();
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

  /// Unregister an NFT provider
  void unregisterNFTProvider(String providerId) {
    _providerManager.unregisterNFTProvider(providerId);
  }

  /// Unregister a wallet provider
  void unregisterWalletProvider(String providerId) {
    _providerManager.unregisterWalletProvider(providerId);
  }

  /// Unregister a marketplace provider
  void unregisterMarketplaceProvider(String providerId) {
    _providerManager.unregisterMarketplaceProvider(providerId);
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
}
