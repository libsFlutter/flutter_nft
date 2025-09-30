import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

void main() {
  group('NFT Types Tests', () {
    group('BlockchainNetwork', () {
      test('should have correct enum values', () {
        expect(BlockchainNetwork.ethereum.name, 'ethereum');
        expect(BlockchainNetwork.solana.name, 'solana');
        expect(BlockchainNetwork.polygon.name, 'polygon');
        expect(BlockchainNetwork.bsc.name, 'bsc');
        expect(BlockchainNetwork.avalanche.name, 'avalanche');
        expect(BlockchainNetwork.icp.name, 'icp');
        expect(BlockchainNetwork.near.name, 'near');
        expect(BlockchainNetwork.tron.name, 'tron');
        expect(BlockchainNetwork.custom.name, 'custom');
      });
    });

    group('TransactionStatus', () {
      test('should have correct enum values', () {
        expect(TransactionStatus.pending.name, 'pending');
        expect(TransactionStatus.confirmed.name, 'confirmed');
        expect(TransactionStatus.failed.name, 'failed');
        expect(TransactionStatus.cancelled.name, 'cancelled');
      });
    });

    group('ListingStatus', () {
      test('should have correct enum values', () {
        expect(ListingStatus.active.name, 'active');
        expect(ListingStatus.sold.name, 'sold');
        expect(ListingStatus.cancelled.name, 'cancelled');
        expect(ListingStatus.expired.name, 'expired');
      });
    });

    group('OfferStatus', () {
      test('should have correct enum values', () {
        expect(OfferStatus.pending.name, 'pending');
        expect(OfferStatus.accepted.name, 'accepted');
        expect(OfferStatus.rejected.name, 'rejected');
        expect(OfferStatus.expired.name, 'expired');
        expect(OfferStatus.cancelled.name, 'cancelled');
      });
    });

    group('NFTRarity', () {
      test('should have correct enum values', () {
        expect(NFTRarity.common.name, 'common');
        expect(NFTRarity.uncommon.name, 'uncommon');
        expect(NFTRarity.rare.name, 'rare');
        expect(NFTRarity.epic.name, 'epic');
        expect(NFTRarity.legendary.name, 'legendary');
        expect(NFTRarity.mythic.name, 'mythic');
      });
    });

    group('SupportedCurrency', () {
      test('should create currency with all properties', () {
        const currency = SupportedCurrency(
          symbol: 'ETH',
          name: 'Ethereum',
          contractAddress: '0x123',
          decimals: 18,
          network: BlockchainNetwork.ethereum,
        );

        expect(currency.symbol, 'ETH');
        expect(currency.name, 'Ethereum');
        expect(currency.contractAddress, '0x123');
        expect(currency.decimals, 18);
        expect(currency.network, BlockchainNetwork.ethereum);
      });

      test('should implement equality correctly', () {
        const currency1 = SupportedCurrency(
          symbol: 'ETH',
          name: 'Ethereum',
          contractAddress: '0x123',
          decimals: 18,
          network: BlockchainNetwork.ethereum,
        );

        const currency2 = SupportedCurrency(
          symbol: 'ETH',
          name: 'Ethereum',
          contractAddress: '0x123',
          decimals: 18,
          network: BlockchainNetwork.ethereum,
        );

        const currency3 = SupportedCurrency(
          symbol: 'SOL',
          name: 'Solana',
          contractAddress: '0x456',
          decimals: 9,
          network: BlockchainNetwork.solana,
        );

        expect(currency1, equals(currency2));
        expect(currency1, isNot(equals(currency3)));
      });

      test('should have correct props for equality', () {
        const currency = SupportedCurrency(
          symbol: 'ETH',
          name: 'Ethereum',
          contractAddress: '0x123',
          decimals: 18,
          network: BlockchainNetwork.ethereum,
        );

        expect(currency.props, [
          'ETH',
          'Ethereum',
          '0x123',
          18,
          BlockchainNetwork.ethereum,
        ]);
      });
    });

    group('Currency constants', () {
      test('should have correct ETH currency', () {
        expect(Currency.eth.symbol, 'ETH');
        expect(Currency.eth.name, 'Ethereum');
        expect(
          Currency.eth.contractAddress,
          '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        );
        expect(Currency.eth.decimals, 18);
        expect(Currency.eth.network, BlockchainNetwork.ethereum);
      });

      test('should have correct SOL currency', () {
        expect(Currency.sol.symbol, 'SOL');
        expect(Currency.sol.name, 'Solana');
        expect(Currency.sol.contractAddress, '');
        expect(Currency.sol.decimals, 9);
        expect(Currency.sol.network, BlockchainNetwork.solana);
      });

      test('should have correct ICP currency', () {
        expect(Currency.icp.symbol, 'ICP');
        expect(Currency.icp.name, 'Internet Computer Protocol');
        expect(Currency.icp.contractAddress, '');
        expect(Currency.icp.decimals, 8);
        expect(Currency.icp.network, BlockchainNetwork.icp);
      });

      test('should have correct MATIC currency', () {
        expect(Currency.matic.symbol, 'MATIC');
        expect(Currency.matic.name, 'Polygon');
        expect(
          Currency.matic.contractAddress,
          '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        );
        expect(Currency.matic.decimals, 18);
        expect(Currency.matic.network, BlockchainNetwork.polygon);
      });

      test('should have correct BNB currency', () {
        expect(Currency.bnb.symbol, 'BNB');
        expect(Currency.bnb.name, 'Binance Coin');
        expect(
          Currency.bnb.contractAddress,
          '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        );
        expect(Currency.bnb.decimals, 18);
        expect(Currency.bnb.network, BlockchainNetwork.bsc);
      });
    });

    group('NetworkConfig', () {
      test('should create network config with all properties', () {
        const config = NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
          additionalParams: {'explorer': 'https://etherscan.io'},
        );

        expect(config.name, 'Ethereum Mainnet');
        expect(config.rpcUrl, 'https://mainnet.infura.io');
        expect(config.chainId, '1');
        expect(config.network, BlockchainNetwork.ethereum);
        expect(config.isTestnet, false);
        expect(config.additionalParams, {'explorer': 'https://etherscan.io'});
      });

      test('should create network config with default additionalParams', () {
        const config = NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
        );

        expect(config.additionalParams, isEmpty);
      });

      test('should implement equality correctly', () {
        const config1 = NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
        );

        const config2 = NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
        );

        const config3 = NetworkConfig(
          name: 'Polygon Mainnet',
          rpcUrl: 'https://polygon-rpc.com',
          chainId: '137',
          network: BlockchainNetwork.polygon,
          isTestnet: false,
        );

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('should have correct props for equality', () {
        const config = NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
          additionalParams: {'explorer': 'https://etherscan.io'},
        );

        expect(config.props, [
          'Ethereum Mainnet',
          'https://mainnet.infura.io',
          '1',
          BlockchainNetwork.ethereum,
          false,
          {'explorer': 'https://etherscan.io'},
        ]);
      });
    });
  });
}
