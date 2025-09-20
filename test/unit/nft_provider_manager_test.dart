import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

import '../mocks/mock_nft_provider.dart';
import '../mocks/mock_wallet_provider.dart';
import '../mocks/mock_marketplace_provider.dart';

void main() {
  group('NFTProviderManager Tests', () {
    late NFTProviderManager manager;
    late MockNFTProvider nftProvider;
    late MockWalletProvider walletProvider;
    late MockMarketplaceProvider marketplaceProvider;

    setUp(() {
      manager = NFTProviderManager();
      manager.clear(); // Clear any existing providers

      nftProvider = MockNFTProvider(
        id: 'test-nft-provider',
        network: BlockchainNetwork.ethereum,
      );

      walletProvider = MockWalletProvider(
        id: 'test-wallet-provider',
        network: BlockchainNetwork.ethereum,
      );

      marketplaceProvider = MockMarketplaceProvider(
        id: 'test-marketplace-provider',
        network: BlockchainNetwork.ethereum,
      );
    });

    tearDown(() {
      manager.clear();
    });

    test('should be singleton', () {
      final instance1 = NFTProviderManager.instance;
      final instance2 = NFTProviderManager.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register NFT provider', () {
      manager.registerNFTProvider(nftProvider);

      final retrievedProvider = manager.getNFTProvider('test-nft-provider');
      expect(retrievedProvider, equals(nftProvider));
    });

    test('should register wallet provider', () {
      manager.registerWalletProvider(walletProvider);

      final retrievedProvider =
          manager.getWalletProvider('test-wallet-provider');
      expect(retrievedProvider, equals(walletProvider));
    });

    test('should register marketplace provider', () {
      manager.registerMarketplaceProvider(marketplaceProvider);

      final retrievedProvider =
          manager.getMarketplaceProvider('test-marketplace-provider');
      expect(retrievedProvider, equals(marketplaceProvider));
    });

    test('should unregister NFT provider', () {
      manager.registerNFTProvider(nftProvider);
      manager.unregisterNFTProvider('test-nft-provider');

      final retrievedProvider = manager.getNFTProvider('test-nft-provider');
      expect(retrievedProvider, isNull);
    });

    test('should unregister wallet provider', () {
      manager.registerWalletProvider(walletProvider);
      manager.unregisterWalletProvider('test-wallet-provider');

      final retrievedProvider =
          manager.getWalletProvider('test-wallet-provider');
      expect(retrievedProvider, isNull);
    });

    test('should unregister marketplace provider', () {
      manager.registerMarketplaceProvider(marketplaceProvider);
      manager.unregisterMarketplaceProvider('test-marketplace-provider');

      final retrievedProvider =
          manager.getMarketplaceProvider('test-marketplace-provider');
      expect(retrievedProvider, isNull);
    });

    test('should get NFT provider by network', () {
      manager.registerNFTProvider(nftProvider);

      final retrievedProvider =
          manager.getNFTProviderByNetwork(BlockchainNetwork.ethereum);
      expect(retrievedProvider, equals(nftProvider));
    });

    test('should get wallet provider by network', () {
      manager.registerWalletProvider(walletProvider);

      final retrievedProvider =
          manager.getWalletProviderByNetwork(BlockchainNetwork.ethereum);
      expect(retrievedProvider, equals(walletProvider));
    });

    test('should get marketplace provider by network', () {
      manager.registerMarketplaceProvider(marketplaceProvider);

      final retrievedProvider =
          manager.getMarketplaceProviderByNetwork(BlockchainNetwork.ethereum);
      expect(retrievedProvider, equals(marketplaceProvider));
    });

    test('should throw exception when provider not found by network', () {
      expect(
        () => manager.getNFTProviderByNetwork(BlockchainNetwork.solana),
        throwsA(isA<NFTProviderNotAvailableException>()),
      );
    });

    test('should get all registered providers', () {
      manager.registerNFTProvider(nftProvider);
      manager.registerWalletProvider(walletProvider);
      manager.registerMarketplaceProvider(marketplaceProvider);

      final nftProviders = manager.getAllNFTProviders();
      final walletProviders = manager.getAllWalletProviders();
      final marketplaceProviders = manager.getAllMarketplaceProviders();

      expect(nftProviders.length, 1);
      expect(walletProviders.length, 1);
      expect(marketplaceProviders.length, 1);

      expect(nftProviders.first, equals(nftProvider));
      expect(walletProviders.first, equals(walletProvider));
      expect(marketplaceProviders.first, equals(marketplaceProvider));
    });

    test('should get available providers only', () {
      final availableProvider = MockNFTProvider(
        id: 'available-provider',
        isAvailable: true,
      );
      final unavailableProvider = MockNFTProvider(
        id: 'unavailable-provider',
        isAvailable: false,
      );

      manager.registerNFTProvider(availableProvider);
      manager.registerNFTProvider(unavailableProvider);

      final availableProviders = manager.getAvailableNFTProviders();
      expect(availableProviders.length, 1);
      expect(availableProviders.first.id, 'available-provider');
    });

    test('should initialize all providers', () async {
      manager.registerNFTProvider(nftProvider);
      manager.registerWalletProvider(walletProvider);
      manager.registerMarketplaceProvider(marketplaceProvider);

      await manager.initializeAllProviders();
      // No exception should be thrown
    });

    test('should dispose all providers', () async {
      manager.registerNFTProvider(nftProvider);
      manager.registerWalletProvider(walletProvider);
      manager.registerMarketplaceProvider(marketplaceProvider);

      await manager.disposeAllProviders();

      // All providers should be cleared
      expect(manager.getAllNFTProviders().length, 0);
      expect(manager.getAllWalletProviders().length, 0);
      expect(manager.getAllMarketplaceProviders().length, 0);
    });

    test('should get supported networks', () {
      final ethereumProvider = MockNFTProvider(
        id: 'ethereum-provider',
        network: BlockchainNetwork.ethereum,
      );
      final solanaProvider = MockNFTProvider(
        id: 'solana-provider',
        network: BlockchainNetwork.solana,
      );

      manager.registerNFTProvider(ethereumProvider);
      manager.registerNFTProvider(solanaProvider);

      final networks = manager.getSupportedNetworks();
      expect(networks.length, 2);
      expect(networks, contains(BlockchainNetwork.ethereum));
      expect(networks, contains(BlockchainNetwork.solana));
    });

    test('should check if network is supported', () {
      manager.registerNFTProvider(nftProvider);

      expect(manager.isNetworkSupported(BlockchainNetwork.ethereum), isTrue);
      expect(manager.isNetworkSupported(BlockchainNetwork.solana), isFalse);
    });

    test('should get provider statistics', () {
      manager.registerNFTProvider(nftProvider);
      manager.registerWalletProvider(walletProvider);
      manager.registerMarketplaceProvider(marketplaceProvider);

      final stats = manager.getProviderStats();

      expect(stats['nftProviders']['total'], 1);
      expect(stats['nftProviders']['available'], 1);
      expect(stats['nftProviders']['networks'], contains('ethereum'));

      expect(stats['walletProviders']['total'], 1);
      expect(stats['walletProviders']['available'], 1);

      expect(stats['marketplaceProviders']['total'], 1);
      expect(stats['marketplaceProviders']['available'], 1);
    });

    test('should handle multiple providers for same network', () {
      final provider1 = MockNFTProvider(
        id: 'provider-1',
        network: BlockchainNetwork.ethereum,
      );
      final provider2 = MockNFTProvider(
        id: 'provider-2',
        network: BlockchainNetwork.ethereum,
      );

      manager.registerNFTProvider(provider1);
      manager.registerNFTProvider(provider2);

      // Should return the first registered provider
      final retrievedProvider =
          manager.getNFTProviderByNetwork(BlockchainNetwork.ethereum);
      expect(retrievedProvider?.id, 'provider-1');
    });

    test('should clear all providers', () {
      manager.registerNFTProvider(nftProvider);
      manager.registerWalletProvider(walletProvider);
      manager.registerMarketplaceProvider(marketplaceProvider);

      manager.clear();

      expect(manager.getAllNFTProviders().length, 0);
      expect(manager.getAllWalletProviders().length, 0);
      expect(manager.getAllMarketplaceProviders().length, 0);
    });

    test('should handle provider errors during initialization', () async {
      final errorProvider = MockNFTProvider(
        id: 'error-provider',
        shouldThrowError: true,
      );

      manager.registerNFTProvider(errorProvider);

      // Should throw during initialization
      expect(
        () async => await manager.initializeAllProviders(),
        throwsA(isA<Exception>()),
      );

      // Should still be registered
      expect(manager.getNFTProvider('error-provider'), equals(errorProvider));
    });
  });
}
