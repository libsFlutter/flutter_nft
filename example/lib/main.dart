import 'package:flutter/material.dart';
import 'package:flutter_nft/flutter_nft.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create NFT client
  final nftClient = NFTClient();
  
  // Note: In a real app, you would register providers here
  // nftClient.registerNFTProvider(YourNFTProvider());
  // nftClient.registerWalletProvider(YourWalletProvider());
  // nftClient.registerMarketplaceProvider(YourMarketplaceProvider());
  
  // Initialize all providers
  await nftClient.initialize();
  
  runApp(MyApp(nftClient: nftClient));
}

class MyApp extends StatelessWidget {
  final NFTClient nftClient;

  const MyApp({super.key, required this.nftClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NFT Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: NFTExampleScreen(nftClient: nftClient),
    );
  }
}

class NFTExampleScreen extends StatefulWidget {
  final NFTClient nftClient;

  const NFTExampleScreen({super.key, required this.nftClient});

  @override
  State<NFTExampleScreen> createState() => _NFTExampleScreenState();
}

class _NFTExampleScreenState extends State<NFTExampleScreen> {
  List<BlockchainNetwork> supportedNetworks = [];
  Map<String, dynamic> providerStats = {};
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProviderInfo();
  }

  Future<void> _loadProviderInfo() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final networks = widget.nftClient.getSupportedNetworks();
      final stats = widget.nftClient.getProviderStats();
      
      setState(() {
        supportedNetworks = networks.toList();
        providerStats = stats;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load provider info: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter NFT Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter NFT Universal Library',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example demonstrates the flutter_nft library architecture. '
                      'To see actual functionality, register blockchain providers.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Provider Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (providerStats.isNotEmpty) ...[
                      _buildStatItem('NFT Providers', providerStats['nftProviders']?['total'] ?? 0),
                      _buildStatItem('Wallet Providers', providerStats['walletProviders']?['total'] ?? 0),
                      _buildStatItem('Marketplace Providers', providerStats['marketplaceProviders']?['total'] ?? 0),
                    ] else
                      const Text('No providers registered'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Supported Networks
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Networks',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (supportedNetworks.isNotEmpty) ...[
                      ...supportedNetworks.map((network) => 
                        Chip(
                          label: Text(network.name),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ] else
                      const Text('No networks supported'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Error Display
            if (error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Loading Indicator
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            
            // Content
            if (!isLoading) ...[
              // Architecture Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Architecture Overview',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The flutter_nft library uses a provider-based architecture:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('• NFTProvider - Blockchain-specific NFT operations'),
                      const Text('• WalletProvider - Wallet connectivity'),
                      const Text('• MarketplaceProvider - Marketplace operations'),
                      const SizedBox(height: 16),
                      const Text(
                        'To add support for a new blockchain:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Implement the required provider interfaces'),
                      const Text('2. Register providers with NFTClient'),
                      const Text('3. Initialize the client'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Example Code
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example Usage',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '''
// Register providers
nftClient.registerNFTProvider(YourNFTProvider());
nftClient.registerWalletProvider(YourWalletProvider());
nftClient.registerMarketplaceProvider(YourMarketplaceProvider());

// Initialize
await nftClient.initialize();

// Use providers
final nftProvider = nftClient.getNFTProvider(BlockchainNetwork.yourNetwork);
final nfts = await nftProvider.getNFTsByOwner(address);
                          ''',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Available Providers
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Providers',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text('• flutter_icp - Internet Computer Protocol support'),
                      const Text('• Your custom provider - Add your blockchain here'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProviderInfo,
                        child: const Text('Refresh Provider Info'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
