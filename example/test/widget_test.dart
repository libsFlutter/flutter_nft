// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';

import 'package:flutter_nft_example/main.dart';

void main() {
  testWidgets('NFT Example App smoke test', (WidgetTester tester) async {
    // Create NFT client for testing
    final nftClient = NFTClient();
    await nftClient.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(nftClient: nftClient));

    // Verify that the app loads correctly
    expect(find.text('Flutter NFT Example'), findsOneWidget);
    expect(find.text('Flutter NFT Universal Library'), findsOneWidget);
    expect(find.text('Provider Statistics'), findsOneWidget);
  });
}
