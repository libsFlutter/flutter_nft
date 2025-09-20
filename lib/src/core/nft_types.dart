import 'package:equatable/equatable.dart';

/// Supported blockchain networks
enum BlockchainNetwork {
  ethereum,
  solana,
  polygon,
  bsc,
  avalanche,
  icp, // Internet Computer Protocol
  near,
  tron,
  custom,
}

/// NFT transaction status
enum TransactionStatus {
  pending,
  confirmed,
  failed,
  cancelled,
}

/// NFT listing status
enum ListingStatus {
  active,
  sold,
  cancelled,
  expired,
}

/// NFT offer status
enum OfferStatus {
  pending,
  accepted,
  rejected,
  expired,
  cancelled,
}

/// NFT rarity levels
enum NFTRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,
}

/// Supported currencies for NFT transactions
class SupportedCurrency extends Equatable {
  final String symbol;
  final String name;
  final String contractAddress; // For ERC-20 tokens
  final int decimals;
  final BlockchainNetwork network;

  const SupportedCurrency({
    required this.symbol,
    required this.name,
    required this.contractAddress,
    required this.decimals,
    required this.network,
  });

  @override
  List<Object?> get props => [symbol, name, contractAddress, decimals, network];
}

/// Common supported currencies
class Currency {
  static const eth = SupportedCurrency(
    symbol: 'ETH',
    name: 'Ethereum',
    contractAddress: '',
    decimals: 18,
    network: BlockchainNetwork.ethereum,
  );

  static const sol = SupportedCurrency(
    symbol: 'SOL',
    name: 'Solana',
    contractAddress: '',
    decimals: 9,
    network: BlockchainNetwork.solana,
  );

  static const icp = SupportedCurrency(
    symbol: 'ICP',
    name: 'Internet Computer Protocol',
    contractAddress: '',
    decimals: 8,
    network: BlockchainNetwork.icp,
  );

  static const matic = SupportedCurrency(
    symbol: 'MATIC',
    name: 'Polygon',
    contractAddress: '',
    decimals: 18,
    network: BlockchainNetwork.polygon,
  );

  static const bnb = SupportedCurrency(
    symbol: 'BNB',
    name: 'Binance Coin',
    contractAddress: '',
    decimals: 18,
    network: BlockchainNetwork.bsc,
  );
}

/// Network configuration
class NetworkConfig extends Equatable {
  final String name;
  final String rpcUrl;
  final String chainId;
  final BlockchainNetwork network;
  final bool isTestnet;
  final Map<String, dynamic> additionalParams;

  const NetworkConfig({
    required this.name,
    required this.rpcUrl,
    required this.chainId,
    required this.network,
    required this.isTestnet,
    this.additionalParams = const {},
  });

  @override
  List<Object?> get props => [name, rpcUrl, chainId, network, isTestnet, additionalParams];
}
