import 'package:crypto/crypto.dart';
import 'dart:convert';
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
  static String formatAddress(String address, {int startChars = 6, int endChars = 4}) {
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
    final randomTraits = traits ?? [
      'Color', 'Background', 'Eyes', 'Mouth', 'Hat', 'Accessory',
      'Personality', 'Power', 'Speed', 'Intelligence'
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
        final colors = ['Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Pink', 'Black'];
        return colors[random % colors.length];
      case 'background':
        final backgrounds = ['Sky', 'Ocean', 'Forest', 'City', 'Space', 'Desert', 'Mountain'];
        return backgrounds[random % backgrounds.length];
      case 'eyes':
        final eyes = ['Normal', 'Laser', 'Fire', 'Ice', 'Electric', 'Cosmic'];
        return eyes[random % eyes.length];
      case 'mouth':
        final mouths = ['Smile', 'Frown', 'Open', 'Closed', 'Tongue', 'Teeth'];
        return mouths[random % mouths.length];
      case 'hat':
        final hats = ['None', 'Cap', 'Helmet', 'Crown', 'Wizard Hat', 'Baseball Cap'];
        return hats[random % hats.length];
      case 'accessory':
        final accessories = ['None', 'Glasses', 'Watch', 'Necklace', 'Ring', 'Bracelet'];
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
    if (!metadata.containsKey('description') || metadata['description'] == null) return false;
    if (!metadata.containsKey('image') || metadata['image'] == null) return false;
    
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
}
