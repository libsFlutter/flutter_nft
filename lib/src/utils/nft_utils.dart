import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/nft_types.dart';

/// Utility functions for NFT operations
class NFTUtils {
  NFTUtils._();

  /// Generate a unique NFT ID
  static String generateNFTId({
    required String tokenId,
    required String contractAddress,
    required BlockchainNetwork network,
  }) {
    final data = '${tokenId}_${contractAddress}_${network.name}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate Ethereum address
  static bool isValidEthereumAddress(String address) {
    if (!address.startsWith('0x')) return false;
    if (address.length != 42) return false;

    try {
      // Check if it's a valid hex string
      int.parse(address.substring(2), radix: 16);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate Solana address
  static bool isValidSolanaAddress(String address) {
    // Solana addresses are base58 encoded and typically 32-44 characters
    if (address.length < 32 || address.length > 44) return false;

    // Check if it contains only base58 characters
    final base58Pattern = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    return base58Pattern.hasMatch(address);
  }

  /// Validate ICP principal ID
  static bool isValidICPPrincipal(String principal) {
    // ICP principal IDs are base32 encoded
    if (principal.length < 10 || principal.length > 63) return false;

    // Check if it contains only base32 characters (excluding 0, 1, 8, 9)
    final base32Pattern = RegExp(r'^[2-7a-z]+$');
    return base32Pattern.hasMatch(principal.toLowerCase());
  }

  /// Format address for display
  static String formatAddress(
    String address, {
    int startChars = 6,
    int endChars = 4,
  }) {
    if (address.length <= startChars + endChars) return address;
    return '${address.substring(0, startChars)}...${address.substring(address.length - endChars)}';
  }

  /// Format price for display
  static String formatPrice(double price, String currency, {int decimals = 4}) {
    return '${price.toStringAsFixed(decimals)} $currency';
  }

  /// Convert wei to ether
  static double weiToEther(BigInt wei) {
    return wei.toDouble() / BigInt.from(10).pow(18).toDouble();
  }

  /// Convert ether to wei
  static BigInt etherToWei(double ether) {
    return BigInt.from((ether * BigInt.from(10).pow(18).toDouble()).round());
  }

  /// Convert lamports to SOL
  static double lamportsToSol(BigInt lamports) {
    return lamports.toDouble() / BigInt.from(10).pow(9).toDouble();
  }

  /// Convert SOL to lamports
  static BigInt solToLamports(double sol) {
    return BigInt.from((sol * BigInt.from(10).pow(9).toDouble()).round());
  }

  /// Convert e8s to ICP
  static double e8sToICP(BigInt e8s) {
    return e8s.toDouble() / BigInt.from(10).pow(8).toDouble();
  }

  /// Convert ICP to e8s
  static BigInt icpToE8s(double icp) {
    return BigInt.from((icp * BigInt.from(10).pow(8).toDouble()).round());
  }

  /// Get network display name
  static String getNetworkDisplayName(BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.ethereum:
        return 'Ethereum';
      case BlockchainNetwork.solana:
        return 'Solana';
      case BlockchainNetwork.polygon:
        return 'Polygon';
      case BlockchainNetwork.bsc:
        return 'BSC';
      case BlockchainNetwork.avalanche:
        return 'Avalanche';
      case BlockchainNetwork.icp:
        return 'Internet Computer';
      case BlockchainNetwork.near:
        return 'NEAR';
      case BlockchainNetwork.tron:
        return 'TRON';
      case BlockchainNetwork.custom:
        return 'Custom';
    }
  }

  /// Get network currency symbol
  static String getNetworkCurrency(BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.ethereum:
        return 'ETH';
      case BlockchainNetwork.solana:
        return 'SOL';
      case BlockchainNetwork.polygon:
        return 'MATIC';
      case BlockchainNetwork.bsc:
        return 'BNB';
      case BlockchainNetwork.avalanche:
        return 'AVAX';
      case BlockchainNetwork.icp:
        return 'ICP';
      case BlockchainNetwork.near:
        return 'NEAR';
      case BlockchainNetwork.tron:
        return 'TRX';
      case BlockchainNetwork.custom:
        return 'TOKEN';
    }
  }

  /// Calculate rarity score based on attributes
  static double calculateRarityScore(Map<String, dynamic> attributes) {
    double score = 0.0;

    for (final entry in attributes.entries) {
      final value = entry.value;
      if (value is num) {
        score += value.toDouble();
      } else if (value is String) {
        // Higher score for longer, more complex strings
        score += value.length * 0.1;
      }
    }

    return score;
  }

  /// Determine rarity level from score
  static NFTRarity determineRarity(double score) {
    if (score >= 100) return NFTRarity.mythic;
    if (score >= 75) return NFTRarity.legendary;
    if (score >= 50) return NFTRarity.epic;
    if (score >= 25) return NFTRarity.rare;
    if (score >= 10) return NFTRarity.uncommon;
    return NFTRarity.common;
  }

  /// Generate random NFT metadata
  static Map<String, dynamic> generateRandomMetadata({
    required String name,
    required String description,
    required String imageUrl,
    List<String>? traits,
  }) {
    final randomTraits =
        traits ??
        [
          'Color',
          'Background',
          'Eyes',
          'Mouth',
          'Hat',
          'Accessory',
          'Personality',
          'Power',
          'Speed',
          'Intelligence',
        ];

    final attributes = <String, dynamic>{};
    final random = DateTime.now().millisecondsSinceEpoch;

    for (final trait in randomTraits) {
      final traitValue = _generateRandomTraitValue(trait, random);
      attributes[trait] = traitValue;
    }

    return {
      'name': name,
      'description': description,
      'image': imageUrl,
      'attributes': attributes,
      'properties': {
        'rarity_score': calculateRarityScore(attributes),
        'generated_at': DateTime.now().toIso8601String(),
      },
    };
  }

  /// Generate random trait value
  static dynamic _generateRandomTraitValue(String trait, int seed) {
    final random = seed % 100;

    switch (trait.toLowerCase()) {
      case 'color':
        final colors = [
          'Red',
          'Blue',
          'Green',
          'Yellow',
          'Purple',
          'Orange',
          'Pink',
          'Black',
        ];
        return colors[random % colors.length];
      case 'background':
        final backgrounds = [
          'Sky',
          'Ocean',
          'Forest',
          'City',
          'Space',
          'Desert',
          'Mountain',
        ];
        return backgrounds[random % backgrounds.length];
      case 'eyes':
        final eyes = ['Normal', 'Laser', 'Fire', 'Ice', 'Electric', 'Cosmic'];
        return eyes[random % eyes.length];
      case 'mouth':
        final mouths = ['Smile', 'Frown', 'Open', 'Closed', 'Tongue', 'Teeth'];
        return mouths[random % mouths.length];
      case 'hat':
        final hats = [
          'None',
          'Cap',
          'Helmet',
          'Crown',
          'Wizard Hat',
          'Baseball Cap',
        ];
        return hats[random % hats.length];
      case 'accessory':
        final accessories = [
          'None',
          'Glasses',
          'Watch',
          'Necklace',
          'Ring',
          'Bracelet',
        ];
        return accessories[random % accessories.length];
      default:
        // Numeric traits
        if (random < 10) return 'Legendary';
        if (random < 30) return 'Epic';
        if (random < 60) return 'Rare';
        if (random < 80) return 'Uncommon';
        return 'Common';
    }
  }

  /// Validate NFT metadata
  static bool isValidMetadata(Map<String, dynamic> metadata) {
    // Check required fields
    if (!metadata.containsKey('name') || metadata['name'] == null) return false;
    if (!metadata.containsKey('description') || metadata['description'] == null) {
      return false;
    }
    if (!metadata.containsKey('image') || metadata['image'] == null) {
      return false;
    }

    // Validate types
    if (metadata['name'] is! String) return false;
    if (metadata['description'] is! String) return false;
    if (metadata['image'] is! String) return false;

    return true;
  }

  /// Calculate gas estimate for different operations
  static Map<String, int> getGasEstimates(BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.ethereum:
        return {
          'transfer': 21000,
          'mint': 150000,
          'approve': 45000,
          'list': 120000,
          'buy': 180000,
        };
      case BlockchainNetwork.polygon:
        return {
          'transfer': 21000,
          'mint': 150000,
          'approve': 45000,
          'list': 120000,
          'buy': 180000,
        };
      case BlockchainNetwork.bsc:
        return {
          'transfer': 21000,
          'mint': 150000,
          'approve': 45000,
          'list': 120000,
          'buy': 180000,
        };
      default:
        return {
          'transfer': 1000,
          'mint': 5000,
          'approve': 2000,
          'list': 3000,
          'buy': 4000,
        };
    }
  }

