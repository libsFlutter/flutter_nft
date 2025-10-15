import 'dart:convert';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_yuku/flutter_yuku.dart';

/// Real Ethereum Wallet Provider implementation
class EthereumWalletProvider implements WalletProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final String _rpcUrl;
  final Web3Client? _client;
  final bool _isAvailable;
  final Credentials? _credentials;

  bool _isConnected = false;
  String? _connectedAddress;

  EthereumWalletProvider({
    String? id,
    String? name,
    String? version,
    String? rpcUrl,
    Web3Client? client,
    Credentials? credentials,
  })  : _id = id ?? 'ethereum-wallet-provider',
        _name = name ?? 'Ethereum Wallet Provider',
        _version = version ?? '1.0.0',
        _network = BlockchainNetwork.ethereum,
        _rpcUrl = rpcUrl ?? 'https://mainnet.infura.io/v3/YOUR_PROJECT_ID',
        _client = client,
        _isAvailable = true,
        _credentials = credentials;

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

  Web3Client get client {
    if (_client != null) return _client!;
    return Web3Client(_rpcUrl, http.Client());
  }

  @override
  Future<void> initialize() async {
    // Load saved wallet connection state
    final prefs = await SharedPreferences.getInstance();
    _isConnected = prefs.getBool('${_id}_connected') ?? false;
    _connectedAddress = prefs.getString('${_id}_address');

    if (_isConnected && _connectedAddress != null) {
      // Verify connection is still valid
      try {
        await client.getBalance(EthereumAddress.fromHex(_connectedAddress!));
      } catch (e) {
        // Connection is invalid, reset state
        _isConnected = false;
        _connectedAddress = null;
        await _saveConnectionState();
      }
    }
  }

  @override
  Future<void> dispose() async {
    if (_client != null) {
      await _client!.dispose();
    }
  }

  @override
  Future<bool> connect() async {
    try {
      if (_credentials != null) {
        // Use provided credentials
        _connectedAddress = _credentials!.address.hex;
        _isConnected = true;
        await _saveConnectionState();
        return true;
      }

      // For now, throw an exception as we need external wallet integration
      // In a real implementation, this would integrate with MetaMask, WalletConnect, etc.
      throw WalletNotConnectedException(
        'No wallet credentials provided. Please integrate with MetaMask or WalletConnect.',
      );
    } catch (e) {
      throw WalletNotConnectedException('Failed to connect wallet: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _connectedAddress = null;
    await _saveConnectionState();
  }

  @override
  Future<String?> getAddress() async {
    if (!_isConnected) {
      throw WalletNotConnectedException('Wallet not connected');
    }
    return _connectedAddress;
  }

  @override
  Future<double> getBalance(String currency) async {
    if (!_isConnected || _connectedAddress == null) {
      throw WalletNotConnectedException('Wallet not connected');
    }

    try {
      if (currency.toUpperCase() == 'ETH') {
        final balance = await client.getBalance(
          EthereumAddress.fromHex(_connectedAddress!),
        );
        return balance.getInWei.toDouble() / 1e18; // Convert wei to ETH
      } else {
        // Handle ERC-20 tokens
        return await _getERC20Balance(currency, _connectedAddress!);
      }
    } catch (e) {
      throw WalletNotConnectedException('Failed to get balance: $e');
    }
  }

  @override
  Future<Map<String, double>> getBalances(List<String> currencies) async {
    final balances = <String, double>{};

    for (final currency in currencies) {
      try {
        balances[currency] = await getBalance(currency);
      } catch (e) {
        balances[currency] = 0.0;
      }
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
    if (!_isConnected || _credentials == null) {
      throw WalletNotConnectedException('Wallet not connected');
    }

    try {
      if (currency.toUpperCase() == 'ETH') {
        // Send ETH
        final transaction = Transaction(
          to: EthereumAddress.fromHex(to),
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
          gasPrice: await client.getGasPrice(),
          maxGas: 21000,
        );

        final txHash = await client.sendTransaction(
          _credentials!,
          transaction,
          chainId: 1, // Ethereum mainnet
        );

        return txHash;
      } else {
        // Send ERC-20 token
        return await _sendERC20Token(to, amount, currency);
      }
    } catch (e) {
      throw WalletNotConnectedException('Failed to send transaction: $e');
    }
  }

  @override
  Future<String> signMessage(String message) async {
    if (!_isConnected || _credentials == null) {
      throw WalletNotConnectedException('Wallet not connected');
    }

    try {
      final messageBytes = utf8.encode(message);
      final signature = await _credentials!.signPersonalMessage(messageBytes);
      return '0x${signature.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
    } catch (e) {
      throw WalletNotConnectedException('Failed to sign message: $e');
    }
  }

  @override
  Future<String> signTransaction(Map<String, dynamic> transaction) async {
    if (!_isConnected || _credentials == null) {
      throw WalletNotConnectedException('Wallet not connected');
    }

    try {
      final tx = Transaction(
        to: EthereumAddress.fromHex(transaction['to']),
        value: EtherAmount.fromUnitAndValue(
          EtherUnit.ether,
          transaction['value'] ?? 0.0,
        ),
        gasPrice: EtherAmount.fromUnitAndValue(
          EtherUnit.gwei,
          transaction['gasPrice'] ?? 20,
        ),
        maxGas: transaction['gasLimit'] ?? 21000,
        data: transaction['data'] != null
            ? Uint8List.fromList(transaction['data'].codeUnits)
            : null,
      );

      final signature = await _credentials!.signTransaction(tx);
      return '0x${signature.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
    } catch (e) {
      throw WalletNotConnectedException('Failed to sign transaction: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    int? limit,
    int? offset,
  }) async {
    if (!_isConnected || _connectedAddress == null) {
      throw WalletNotConnectedException('Wallet not connected');
    }

    try {
      // This would require integration with a blockchain explorer API
      // For now, return empty list
      return [];
    } catch (e) {
      throw WalletNotConnectedException(
        'Failed to get transaction history: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(
    String transactionHash,
  ) async {
    try {
      final transaction = await client.getTransactionByHash(transactionHash);
      final receipt = await client.getTransactionReceipt(transactionHash);

      return {
        'hash': transactionHash,
        'from': transaction?.from?.hex,
        'to': transaction?.to?.hex,
        'value': transaction?.value?.toString(),
        'gas': transaction?.gas?.toString(),
        'gasPrice': transaction?.gasPrice?.toString(),
        'status': receipt?.status == 1 ? 'success' : 'failed',
        'blockNumber': receipt?.blockNumber?.toString(),
        'blockHash': receipt?.blockHash?.hex,
      };
    } catch (e) {
      throw WalletNotConnectedException(
        'Failed to get transaction details: $e',
      );
    }
  }

  @override
  Future<double> estimateTransactionFee({
    required String to,
    required double amount,
    required String currency,
  }) async {
    try {
      final gasPrice = await client.getGasPrice();
      final gasLimit = currency.toUpperCase() == 'ETH' ? 21000 : 100000;

      return (gasPrice * gasLimit).toDouble() / 1e18; // Convert wei to ETH
    } catch (e) {
      throw WalletNotConnectedException(
        'Failed to estimate transaction fee: $e',
      );
    }
  }

  @override
  Future<bool> switchNetwork(NetworkConfig networkConfig) async {
    // Ethereum wallet doesn't support network switching
    // This would be handled by the external wallet (MetaMask, etc.)
    return false;
  }

  // Private helper methods

  Future<void> _saveConnectionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_id}_connected', _isConnected);
    if (_connectedAddress != null) {
      await prefs.setString('${_id}_address', _connectedAddress!);
    } else {
      await prefs.remove('${_id}_address');
    }
  }

  Future<double> _getERC20Balance(
    String tokenAddress,
    String walletAddress,
  ) async {
    try {
      // ERC-20 balanceOf ABI
      final abi = jsonEncode([
        {
          "inputs": [
            {"name": "account", "type": "address"},
          ],
          "name": "balanceOf",
          "outputs": [
            {"name": "", "type": "uint256"},
          ],
          "stateMutability": "view",
          "type": "function",
        },
        {
          "inputs": [],
          "name": "decimals",
          "outputs": [
            {"name": "", "type": "uint8"},
          ],
          "stateMutability": "view",
          "type": "function",
        },
      ]);

      final contractAbi = ContractAbi.fromJson(abi, 'ERC20');
      final contract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(tokenAddress),
      );

      final balanceFunction = contract.function('balanceOf');
      final decimalsFunction = contract.function('decimals');

      final balanceResult = await client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(walletAddress)],
      );

      final decimalsResult = await client.call(
        contract: contract,
        function: decimalsFunction,
        params: [],
      );

      final balance = balanceResult.first as BigInt;
      final decimals = decimalsResult.first as int;

      return balance.toDouble() / (10 * decimals);
    } catch (e) {
      return 0.0;
    }
  }

  Future<String> _sendERC20Token(
    String to,
    double amount,
    String tokenAddress,
  ) async {
    try {
      // ERC-20 transfer ABI
      final abi = jsonEncode([
        {
          "inputs": [
            {"name": "to", "type": "address"},
            {"name": "amount", "type": "uint256"},
          ],
          "name": "transfer",
          "outputs": [
            {"name": "", "type": "bool"},
          ],
          "stateMutability": "nonpayable",
          "type": "function",
        },
        {
          "inputs": [],
          "name": "decimals",
          "outputs": [
            {"name": "", "type": "uint8"},
          ],
          "stateMutability": "view",
          "type": "function",
        },
      ]);

      final contractAbi = ContractAbi.fromJson(abi, 'ERC20');
      final contract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(tokenAddress),
      );

      final decimalsFunction = contract.function('decimals');
      final decimalsResult = await client.call(
        contract: contract,
        function: decimalsFunction,
        params: [],
      );

      final decimals = decimalsResult.first as int;
      final amountInWei = BigInt.from(amount * (10 * decimals));

      final transferFunction = contract.function('transfer');
      final transaction = Transaction.callContract(
        contract: contract,
        function: transferFunction,
        parameters: [EthereumAddress.fromHex(to), amountInWei],
        gasPrice: await client.getGasPrice(),
        maxGas: 100000,
      );

      final txHash = await client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return txHash;
    } catch (e) {
      throw WalletNotConnectedException('Failed to send ERC-20 token: $e');
    }
  }
}
