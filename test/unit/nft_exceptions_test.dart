import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

void main() {
  group('NFT Exceptions Tests', () {
    group('NFTException', () {
      test('should create NFTProviderNotAvailableException with message only',
          () {
        const exception =
            NFTProviderNotAvailableException('Provider not found');

        expect(exception.message, 'Provider not found');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Provider not found');
      });

      test(
          'should create NFTProviderNotAvailableException with message and code',
          () {
        const exception = NFTProviderNotAvailableException(
          'Provider not found',
          code: 'PROVIDER_NOT_FOUND',
        );

        expect(exception.message, 'Provider not found');
        expect(exception.code, 'PROVIDER_NOT_FOUND');
        expect(exception.toString(),
            'NFTException: Provider not found (Code: PROVIDER_NOT_FOUND)');
      });

      test(
          'should create NFTProviderNotAvailableException with message, code, and original error',
          () {
        final originalError = Exception('Original error');
        final exception = NFTProviderNotAvailableException(
          'Provider not found',
          code: 'PROVIDER_NOT_FOUND',
          originalError: originalError,
        );

        expect(exception.message, 'Provider not found');
        expect(exception.code, 'PROVIDER_NOT_FOUND');
        expect(exception.originalError, originalError);
        expect(exception.toString(),
            'NFTException: Provider not found (Code: PROVIDER_NOT_FOUND)');
      });

      test('should implement Exception interface', () {
        const exception = NFTProviderNotAvailableException('Test error');
        expect(exception, isA<Exception>());
        expect(exception, isA<NFTException>());
      });
    });

    group('NFTProviderNotAvailableException', () {
      test('should create exception with message only', () {
        const exception =
            NFTProviderNotAvailableException('Provider not found');

        expect(exception.message, 'Provider not found');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Provider not found');
      });

      test('should create exception with message and code', () {
        const exception = NFTProviderNotAvailableException(
          'Provider not found',
          code: 'PROVIDER_NOT_FOUND',
        );

        expect(exception.message, 'Provider not found');
        expect(exception.code, 'PROVIDER_NOT_FOUND');
        expect(exception.toString(),
            'NFTException: Provider not found (Code: PROVIDER_NOT_FOUND)');
      });

      test('should extend NFTException', () {
        const exception =
            NFTProviderNotAvailableException('Provider not found');
        expect(exception, isA<NFTException>());
      });
    });

    group('WalletNotConnectedException', () {
      test('should create exception with message only', () {
        const exception = WalletNotConnectedException('Wallet not connected');

        expect(exception.message, 'Wallet not connected');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Wallet not connected');
      });

      test('should create exception with message and code', () {
        const exception = WalletNotConnectedException(
          'Wallet not connected',
          code: 'WALLET_NOT_CONNECTED',
        );

        expect(exception.message, 'Wallet not connected');
        expect(exception.code, 'WALLET_NOT_CONNECTED');
        expect(exception.toString(),
            'NFTException: Wallet not connected (Code: WALLET_NOT_CONNECTED)');
      });

      test('should extend NFTException', () {
        const exception = WalletNotConnectedException('Wallet not connected');
        expect(exception, isA<NFTException>());
      });
    });

    group('TransactionFailedException', () {
      test('should create exception with message only', () {
        const exception = TransactionFailedException('Transaction failed');

        expect(exception.message, 'Transaction failed');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Transaction failed');
      });

      test('should create exception with message and code', () {
        const exception = TransactionFailedException(
          'Transaction failed',
          code: 'TX_FAILED',
        );

        expect(exception.message, 'Transaction failed');
        expect(exception.code, 'TX_FAILED');
        expect(exception.toString(),
            'NFTException: Transaction failed (Code: TX_FAILED)');
      });

      test('should extend NFTException', () {
        const exception = TransactionFailedException('Transaction failed');
        expect(exception, isA<NFTException>());
      });
    });

    group('NFTOperationException', () {
      test('should create exception with message only', () {
        const exception = NFTOperationException('NFT operation failed');

        expect(exception.message, 'NFT operation failed');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: NFT operation failed');
      });

      test('should create exception with message and code', () {
        const exception = NFTOperationException(
          'NFT operation failed',
          code: 'NFT_OP_FAILED',
        );

        expect(exception.message, 'NFT operation failed');
        expect(exception.code, 'NFT_OP_FAILED');
        expect(exception.toString(),
            'NFTException: NFT operation failed (Code: NFT_OP_FAILED)');
      });

      test('should extend NFTException', () {
        const exception = NFTOperationException('NFT operation failed');
        expect(exception, isA<NFTException>());
      });
    });

    group('MarketplaceException', () {
      test('should create exception with message only', () {
        const exception = MarketplaceException('Marketplace error');

        expect(exception.message, 'Marketplace error');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Marketplace error');
      });

      test('should create exception with message and code', () {
        const exception = MarketplaceException(
          'Marketplace error',
          code: 'MARKETPLACE_ERROR',
        );

        expect(exception.message, 'Marketplace error');
        expect(exception.code, 'MARKETPLACE_ERROR');
        expect(exception.toString(),
            'NFTException: Marketplace error (Code: MARKETPLACE_ERROR)');
      });

      test('should extend NFTException', () {
        const exception = MarketplaceException('Marketplace error');
        expect(exception, isA<NFTException>());
      });
    });

    group('NetworkException', () {
      test('should create exception with message only', () {
        const exception = NetworkException('Network error');

        expect(exception.message, 'Network error');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Network error');
      });

      test('should create exception with message and code', () {
        const exception = NetworkException(
          'Network error',
          code: 'NETWORK_ERROR',
        );

        expect(exception.message, 'Network error');
        expect(exception.code, 'NETWORK_ERROR');
        expect(exception.toString(),
            'NFTException: Network error (Code: NETWORK_ERROR)');
      });

      test('should extend NFTException', () {
        const exception = NetworkException('Network error');
        expect(exception, isA<NFTException>());
      });
    });

    group('ValidationException', () {
      test('should create exception with message only', () {
        const exception = ValidationException('Validation failed');

        expect(exception.message, 'Validation failed');
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
        expect(exception.toString(), 'NFTException: Validation failed');
      });

      test('should create exception with message and code', () {
        const exception = ValidationException(
          'Validation failed',
          code: 'VALIDATION_ERROR',
        );

        expect(exception.message, 'Validation failed');
        expect(exception.code, 'VALIDATION_ERROR');
        expect(exception.toString(),
            'NFTException: Validation failed (Code: VALIDATION_ERROR)');
      });

      test('should extend NFTException', () {
        const exception = ValidationException('Validation failed');
        expect(exception, isA<NFTException>());
      });
    });
  });
}
