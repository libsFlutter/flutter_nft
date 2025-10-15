import 'dart:async';
import 'package:flutter_yuku/flutter_yuku.dart';

/// Manages NFT providers across different blockchains
class NFTProviderManager {
  static final NFTProviderManager _instance = NFTProviderManager._internal();
  factory NFTProviderManager() => _instance;
  NFTProviderManager._internal();

  final Map<String, NFTProvider> _nftProviders = {};
  final Map<String, WalletProvider> _walletProviders = {};
  final Map<String, MarketplaceProvider> _marketplaceProviders = {};

  /// Get singleton instance
  static NFTProviderManager get instance => _instance;

  /// Register an NFT provider
  void registerNFTProvider(NFTProvider provider) {
    _nftProviders[provider.id] = provider;
  }

  /// Register a wallet provider
  void registerWalletProvider(WalletProvider provider) {
    _walletProviders[provider.id] = provider;
  }

  /// Register a marketplace provider
  void registerMarketplaceProvider(MarketplaceProvider provider) {
    _marketplaceProviders[provider.id] = provider;
  }

  /// Unregister a provider
  void unregisterNFTProvider(String providerId) {
    _nftProviders.remove(providerId);
  }

  /// Unregister a wallet provider
  void unregisterWalletProvider(String providerId) {
    _walletProviders.remove(providerId);
  }

  /// Unregister a marketplace provider
  void unregisterMarketplaceProvider(String providerId) {
    _marketplaceProviders.remove(providerId);
  }

  /// Get NFT provider by ID
  NFTProvider? getNFTProvider(String providerId) {
    return _nftProviders[providerId];
  }

  /// Get wallet provider by ID
  WalletProvider? getWalletProvider(String providerId) {
    return _walletProviders[providerId];
  }

  /// Get marketplace provider by ID
  MarketplaceProvider? getMarketplaceProvider(String providerId) {
    return _marketplaceProviders[providerId];
  }

  /// Get NFT provider by network
  NFTProvider? getNFTProviderByNetwork(BlockchainNetwork network) {
    try {
      return _nftProviders.values.firstWhere(
        (provider) => provider.network == network,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get wallet provider by network
  WalletProvider? getWalletProviderByNetwork(BlockchainNetwork network) {
    try {
      return _walletProviders.values.firstWhere(
        (provider) => provider.network == network,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get marketplace provider by network
  MarketplaceProvider? getMarketplaceProviderByNetwork(
    BlockchainNetwork network,
  ) {
    try {
      return _marketplaceProviders.values.firstWhere(
        (provider) => provider.network == network,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all registered NFT providers
  List<NFTProvider> getAllNFTProviders() {
    return _nftProviders.values.toList();
  }

  /// Get all registered wallet providers
  List<WalletProvider> getAllWalletProviders() {
    return _walletProviders.values.toList();
  }

  /// Get all registered marketplace providers
  List<MarketplaceProvider> getAllMarketplaceProviders() {
    return _marketplaceProviders.values.toList();
  }

  /// Get available NFT providers
  List<NFTProvider> getAvailableNFTProviders() {
    return _nftProviders.values
        .where((provider) => provider.isAvailable)
        .toList();
  }

  /// Get available wallet providers
  List<WalletProvider> getAvailableWalletProviders() {
    return _walletProviders.values
        .where((provider) => provider.isAvailable)
        .toList();
  }

  /// Get available marketplace providers
  List<MarketplaceProvider> getAvailableMarketplaceProviders() {
    return _marketplaceProviders.values
        .where((provider) => provider.isAvailable)
        .toList();
  }

  /// Initialize all providers
  Future<void> initializeAllProviders() async {
    final futures = <Future>[];

    // Initialize NFT providers
    for (final provider in _nftProviders.values) {
      if (provider.isAvailable) {
        futures.add(provider.initialize());
      }
    }

    // Initialize wallet providers
    for (final provider in _walletProviders.values) {
      if (provider.isAvailable) {
        futures.add(provider.initialize());
      }
    }

    // Initialize marketplace providers
    for (final provider in _marketplaceProviders.values) {
      if (provider.isAvailable) {
        futures.add(provider.initialize());
      }
    }

    await Future.wait(futures);
  }

  /// Dispose all providers
  Future<void> disposeAllProviders() async {
    final futures = <Future>[];

    // Dispose NFT providers
    for (final provider in _nftProviders.values) {
      futures.add(provider.dispose());
    }

    // Dispose wallet providers
    for (final provider in _walletProviders.values) {
      futures.add(provider.dispose());
    }

    // Dispose marketplace providers
    for (final provider in _marketplaceProviders.values) {
      futures.add(provider.dispose());
    }

    await Future.wait(futures);

    // Clear all providers
    _nftProviders.clear();
    _walletProviders.clear();
    _marketplaceProviders.clear();
  }

  /// Get supported networks
  Set<BlockchainNetwork> getSupportedNetworks() {
    final networks = <BlockchainNetwork>{};

    for (final provider in _nftProviders.values) {
      networks.add(provider.network);
    }

    return networks;
  }

  /// Check if a network is supported
  bool isNetworkSupported(BlockchainNetwork network) {
    return _nftProviders.values.any((provider) => provider.network == network);
  }

  /// Get provider statistics
  Map<String, dynamic> getProviderStats() {
    return {
      'nftProviders': {
        'total': _nftProviders.length,
        'available': getAvailableNFTProviders().length,
        'networks': getSupportedNetworks().map((n) => n.name).toList(),
      },
      'walletProviders': {
        'total': _walletProviders.length,
        'available': getAvailableWalletProviders().length,
      },
      'marketplaceProviders': {
        'total': _marketplaceProviders.length,
        'available': getAvailableMarketplaceProviders().length,
      },
    };
  }

  /// Clear all providers
  void clear() {
    _nftProviders.clear();
    _walletProviders.clear();
    _marketplaceProviders.clear();
  }
}
