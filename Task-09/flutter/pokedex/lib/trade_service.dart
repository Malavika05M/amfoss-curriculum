import 'package:cloud_firestore/cloud_firestore.dart';

class TradeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new trade
  Future<void> createTrade({
    required String senderId,
    required String receiverId,
    required String offeredPokemonId,
    required String requestedPokemonId,
  }) async {
    await _firestore.collection('trades').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'offeredPokemonId': offeredPokemonId,
      'requestedPokemonId': requestedPokemonId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Accept a trade
  Future<void> acceptTrade(String tradeId) async {
    await _firestore.collection('trades').doc(tradeId).update({
      'status': 'accepted',
    });
  }

  // Reject a trade
  Future<void> rejectTrade(String tradeId) async {
    await _firestore.collection('trades').doc(tradeId).update({
      'status': 'rejected',
    });
  }

  // Stream of active trades for current user
  // Get all trades involving the user (both sent and received)
  Stream<QuerySnapshot> getAllUserTrades(String userId) {
    return _firestore
        .collection('trades')
        .where('status', whereIn: ['pending', 'accepted', 'rejected'])
        .where('senderId', isEqualTo: userId)
        .snapshots();
  }

// Complete a trade (transfer Pokémon)
  Future<void> completeTrade(String tradeId) async {
    final tradeDoc = await _firestore.collection('trades').doc(tradeId).get();
    final trade = tradeDoc.data()!;

    // Remove offered Pokémon from sender
    await _firestore.collection('users').doc(trade['senderId']).update({
      'pokemonCollection': FieldValue.arrayRemove([trade['offeredPokemonId']]),
    });

    // Add offered Pokémon to receiver
    await _firestore.collection('users').doc(trade['receiverId']).update({
      'pokemonCollection': FieldValue.arrayUnion([trade['offeredPokemonId']]),
    });

    // Do the reverse for requested Pokémon
    await _firestore.collection('users').doc(trade['senderId']).update({
      'pokemonCollection': FieldValue.arrayUnion([trade['requestedPokemonId']]),
    });

    await _firestore.collection('users').doc(trade['receiverId']).update({
      'pokemonCollection': FieldValue.arrayRemove([trade['requestedPokemonId']]),
    });
  }
}