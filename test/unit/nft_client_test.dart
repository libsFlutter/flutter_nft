import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

import '../mocks/mock_nft_provider.dart';
import '../mocks/mock_wallet_provider.dart';
import '../mocks/mock_marketplace_provider.dart';

void main() {
  group('NFTClient Tests', () {
    late NFTClient client;
    late NFTProviderManager manager;
    late MockNFTProvider nftProvider;
    late MockWalletProvider walletProvider;
    late MockMarketplaceProvider marketplaceProvider;

    setUp(() {
      manager = NFTProviderManager();
      manager.clear(); // Clear any existing providers
      client = NFTClient.withManager(manager, {});

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

    test('should create NFTClient with default constructor', () {
      final defaultClient = NFTClient();
      expect(defaultClient, isA<NFTClient>());
    });

    test('should create NFTClient with custom manager', () {
      expect(client, isA<NFTClient>());
    });

    test('should set and get default provider', () {
      client.setDefaultProvider(BlockchainNetwork.ethereum, 'test-provider');
      expect(client.getDefaultProvider(BlockchainNetwork.ethereum),
          'test-provider');
    });

    test('should register and get NFT provider', () {
      client.registerNFTProvider(nftProvider);

      final retrievedProvider =
          client.getNFTProvider(BlockchainNetwork.ethereum);
      expect(retrievedProvider, isA<NFTProvider>());
      expect(retrievedProvider?.id, 'test-nft-provider');
    });

    test('should register and get wallet provider', () {
      client.registerWalletProvider(walletProvider);

      final retrievedProvider =
          client.getWalletProvider(BlockchainNetwork.ethereum);
      expect(retrievedProvider, isA<WalletProvider>());
      expect(retrievedProvider?.id, 'test-wallet-provider');
    });

    test('should register and get marketplace provider', () {
      client.registerMarketplaceProvider(marketplaceProvider);

      final retrievedProvider =
          client.getMarketplaceProvider(BlockchainNetwork.ethereum);
      expect(retrievedProvider, isA<MarketplaceProvider>());
      expect(retrievedProvider?.id, 'test-marketplace-provider');
    });

    test('should get NFT provider by default provider ID', () {
      client.registerNFTProvider(nftProvider);
      client.setDefaultProvider(
          BlockchainNetwork.ethereum, 'test-nft-provider');

      final retrievedProvider =
          client.getNFTProvider(BlockchainNetwork.ethereum);
      expect(retrievedProvider?.id, 'test-nft-provider');
    });

    test('should throw exception when provider not found', () {
      expect(
        () => client.getNFTProvider(BlockchainNetwork.solana),
        throwsA(isA<NFTProviderNotAvailableException>()),
      );
    });

    test('should initialize all providers', () async {
      client.registerNFTProvider(nftProvider);
      client.registerWalletProvider(walletProvider);
      client.registerMarketplaceProvider(marketplaceProvider);

      await client.initialize();
      // No exception should be thrown
    });

    test('should dispose all providers', () async {
      client.registerNFTProvider(nftProvider);
      client.registerWalletProvider(walletProvider);
      client.registerMarketplaceProvider(marketplaceProvider);

      await client.dispose();
      // No exception should be thrown
    });

    test('should get supported networks', () {
      client.registerNFTProvider(nftProvider);

      final networks = client.getSupportedNetworks();
      expect(networks, contains(BlockchainNetwork.ethereum));
    });

    test('should check if network is supported', () {
      client.registerNFTProvider(nftProvider);

      expect(client.isNetworkSupported(BlockchainNetwork.ethereum), isTrue);
      expect(client.isNetworkSupported(BlockchainNetwork.solana), isFalse);
    });

    test('should get provider statistics', () {
      client.registerNFTProvider(nftProvider);
      client.registerWalletProvider(walletProvider);
      client.registerMarketplaceProvider(marketplaceProvider);

      final stats = client.getProviderStats();

      expect(stats['nftProviders']['total'], 1);
      expect(stats['walletProviders']['total'], 1);
      expect(stats['marketplaceProviders']['total'], 1);
    });

    test('should unregister providers', () {
      client.registerNFTProvider(nftProvider);
      client.registerWalletProvider(walletProvider);
      client.registerMarketplaceProvider(marketplaceProvider);

      client.unregisterNFTProvider('test-nft-provider');
      client.unregisterWalletProvider('test-wallet-provider');
      client.unregisterMarketplaceProvider('test-marketplace-provider');

      expect(
        () => client.getNFTProvider(BlockchainNetwork.ethereum),
        throwsA(isA<NFTProviderNotAvailableException>()),
      );
      expect(
        () => client.getWalletProvider(BlockchainNetwork.ethereum),
        throwsA(isA<NFTProviderNotAvailableException>()),
      );
      expect(
        () => client.getMarketplaceProvider(BlockchainNetwork.ethereum),
        throwsA(isA<NFTProviderNotAvailableException>()),
      );
    });

    test('should get all available providers', () {
      client.registerNFTProvider(nftProvider);
      client.registerWalletProvider(walletProvider);
      client.registerMarketplaceProvider(marketplaceProvider);

      final nftProviders = client.getAvailableNFTProviders();
      final walletProviders = client.getAvailableWalletProviders();
      final marketplaceProviders = client.getAvailableMarketplaceProviders();

      expect(nftProviders.length, 1);
      expect(walletProviders.length, 1);
      expect(marketplaceProviders.length, 1);
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

      client.registerNFTProvider(provider1);
      client.registerNFTProvider(provider2);

      // Should return the first registered provider
      final retrievedProvider =
          client.getNFTProvider(BlockchainNetwork.ethereum);
      expect(retrievedProvider?.id, 'provider-1');
    });

    test('should handle provider errors gracefully', () async {
      final errorProvider = MockNFTProvider(
        id: 'error-provider',
        shouldThrowError: true,
      );

      client.registerNFTProvider(errorProvider);

      // Should throw during initialization
      expect(
        () async => await client.initialize(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
