import '../core/nft_types.dart';

/// Abstract interface for wallet operations across different blockchains
abstract class WalletProvider {
  /// Unique identifier for this provider
  String get id;

  /// Human-readable name of the provider
  String get name;

  /// Version of the provider
  String get version;

  /// Supported blockchain network
  BlockchainNetwork get network;

  /// Whether this provider is currently available
  bool get isAvailable;

  /// Whether wallet is connected
  bool get isConnected;

  /// Current connected address
  String? get connectedAddress;

  /// Get current address (alias for connectedAddress)
  String? get address => connectedAddress;

  /// Initialize the provider
  Future<void> initialize();

  /// Dispose the provider
  Future<void> dispose();

  /// Connect to wallet
  Future<bool> connect();

  /// Disconnect from wallet
  Future<void> disconnect();

  /// Get wallet address
  Future<String?> getAddress();

  /// Get wallet balance for a specific currency
  Future<double> getBalance(String currency);

  /// Get balances for multiple currencies
  Future<Map<String, double>> getBalances(List<String> currencies);

  /// Send transaction
  Future<String> sendTransaction({
    required String to,
    required double amount,
    required String currency,
    String? memo,
    Map<String, dynamic>? additionalParams,
  });

  /// Sign message
  Future<String> signMessage(String message);

  /// Sign transaction
  Future<String> signTransaction(Map<String, dynamic> transaction);

  /// Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    int? limit,
    int? offset,
  });

  /// Get transaction details
  Future<Map<String, dynamic>> getTransactionDetails(String transactionHash);

  /// Estimate transaction fees
  Future<double> estimateTransactionFee({
    required String to,
    required double amount,
    required String currency,
  });

  /// Switch network (if supported)
  Future<bool> switchNetwork(NetworkConfig networkConfig);

  /// Get current network configuration
  Future<NetworkConfig> getCurrentNetwork();

  /// Get supported networks
  List<NetworkConfig> getSupportedNetworks();

  /// Get wallet information
  Future<Map<String, dynamic>> getWalletInfo();

  /// Check if a currency is supported
  bool isCurrencySupported(String currency);

  /// Get supported currencies
  List<SupportedCurrency> getSupportedCurrencies();

  /// Request permissions (if needed)
  Future<bool> requestPermissions(List<String> permissions);

  /// Check if permissions are granted
  Future<bool> hasPermissions(List<String> permissions);
}
