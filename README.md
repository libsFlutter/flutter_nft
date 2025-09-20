# Flutter NFT

A universal Flutter library for NFT operations across multiple blockchains.

## Features

- 🌐 **Multi-blockchain support** - Works with Ethereum, Solana, Polygon, BSC, ICP, and more
- 🔌 **Pluggable architecture** - Easy to add new blockchain providers
- 💼 **Wallet integration** - Unified interface for different wallet providers
- 🛒 **Marketplace support** - Trade NFTs across different marketplaces
- 🔒 **Type-safe** - Full type safety with Dart's type system
- 📱 **Cross-platform** - Works on iOS, Android, Web, and Desktop

## Supported Blockchains

- ✅ Ethereum
- ✅ Solana
- ✅ Polygon
- ✅ BSC (Binance Smart Chain)
- ✅ Internet Computer Protocol (ICP)
- ✅ NEAR Protocol
- ✅ TRON
- ✅ Custom networks

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_nft: ^1.0.0
```

## Quick Start

### 1. Initialize the NFT Client

```dart
import 'package:flutter_nft/flutter_nft.dart';

void main() async {
  // Create NFT client
  final nftClient = NFTClient();
  
  // Register providers (e.g., ICP provider)
  nftClient.registerNFTProvider(ICPProvider());
  nftClient.registerWalletProvider(PlugWalletProvider());
  nftClient.registerMarketplaceProvider(YukuProvider());
  
  // Initialize all providers
  await nftClient.initialize();
  
  runApp(MyApp());
}
```

### 2. Connect to Wallet

```dart
// Get wallet provider for ICP
final walletProvider = nftClient.getWalletProvider(BlockchainNetwork.icp);

// Connect to wallet
final isConnected = await walletProvider.connect();
if (isConnected) {
  final address = await walletProvider.getAddress();
  print('Connected to: $address');
}
```

### 3. Get User's NFTs

```dart
// Get NFT provider for ICP
final nftProvider = nftClient.getNFTProvider(BlockchainNetwork.icp);

// Get user's NFTs
final nfts = await nftProvider.getNFTsByOwner(userAddress);
print('Found ${nfts.length} NFTs');
```

### 4. Mint an NFT

```dart
// Create NFT metadata
final metadata = NFTMetadata(
  name: 'My Awesome NFT',
  description: 'This is a description of my NFT',
  image: 'https://example.com/image.png',
  attributes: {
    'Color': 'Blue',
    'Rarity': 'Rare',
  },
  properties: {
    'created_by': 'MyApp',
  },
);

// Mint the NFT
final transactionHash = await nftProvider.mintNFT(
  toAddress: userAddress,
  metadata: metadata,
  contractAddress: 'your-contract-address',
);
```

### 5. List NFT on Marketplace

```dart
// Get marketplace provider
final marketplaceProvider = nftClient.getMarketplaceProvider(BlockchainNetwork.icp);

// Create listing
final listingId = await marketplaceProvider.createListing(
  nftId: nft.tokenId,
  contractAddress: nft.contractAddress,
  price: 100.0,
  currency: 'ICP',
  sellerAddress: userAddress,
);
```

## Architecture

The library follows a provider-based architecture:

```
NFTClient
├── NFTProvider (blockchain-specific NFT operations)
├── WalletProvider (wallet connectivity)
└── MarketplaceProvider (marketplace operations)
```

### Provider Interface

```dart
abstract class NFTProvider {
  String get id;
  String get name;
  BlockchainNetwork get network;
  
  Future<List<NFT>> getNFTsByOwner(String ownerAddress);
  Future<String> mintNFT({...});
  Future<String> transferNFT({...});
  // ... more methods
}
```

## Adding Custom Providers

### 1. Implement NFTProvider

```dart
class MyCustomNFTProvider implements NFTProvider {
  @override
  String get id => 'my-custom-provider';
  
  @override
  String get name => 'My Custom Provider';
  
  @override
  BlockchainNetwork get network => BlockchainNetwork.custom;
  
  @override
  Future<List<NFT>> getNFTsByOwner(String ownerAddress) async {
    // Your implementation
  }
  
  // ... implement other methods
}
```

### 2. Register Provider

```dart
final nftClient = NFTClient();
nftClient.registerNFTProvider(MyCustomNFTProvider());
```

## Available Providers

### ICP Provider (flutter_icp)

```dart
dependencies:
  flutter_nft: ^1.0.0
  flutter_icp: ^1.0.0
```

```dart
import 'package:flutter_icp/flutter_icp.dart';

// Register ICP providers
nftClient.registerNFTProvider(ICPNFTProvider());
nftClient.registerWalletProvider(PlugWalletProvider());
nftClient.registerMarketplaceProvider(YukuProvider());
```

## Error Handling

The library provides specific exception types:

```dart
try {
  final nfts = await nftProvider.getNFTsByOwner(address);
} on WalletNotConnectedException catch (e) {
  // Handle wallet not connected
} on TransactionFailedException catch (e) {
  // Handle transaction failure
} on NFTProviderNotAvailableException catch (e) {
  // Handle provider not available
}
```

## Examples

Check out the `example/` directory for complete examples:

- Basic NFT operations
- Wallet integration
- Marketplace trading
- Custom provider implementation

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the NativeMindNONC License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://docs.flutter-nft.dev)
- 💬 [Discord Community](https://discord.gg/flutter-nft)
- 🐛 [Issue Tracker](https://github.com/your-org/flutter_nft/issues)
- 📧 [Email Support](mailto:support@flutter-nft.dev)