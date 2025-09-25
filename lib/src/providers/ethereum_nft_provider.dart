import 'dart:convert';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_yuku/flutter_yuku.dart';
import '../core/nft_types.dart';
import '../core/nft_exceptions.dart';
import '../utils/nft_utils.dart';

/// Real Ethereum NFT Provider implementation
class EthereumNFTProvider implements NFTProvider {
  final String _id;
  final String _name;
  final String _version;
  final BlockchainNetwork _network;
  final String _rpcUrl;
  final String _ipfsGateway;
  final Web3Client? _client;
  final bool _isAvailable;

  EthereumNFTProvider({
    String? id,
    String? name,
    String? version,
    String? rpcUrl,
    String? ipfsGateway,
    Web3Client? client,
  }) : _id = id ?? 'ethereum-nft-provider',
       _name = name ?? 'Ethereum NFT Provider',
       _version = version ?? '1.0.0',
       _network = BlockchainNetwork.ethereum,
       _rpcUrl = rpcUrl ?? 'https://mainnet.infura.io/v3/YOUR_PROJECT_ID',
       _ipfsGateway = ipfsGateway ?? 'https://ipfs.io/ipfs/',
       _client = client,
       _isAvailable = true;

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

  Web3Client get client {
    if (_client != null) return _client!;
    return Web3Client(_rpcUrl, http.Client());
  }

  @override
  Future<void> initialize() async {
    // Initialize Web3 client if not provided
    if (_client == null) {
      await client.getNetworkId();
    }
  }

  @override
  Future<void> dispose() async {
    if (_client != null) {
      await _client!.dispose();
    }
  }

  @override
  Future<List<NFT>> getNFTsByOwner(String ownerAddress) async {
    try {
      final contract = await _getERC721Contract();
      final balance = await contract.call('balanceOf', [
        EthereumAddress.fromHex(ownerAddress),
      ]);

      final nfts = <NFT>[];
      for (int i = 0; i < balance.toInt(); i++) {
        try {
          final tokenId = await contract.call('tokenOfOwnerByIndex', [
            EthereumAddress.fromHex(ownerAddress),
            BigInt.from(i),
          ]);
          final nft = await _getNFTByTokenId(
            tokenId.toString(),
            contractAddress ?? '',
          );
          if (nft != null) {
            nfts.add(nft);
          }
        } catch (e) {
          // Skip invalid tokens
          continue;
        }
      }

      return nfts;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFTs by owner: $e');
    }
  }

  @override
  Future<NFT?> getNFT(String tokenId, String contractAddress) async {
    try {
      return await _getNFTByTokenId(tokenId, contractAddress);
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFT: $e');
    }
  }

  @override
  Future<List<NFT>> getNFTs(
    List<String> tokenIds,
    String contractAddress,
  ) async {
    try {
      final nfts = <NFT>[];
      for (final tokenId in tokenIds) {
        final nft = await _getNFTByTokenId(tokenId, contractAddress);
        if (nft != null) {
          nfts.add(nft);
        }
      }
      return nfts;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFTs: $e');
    }
  }

  @override
  Future<String> mintNFT({
    required String toAddress,
    required NFTMetadata metadata,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final tokenUri = await _uploadMetadataToIPFS(metadata);

      final transaction = await contract.send('mint', [
        EthereumAddress.fromHex(toAddress),
        tokenUri,
      ]);

      return transaction.hash;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to mint NFT: $e');
    }
  }

  @override
  Future<String> transferNFT({
    required String tokenId,
    required String fromAddress,
    required String toAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final transaction = await contract.send('transferFrom', [
        EthereumAddress.fromHex(fromAddress),
        EthereumAddress.fromHex(toAddress),
        BigInt.parse(tokenId),
      ]);

      return transaction.hash;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to transfer NFT: $e');
    }
  }

