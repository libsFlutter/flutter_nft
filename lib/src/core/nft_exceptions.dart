/// Base exception for all NFT operations
abstract class NFTException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const NFTException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'NFTException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when provider is not available or not initialized
class NFTProviderNotAvailableException extends NFTException {
  const NFTProviderNotAvailableException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when wallet is not connected
class WalletNotConnectedException extends NFTException {
  const WalletNotConnectedException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when transaction fails
class TransactionFailedException extends NFTException {
  const TransactionFailedException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when NFT operation fails
class NFTOperationException extends NFTException {
  const NFTOperationException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when marketplace operation fails
class MarketplaceException extends NFTException {
  const MarketplaceException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when network operation fails
class NetworkException extends NFTException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Exception thrown when validation fails
class ValidationException extends NFTException {
  const ValidationException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}
