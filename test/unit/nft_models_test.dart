import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

void main() {
  group('NFT Models Tests', () {
    group('NFTMetadata', () {
      test('should create NFTMetadata with required fields', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        expect(metadata.name, 'Test NFT');
        expect(metadata.description, 'A test NFT');
        expect(metadata.image, 'https://example.com/image.png');
        expect(metadata.attributes, {'rarity': 'common'});
        expect(metadata.properties, {'type': 'digital'});
        expect(metadata.categories, isEmpty);
      });

      test('should create NFTMetadata with all fields', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          externalUrl: 'https://example.com',
          animationUrl: 'https://example.com/animation.mp4',
          youtubeUrl: 'https://youtube.com/watch?v=123',
          backgroundColor: '#FFFFFF',
          attributes: {'rarity': 'rare'},
          properties: {'type': 'digital'},
          categories: ['art', 'digital'],
          creator: {'name': 'Artist'},
          collection: {'name': 'Test Collection'},
          royalties: {'percentage': 2.5},
        );

        expect(metadata.externalUrl, 'https://example.com');
        expect(metadata.animationUrl, 'https://example.com/animation.mp4');
        expect(metadata.youtubeUrl, 'https://youtube.com/watch?v=123');
        expect(metadata.backgroundColor, '#FFFFFF');
        expect(metadata.categories, ['art', 'digital']);
        expect(metadata.creator, {'name': 'Artist'});
        expect(metadata.collection, {'name': 'Test Collection'});
        expect(metadata.royalties, {'percentage': 2.5});
      });

      test('should implement equality correctly', () {
        final metadata1 = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        final metadata2 = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        final metadata3 = NFTMetadata(
          name: 'Different NFT',
          description: 'A different NFT',
          image: 'https://example.com/different.png',
          attributes: {'rarity': 'rare'},
          properties: {'type': 'physical'},
        );

        expect(metadata1, equals(metadata2));
        expect(metadata1, isNot(equals(metadata3)));
      });

      test('should create copy with updated fields', () {
        final original = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        final updated = original.copyWith(
          name: 'Updated NFT',
          description: 'An updated NFT',
          attributes: {'rarity': 'rare'},
        );

        expect(updated.name, 'Updated NFT');
        expect(updated.description, 'An updated NFT');
        expect(updated.image, 'https://example.com/image.png');
        expect(updated.attributes, {'rarity': 'rare'});
        expect(updated.properties, {'type': 'digital'});
      });

      test('should get attribute by key', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common', 'power': 100},
          properties: {'type': 'digital'},
        );

        expect(metadata.getAttribute('rarity'), 'common');
        expect(metadata.getAttribute('power'), 100);
        expect(metadata.getAttribute('nonexistent'), isNull);
      });

      test('should get property by key', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital', 'category': 'art'},
        );

        expect(metadata.getProperty('type'), 'digital');
        expect(metadata.getProperty('category'), 'art');
        expect(metadata.getProperty('nonexistent'), isNull);
      });

      test('should check if has animation', () {
        final metadataWithoutAnimation = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        final metadataWithAnimation = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          animationUrl: 'https://example.com/animation.mp4',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        expect(metadataWithoutAnimation.hasAnimation, isFalse);
        expect(metadataWithAnimation.hasAnimation, isTrue);
      });

      test('should check if has external URL', () {
        final metadataWithoutUrl = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        final metadataWithUrl = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          externalUrl: 'https://example.com',
          attributes: {'rarity': 'common'},
          properties: {'type': 'digital'},
        );

        expect(metadataWithoutUrl.hasExternalUrl, isFalse);
        expect(metadataWithUrl.hasExternalUrl, isTrue);
      });

      test('should get formatted attributes', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common', 'power': 100},
          properties: {'type': 'digital'},
        );

        final formatted = metadata.formattedAttributes;
        expect(formatted.length, 2);
        expect(formatted, isA<List<Map<String, dynamic>>>());
        expect(formatted.length, 2);
      });

      test('should calculate rarity score', () {
        final metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'common', 'power': 100},
          properties: {'type': 'digital'},
        );

        final score = metadata.rarityScore;
        expect(score, isA<double>());
        expect(score, greaterThan(0));
      });
    });

    group('NFT', () {
      late NFTMetadata metadata;
      late NFT nft;

      setUp(() {
        metadata = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'rarity': 'rare'},
          properties: {'type': 'digital'},
        );

        nft = NFT(
          id: 'nft-1',
          tokenId: '1',
          contractAddress: '0x123',
          network: BlockchainNetwork.ethereum,
          metadata: metadata,
          owner: '0x456',
          creator: '0x789',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          status: 'active',
          currentValue: 1.5,
          valueCurrency: 'ETH',
          transactionHistory: ['tx1', 'tx2'],
        );
      });

      test('should create NFT with all fields', () {
        expect(nft.id, 'nft-1');
        expect(nft.tokenId, '1');
        expect(nft.contractAddress, '0x123');
        expect(nft.network, BlockchainNetwork.ethereum);
        expect(nft.metadata, metadata);
        expect(nft.owner, '0x456');
        expect(nft.creator, '0x789');
        expect(nft.status, 'active');
        expect(nft.currentValue, 1.5);
        expect(nft.valueCurrency, 'ETH');
        expect(nft.transactionHistory, ['tx1', 'tx2']);
      });

      test('should implement equality correctly', () {
        final nft2 = NFT(
          id: 'nft-1',
          tokenId: '1',
          contractAddress: '0x123',
          network: BlockchainNetwork.ethereum,
          metadata: metadata,
          owner: '0x456',
          creator: '0x789',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          status: 'active',
          currentValue: 1.5,
          valueCurrency: 'ETH',
          transactionHistory: ['tx1', 'tx2'],
        );

        final nft3 = NFT(
          id: 'nft-2',
          tokenId: '2',
          contractAddress: '0x456',
          network: BlockchainNetwork.solana,
          metadata: metadata,
          owner: '0x789',
          creator: '0x012',
          createdAt: DateTime(2023, 2, 1),
          updatedAt: DateTime(2023, 2, 2),
          status: 'sold',
          transactionHistory: ['tx3'],
        );

        expect(nft, equals(nft2));
        expect(nft, isNot(equals(nft3)));
      });

      test('should create copy with updated fields', () {
        final updated = nft.copyWith(
          owner: '0x999',
          status: 'sold',
          currentValue: 2.0,
        );

        expect(updated.owner, '0x999');
        expect(updated.status, 'sold');
        expect(updated.currentValue, 2.0);
        expect(updated.id, 'nft-1'); // Unchanged
        expect(updated.tokenId, '1'); // Unchanged
      });

      test('should check if owned by address', () {
        expect(nft.isOwnedBy('0x456'), isTrue);
        expect(nft.isOwnedBy('0X456'), isTrue); // Case insensitive
        expect(nft.isOwnedBy('0x789'), isFalse);
      });

      test('should check if created by address', () {
        expect(nft.isCreatedBy('0x789'), isTrue);
        expect(nft.isCreatedBy('0X789'), isTrue); // Case insensitive
        expect(nft.isCreatedBy('0x456'), isFalse);
      });

      test('should get rarity from metadata', () {
        // The NFT uses metadata with 'rarity': 'rare' but the getter looks for 'Rarity'
        final metadataWithRarity =
            metadata.copyWith(attributes: {'Rarity': 'rare'});
        final nftWithRarity = nft.copyWith(metadata: metadataWithRarity);
        expect(nftWithRarity.rarity, NFTRarity.rare);
      });

      test('should get default rarity when not specified', () {
        final metadataWithoutRarity = NFTMetadata(
          name: 'Test NFT',
          description: 'A test NFT',
          image: 'https://example.com/image.png',
          attributes: {'power': 100},
          properties: {'type': 'digital'},
        );

        final nftWithoutRarity = nft.copyWith(metadata: metadataWithoutRarity);
        expect(nftWithoutRarity.rarity, NFTRarity.common);
      });

      test('should get formatted value', () {
        expect(nft.formattedValue, '1.5000 ETH');
      });

      test('should get N/A for formatted value when value is null', () {
        final nftWithoutValue = NFT(
          id: 'nft-no-value',
          tokenId: '1',
          contractAddress: '0x123',
          owner: '0x456',
          creator: '0x789',
          network: BlockchainNetwork.ethereum,
          metadata: metadata,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: 'active',
          currentValue: null, // No value
          valueCurrency: null, // No currency
          transactionHistory: ['tx1'],
        );
        expect(nftWithoutValue.formattedValue, 'N/A');
      });
    });

    group('NFTListing', () {
      late NFTListing listing;

      setUp(() {
        listing = NFTListing(
          id: 'listing-1',
          nftId: 'nft-1',
          contractAddress: '0x123',
          network: BlockchainNetwork.ethereum,
          price: 1.5,
          currency: 'ETH',
          sellerAddress: '0x456',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          expiresAt: DateTime.now().add(Duration(days: 7)),
          status: ListingStatus.active,
          marketplaceProvider: 'opensea',
        );
      });

      test('should create NFTListing with all fields', () {
        expect(listing.id, 'listing-1');
        expect(listing.nftId, 'nft-1');
        expect(listing.contractAddress, '0x123');
        expect(listing.network, BlockchainNetwork.ethereum);
        expect(listing.price, 1.5);
        expect(listing.currency, 'ETH');
        expect(listing.sellerAddress, '0x456');
        expect(listing.status, ListingStatus.active);
        expect(listing.marketplaceProvider, 'opensea');
      });

      test('should implement equality correctly', () {
        final listing2 = listing.copyWith(); // Same as original

        final listing3 = NFTListing(
          id: 'listing-2',
          nftId: 'nft-2',
          contractAddress: '0x456',
          network: BlockchainNetwork.solana,
          price: 2.0,
          currency: 'SOL',
          sellerAddress: '0x789',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          status: ListingStatus.sold,
          marketplaceProvider: 'magiceden',
        );

        expect(listing, equals(listing2));
        expect(listing, isNot(equals(listing3)));
      });

      test('should create copy with updated fields', () {
        final updated = listing.copyWith(
          status: ListingStatus.sold,
          buyerAddress: '0x999',
          soldAt: DateTime(2023, 1, 5),
        );

        expect(updated.status, ListingStatus.sold);
        expect(updated.buyerAddress, '0x999');
        expect(updated.soldAt, DateTime(2023, 1, 5));
        expect(updated.id, 'listing-1'); // Unchanged
        expect(updated.price, 1.5); // Unchanged
      });

      test('should check if listing is active', () {
        expect(listing.isActive, isTrue);

        final soldListing = listing.copyWith(status: ListingStatus.sold);
        expect(soldListing.isActive, isFalse);
      });

      test('should check if listing is expired', () {
        final futureListing = listing.copyWith(
          expiresAt: DateTime.now().add(Duration(days: 1)),
        );
        expect(futureListing.isExpired, isFalse);

        final pastListing = listing.copyWith(
          expiresAt: DateTime.now().subtract(Duration(days: 1)),
        );
        expect(pastListing.isExpired, isTrue);

        final noExpirationListing = listing.copyWith(expiresAt: null);
        expect(noExpirationListing.isExpired, isFalse);

        // The original listing has expiresAt set to 7 days from now, which is in the future
        expect(listing.isExpired, isFalse);
      });

      test('should check if listing is sold', () {
        expect(listing.isSold, isFalse);

        final soldListing = listing.copyWith(status: ListingStatus.sold);
        expect(soldListing.isSold, isTrue);
      });

      test('should get formatted price', () {
        expect(listing.formattedPrice, '1.5000 ETH');
      });

      test('should get time until expiration', () {
        final futureListing = listing.copyWith(
          expiresAt:
              DateTime.now().add(Duration(days: 1, hours: 2, minutes: 30)),
        );

        final duration = futureListing.timeUntilExpiration;
        expect(duration, isNotNull);
        expect(duration!.inDays, 1);
        expect(duration.inHours % 24, 2);
        // Allow for small time differences due to test execution time
        expect(duration.inMinutes % 60, greaterThanOrEqualTo(29));
        expect(duration.inMinutes % 60, lessThanOrEqualTo(31));

        // Create a new listing without expiration
        final noExpirationListing = NFTListing(
          id: 'no-expiration-listing',
          nftId: 'nft-1',
          contractAddress: '0x123',
          network: BlockchainNetwork.ethereum,
          price: 1.5,
          currency: 'ETH',
          sellerAddress: '0x456',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          expiresAt: null, // No expiration
          status: ListingStatus.active,
          marketplaceProvider: 'opensea',
        );
        expect(noExpirationListing.timeUntilExpiration, isNull);

        // Test with the original listing (should have time until expiration)
        final originalDuration = listing.timeUntilExpiration;
        expect(originalDuration, isNotNull);
        expect(originalDuration!.inDays, greaterThan(0));
      });

      test('should get formatted time until expiration', () {
        final futureListing = listing.copyWith(
          expiresAt:
              DateTime.now().add(Duration(days: 1, hours: 2, minutes: 30)),
        );

        final formatted = futureListing.formattedTimeUntilExpiration;
        expect(formatted, contains('1d'));
        expect(formatted, contains('2h'));
        // Allow for small time differences due to test execution time
        expect(formatted, matches(r'\d+m'));

        // Create a new listing without expiration
        final noExpirationListing = NFTListing(
          id: 'no-expiration-listing',
          nftId: 'nft-1',
          contractAddress: '0x123',
          network: BlockchainNetwork.ethereum,
          price: 1.5,
          currency: 'ETH',
          sellerAddress: '0x456',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          expiresAt: null, // No expiration
          status: ListingStatus.active,
          marketplaceProvider: 'opensea',
        );
        expect(
            noExpirationListing.formattedTimeUntilExpiration, 'No expiration');

        // Test with the original listing (should show time until expiration)
        final originalFormatted = listing.formattedTimeUntilExpiration;
        expect(originalFormatted, isNot(equals('No expiration')));
        expect(originalFormatted, isNot(equals('Expired')));

        final expiredListing = listing.copyWith(
          expiresAt: DateTime.now().subtract(Duration(days: 1)),
        );
        expect(expiredListing.formattedTimeUntilExpiration, 'Expired');
      });
    });
  });
}