  @override
  Future<String> burnNFT({
    required String tokenId,
    required String ownerAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final transaction = await contract.send('burn', [BigInt.parse(tokenId)]);

      return transaction.hash;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to burn NFT: $e');
    }
  }

  @override
  Future<String> approveNFT({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final transaction = await contract.send('approve', [
        EthereumAddress.fromHex(approvedAddress),
        BigInt.parse(tokenId),
      ]);

      return transaction.hash;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to approve NFT: $e');
    }
  }

  @override
  Future<bool> isApproved({
    required String tokenId,
    required String ownerAddress,
    required String approvedAddress,
    required String contractAddress,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final approvedAddressResult = await contract.call('getApproved', [
        BigInt.parse(tokenId),
      ]);

      return approvedAddressResult.hex ==
          EthereumAddress.fromHex(approvedAddress).hex;
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to check approval: $e');
    }
  }

  @override
  Future<NFTMetadata> getNFTMetadata({
    required String tokenId,
    required String contractAddress,
  }) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final tokenUri = await contract.call('tokenURI', [BigInt.parse(tokenId)]);

      return await _fetchMetadataFromUri(tokenUri);
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get NFT metadata: $e');
    }
  }

  @override
  Future<bool> updateNFTMetadata({
    required String tokenId,
    required String ownerAddress,
    required NFTMetadata metadata,
    required String contractAddress,
  }) async {
    // ERC-721 doesn't support metadata updates by default
    // This would require a custom contract implementation
    throw NFTProviderNotAvailableException(
      'Metadata updates not supported for ERC-721',
    );
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    return [
      SupportedCurrency(
        symbol: 'ETH',
        name: 'Ethereum',
        decimals: 18,
        contractAddress: null,
      ),
      SupportedCurrency(
        symbol: 'WETH',
        name: 'Wrapped Ethereum',
        decimals: 18,
        contractAddress: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
      ),
    ];
  }

  @override
  Future<double> estimateTransactionFee({
    required String operation,
    required Map<String, dynamic> params,
  }) async {
    try {
      final gasPrice = await client.getGasPrice();
      final gasLimit = _getGasLimitForOperation(operation);

      return (gasPrice * gasLimit).toDouble() / 1e18; // Convert wei to ETH
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to estimate transaction fee: $e',
      );
    }
  }

  @override
  Future<TransactionStatus> getTransactionStatus(String transactionHash) async {
    try {
      final receipt = await client.getTransactionReceipt(transactionHash);

      if (receipt == null) {
        return TransactionStatus.pending;
      }

      return receipt.status == 1
          ? TransactionStatus.confirmed
          : TransactionStatus.failed;
    } catch (e) {
      throw NFTProviderNotAvailableException(
        'Failed to get transaction status: $e',
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
      throw NFTProviderNotAvailableException(
        'Failed to get transaction details: $e',
      );
    }
  }

  @override
  Future<List<NFT>> searchNFTs({
    String? name,
    String? description,
    Map<String, dynamic>? attributes,
    String? contractAddress,
    int? limit,
    int? offset,
  }) async {
    // This would require indexing service integration
    // For now, return empty list
    return [];
  }

  @override
  Future<Map<String, dynamic>> getContractInfo(String contractAddress) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final name = await contract.call('name', []);
      final symbol = await contract.call('symbol', []);
      final totalSupply = await contract.call('totalSupply', []);

      return {
        'name': name,
        'symbol': symbol,
        'totalSupply': totalSupply.toString(),
        'contractAddress': contractAddress,
        'network': _network.toString(),
      };
    } catch (e) {
      throw NFTProviderNotAvailableException('Failed to get contract info: $e');
    }
  }

  @override
  Future<bool> verifyContract(String contractAddress) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      await contract.name(); // Try to call a standard ERC-721 method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<NFT>> getOwnedNFTs(String address) => getNFTsByOwner(address);

  @override
  Future<bool> isValidContract(String contractAddress) =>
      verifyContract(contractAddress);

  // Private helper methods

  Future<DeployedContract> _getERC721Contract([String? contractAddress]) async {
    // ERC-721 ABI (simplified)
    final abi = jsonEncode([
      {
        "inputs": [
          {"name": "to", "type": "address"},
          {"name": "tokenURI", "type": "string"},
        ],
        "name": "mint",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "tokenURI",
        "outputs": [
          {"name": "", "type": "string"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "owner", "type": "address"},
        ],
        "name": "balanceOf",
        "outputs": [
          {"name": "", "type": "uint256"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "owner", "type": "address"},
          {"name": "index", "type": "uint256"},
        ],
        "name": "tokenOfOwnerByIndex",
        "outputs": [
          {"name": "", "type": "uint256"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "ownerOf",
        "outputs": [
          {"name": "", "type": "address"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "from", "type": "address"},
          {"name": "to", "type": "address"},
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "transferFrom",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "to", "type": "address"},
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "approve",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "getApproved",
        "outputs": [
          {"name": "", "type": "address"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [
          {"name": "tokenId", "type": "uint256"},
        ],
        "name": "burn",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
      },
      {
        "inputs": [],
        "name": "name",
        "outputs": [
          {"name": "", "type": "string"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [],
        "name": "symbol",
        "outputs": [
          {"name": "", "type": "string"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
      {
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
          {"name": "", "type": "uint256"},
        ],
        "stateMutability": "view",
        "type": "function",
      },
    ]);

    final contractAbi = ContractAbi.fromJson(abi, 'ERC721');
    final address = contractAddress != null
        ? EthereumAddress.fromHex(contractAddress)
        : EthereumAddress.zero();

    return DeployedContract(contractAbi, address);
  }

  Future<NFT?> _getNFTByTokenId(String tokenId, String contractAddress) async {
    try {
      final contract = await _getERC721Contract(contractAddress);
      final owner = await contract.call('ownerOf', [BigInt.parse(tokenId)]);
      final tokenUri = await contract.call('tokenURI', [BigInt.parse(tokenId)]);

      final metadata = await _fetchMetadataFromUri(tokenUri);

      return NFT(
        id: tokenId,
        tokenId: tokenId,
        contractAddress: contractAddress,
        owner: owner.hex,
        creator: owner.hex, // Would need to track creator separately
        network: _network,
        metadata: metadata,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        transactionHistory: [],
      );
    } catch (e) {
      return null;
    }
  }

  Future<NFTMetadata> _fetchMetadataFromUri(String uri) async {
    try {
      String metadataUri = uri;

      // Handle IPFS URIs
      if (uri.startsWith('ipfs://')) {
        metadataUri = uri.replaceFirst('ipfs://', '$_ipfsGateway');
      }

      final response = await http.get(Uri.parse(metadataUri));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return NFTMetadata.fromJson(json);
      } else {
        throw Exception('Failed to fetch metadata: ${response.statusCode}');
      }
    } catch (e) {
      // Return default metadata if fetch fails
      return NFTMetadata(
        name: 'Unknown NFT',
        description: 'Metadata unavailable',
        image: '',
        attributes: {},
        properties: {},
      );
    }
  }

  Future<String> _uploadMetadataToIPFS(NFTMetadata metadata) async {
    // This would require IPFS integration
    // For now, return a mock IPFS hash
    final metadataJson = jsonEncode(metadata.toJson());
    final bytes = utf8.encode(metadataJson);
    final hash = sha256.convert(bytes);
    return 'ipfs://${hash.toString()}';
  }

  BigInt _getGasLimitForOperation(String operation) {
    switch (operation) {
      case 'mint':
        return BigInt.from(200000);
      case 'transfer':
        return BigInt.from(100000);
      case 'approve':
        return BigInt.from(50000);
      case 'burn':
        return BigInt.from(100000);
      default:
        return BigInt.from(100000);
    }
  }
}