  /// Upload metadata to IPFS
  static Future<String> uploadToIPFS(
    Map<String, dynamic> metadata, {
    String? gateway,
  }) async {
    try {
      final gatewayUrl = gateway ?? 'https://ipfs.io/api/v0/add';
      final metadataJson = jsonEncode(metadata);
      final bytes = utf8.encode(metadataJson);

      final request = http.MultipartRequest('POST', Uri.parse(gatewayUrl));
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: 'metadata.json'),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final result = jsonDecode(responseBody) as Map<String, dynamic>;
        return 'ipfs://${result['Hash']}';
      } else {
        throw Exception('Failed to upload to IPFS: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local hash generation
      final metadataJson = jsonEncode(metadata);
      final bytes = utf8.encode(metadataJson);
      final hash = sha256.convert(bytes);
      return 'ipfs://${hash.toString()}';
    }
  }

  /// Fetch metadata from IPFS
  static Future<Map<String, dynamic>> fetchFromIPFS(
    String ipfsHash, {
    String? gateway,
  }) async {
    try {
      String url = ipfsHash;
      if (ipfsHash.startsWith('ipfs://')) {
        final gatewayUrl = gateway ?? 'https://ipfs.io/ipfs/';
        url = ipfsHash.replaceFirst('ipfs://', gatewayUrl);
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch from IPFS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch from IPFS: $e');
    }
  }

  /// Calculate price in different currencies
  static double convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) {
    // This would require integration with price APIs
    // For now, return mock conversion rates
    final rates = {
      'ETH': 1.0,
      'MATIC': 0.8,
      'SOL': 0.05,
      'USDC': 2000.0,
      'USDT': 2000.0,
    };

    final fromRate = rates[fromCurrency.toUpperCase()] ?? 1.0;
    final toRate = rates[toCurrency.toUpperCase()] ?? 1.0;

    return amount * fromRate / toRate;
  }

