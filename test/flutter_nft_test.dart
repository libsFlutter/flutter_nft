import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_nft/flutter_nft.dart';

void main() {
  group('Flutter NFT Library Tests', () {
    test('NFTClient can be instantiated', () {
      final client = NFTClient();
      expect(client, isA<NFTClient>());
    });

    test('NFTClient with custom manager can be instantiated', () {
      final manager = NFTProviderManager();
      final client = NFTClient.withManager(manager, {});
      expect(client, isA<NFTClient>());
    });

    test('BlockchainNetwork enum values are correct', () {
      expect(BlockchainNetwork.ethereum.name, 'ethereum');
      expect(BlockchainNetwork.solana.name, 'solana');
      expect(BlockchainNetwork.icp.name, 'icp');
      expect(BlockchainNetwork.custom.name, 'custom');
    });

    test('Currency constants are properly defined', () {
      expect(Currency.eth.symbol, 'ETH');
      expect(Currency.eth.name, 'Ethereum');
      expect(Currency.eth.network, BlockchainNetwork.ethereum);

      expect(Currency.sol.symbol, 'SOL');
      expect(Currency.sol.name, 'Solana');
      expect(Currency.sol.network, BlockchainNetwork.solana);

      expect(Currency.icp.symbol, 'ICP');
      expect(Currency.icp.name, 'Internet Computer Protocol');
      expect(Currency.icp.network, BlockchainNetwork.icp);
    });
  });
}
