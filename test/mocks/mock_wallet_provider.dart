import 'package:flutter_nft/flutter_nft.dart';

/// Mock Wallet Provider for testing
class MockWalletProvider implements WalletProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final bool _isAvailable;
  final bool _isConnected;
  final String? _connectedAddress;
  final bool _shouldThrowError;

  MockWalletProvider({
    String? id,
    String? name,
    String? version,
    BlockchainNetwork? network,
    bool isAvailable = true,
    bool isConnected = false,
    String? connectedAddress,
    bool shouldThrowError = false,
  })  : _id = id ?? 'mock-wallet-provider',
        _name = name ?? 'Mock Wallet Provider',
        _version = version ?? '1.0.0',
        _network = network ?? BlockchainNetwork.ethereum,
        _isAvailable = isAvailable,
        _isConnected = isConnected,
        _connectedAddress = connectedAddress,
        _shouldThrowError = shouldThrowError;

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
  bool get isConnected => _isConnected;

  @override
  String? get connectedAddress => _connectedAddress;

  @override
  Future<void> initialize() async {
    if (_shouldThrowError) {
      throw Exception('Mock initialization error');
    }
    // Mock initialization
  }

  @override
  Future<void> dispose() async {
    // Mock disposal
  }

  @override
  Future<bool> connect() async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock connection error');
    }
    return true;
  }

  @override
  Future<void> disconnect() async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock disconnection error');
    }
    // Mock disconnection
  }

  @override
  Future<String?> getAddress() async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock address error');
    }
    return _connectedAddress ?? '0x1234567890123456789012345678901234567890';
  }

  @override
  Future<double> getBalance(String currency) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock balance error');
    }
    return 1.5;
  }

  @override
  Future<Map<String, double>> getBalances(List<String> currencies) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock balances error');
    }
    final balances = <String, double>{};
    for (final currency in currencies) {
      balances[currency] = 1.5;
    }
    return balances;
  }

  @override
  Future<String> sendTransaction({
    required String to,
    required double amount,
    required String currency,
    String? memo,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (_shouldThrowError) {
      throw TransactionFailedException('Mock transaction error');
    }
    return 'mock-tx-hash-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> signMessage(String message) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock signing error');
    }
    return 'mock-signature-${message.hashCode}';
  }

  @override
  Future<String> signTransaction(Map<String, dynamic> transaction) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock signing error');
    }
    return 'mock-signed-tx-${transaction.hashCode}';
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    int? limit,
    int? offset,
  }) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock history error');
    }
    return [
      {
        'hash': 'mock-tx-1',
        'from': '0x123',
        'to': '0x456',
        'amount': 1.0,
        'currency': 'ETH',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(
      String transactionHash) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock details error');
    }
    return {
      'hash': transactionHash,
      'from': '0x123',
      'to': '0x456',
      'amount': 1.0,
      'currency': 'ETH',
      'status': 'confirmed',
      'blockNumber': 12345,
    };
  }

  @override
  Future<double> estimateTransactionFee({
    required String to,
    required double amount,
    required String currency,
  }) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock fee error');
    }
    return 0.001;
  }

  @override
  Future<bool> switchNetwork(NetworkConfig networkConfig) async {
    if (_shouldThrowError) {
      throw NetworkException('Mock network switch error');
    }
    return true;
  }

  @override
  Future<NetworkConfig> getCurrentNetwork() async {
    if (_shouldThrowError) {
      throw NetworkException('Mock network error');
    }
    return NetworkConfig(
      name: 'Mock Network',
      rpcUrl: 'https://mock.rpc.url',
      chainId: '1',
      network: _network,
      isTestnet: false,
    );
  }

  @override
  List<NetworkConfig> getSupportedNetworks() {
    return [
      NetworkConfig(
        name: 'Mock Network',
        rpcUrl: 'https://mock.rpc.url',
        chainId: '1',
        network: _network,
        isTestnet: false,
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> getWalletInfo() async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock info error');
    }
    return {
      'provider': _name,
      'version': _version,
      'network': _network.name,
      'connected': _isConnected,
      'address': _connectedAddress,
    };
  }

  @override
  bool isCurrencySupported(String currency) {
    return ['ETH', 'SOL', 'ICP'].contains(currency.toUpperCase());
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [Currency.eth, Currency.sol, Currency.icp];
  }

  @override
  Future<bool> requestPermissions(List<String> permissions) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock permissions error');
    }
    return true;
  }

  @override
  Future<bool> hasPermissions(List<String> permissions) async {
    if (_shouldThrowError) {
      throw WalletNotConnectedException('Mock permissions error');
    }
    return true;
  }
}