  /// Generate collection statistics
  static Map<String, dynamic> generateCollectionStats(
    List<Map<String, dynamic>> nfts,
  ) {
    if (nfts.isEmpty) {
      return {
        'totalSupply': 0,
        'floorPrice': 0.0,
        'averagePrice': 0.0,
        'totalVolume': 0.0,
        'rarityDistribution': {},
      };
    }

    final prices = nfts
        .where((nft) => nft['price'] != null && nft['price'] > 0)
        .map((nft) => nft['price'] as double)
        .toList();

    final floorPrice = prices.isNotEmpty ? prices.reduce(min) : 0.0;
    final averagePrice = prices.isNotEmpty
        ? prices.reduce((a, b) => a + b) / prices.length
        : 0.0;

    final rarityDistribution = <String, int>{};
    for (final nft in nfts) {
      final rarity = nft['rarity'] as String? ?? 'common';
      rarityDistribution[rarity] = (rarityDistribution[rarity] ?? 0) + 1;
    }

    return {
      'totalSupply': nfts.length,
      'floorPrice': floorPrice,
      'averagePrice': averagePrice,
      'totalVolume': prices.reduce((a, b) => a + b),
      'rarityDistribution': rarityDistribution,
    };
  }

  /// Validate transaction hash
  static bool isValidTransactionHash(String hash, BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.ethereum:
      case BlockchainNetwork.polygon:
      case BlockchainNetwork.bsc:
      case BlockchainNetwork.avalanche:
        return hash.startsWith('0x') && hash.length == 66;
      case BlockchainNetwork.solana:
        return hash.length >= 80 && hash.length <= 90;
      case BlockchainNetwork.icp:
        return hash.length >= 40 && hash.length <= 60;
      case BlockchainNetwork.near:
        return hash.length >= 40 && hash.length <= 60;
      case BlockchainNetwork.tron:
        return hash.startsWith('0x') && hash.length == 66;
      default:
        return hash.isNotEmpty;
    }
  }

  /// Generate QR code data for NFT
  static String generateQRData(
    String nftId,
    String contractAddress,
    BlockchainNetwork network,
  ) {
    return jsonEncode({
      'nftId': nftId,
      'contractAddress': contractAddress,
      'network': network.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Parse QR code data
  static Map<String, dynamic>? parseQRData(String qrData) {
    try {
      return jsonDecode(qrData) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Calculate network fees for different operations
  static Map<String, double> calculateNetworkFees(
    BlockchainNetwork network,
    String operation,
  ) {
    final gasEstimates = getGasEstimates(network);
    final gasLimit = gasEstimates[operation] ?? 100000;

    // Mock gas prices (in Gwei for EVM chains, in native units for others)
    final gasPrices = {
      BlockchainNetwork.ethereum: 20.0,
      BlockchainNetwork.polygon: 30.0,
      BlockchainNetwork.bsc: 5.0,
      BlockchainNetwork.avalanche: 25.0,
      BlockchainNetwork.solana: 0.000005,
      BlockchainNetwork.icp: 0.0001,
      BlockchainNetwork.near: 0.0001,
      BlockchainNetwork.tron: 0.1,
    };

    final gasPrice = gasPrices[network] ?? 1.0;
    final fee = gasLimit * gasPrice;

    return {
      'gasLimit': gasLimit.toDouble(),
      'gasPrice': gasPrice,
      'totalFee': fee,
      'currency': getNetworkCurrency(network),
    };
  }

  /// Generate random seed for deterministic randomness
  static int generateSeed(String input) {
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 8).hashCode;
  }

  /// Shuffle list deterministically based on seed
  static List<T> deterministicShuffle<T>(List<T> list, int seed) {
    final random = Random(seed);
    final shuffled = List<T>.from(list);

    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// Calculate hash of metadata for uniqueness
  static String calculateMetadataHash(Map<String, dynamic> metadata) {
    final sortedKeys = metadata.keys.toList()..sort();
    final sortedMetadata = <String, dynamic>{};

    for (final key in sortedKeys) {
      sortedMetadata[key] = metadata[key];
    }

    final jsonString = jsonEncode(sortedMetadata);
    final bytes = utf8.encode(jsonString);
    final hash = sha256.convert(bytes);

    return hash.toString();
  }

  /// Check if two NFTs are identical
  static bool areNFTsIdentical(
    Map<String, dynamic> nft1,
    Map<String, dynamic> nft2,
  ) {
    final hash1 = calculateMetadataHash(nft1);
    final hash2 = calculateMetadataHash(nft2);
    return hash1 == hash2;
  }

  /// Generate collection slug from name
  static String generateCollectionSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  /// Validate collection slug
  static bool isValidCollectionSlug(String slug) {
    return RegExp(r'^[a-z0-9-]+$').hasMatch(slug) &&
        slug.length >= 3 &&
        slug.length <= 50;
  }
}
