import 'rag_models.dart';
import 'embedding_service.dart';

/// In-memory vector store for document storage and retrieval
class VectorStore {
  final List<RAGDocument> _documents = [];
  final EmbeddingService _embeddingService;
  
  VectorStore(this._embeddingService);

  /// Add a document to the vector store
  Future<void> addDocument(RAGDocument document) async {
    // Generate embedding if not provided
    if (document.embedding == null) {
      final embedding = _embeddingService.generateEmbedding(document.content);
      final docWithEmbedding = document.copyWith(embedding: embedding);
      _documents.add(docWithEmbedding);
    } else {
      _documents.add(document);
    }
  }

  /// Add multiple documents
  Future<void> addDocuments(List<RAGDocument> documents) async {
    for (final doc in documents) {
      await addDocument(doc);
    }
  }

  /// Search for similar documents using vector similarity
  Future<List<SearchResult>> search(
    String query, {
    int topK = 5,
    double minScore = 0.0,
  }) async {
    if (_documents.isEmpty) {
      return [];
    }

    // Generate query embedding
    final queryEmbedding = _embeddingService.generateEmbedding(query);

    // Calculate similarities
    final results = <SearchResult>[];
    
    for (final doc in _documents) {
      if (doc.embedding == null) continue;
      
      final similarity = _embeddingService.cosineSimilarity(
        queryEmbedding,
        doc.embedding!,
      );
      
      if (similarity >= minScore) {
        results.add(SearchResult(
          document: doc,
          score: similarity,
        ));
      }
    }

    // Sort by score (descending) and take top K
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(topK).toList();
  }

  /// Hybrid search combining vector similarity and keyword matching
  Future<List<SearchResult>> hybridSearch(
    String query, {
    int topK = 5,
    double vectorWeight = 0.7,
    double keywordWeight = 0.3,
  }) async {
    if (_documents.isEmpty) {
      return [];
    }

    final queryEmbedding = _embeddingService.generateEmbedding(query);
    final queryLower = query.toLowerCase();
    final results = <SearchResult>[];

    for (final doc in _documents) {
      double vectorScore = 0.0;
      double keywordScore = 0.0;

      // Vector similarity score
      if (doc.embedding != null) {
        vectorScore = _embeddingService.cosineSimilarity(
          queryEmbedding,
          doc.embedding!,
        );
      }

      // Keyword matching score (BM25-like)
      keywordScore = _embeddingService.bm25Score(query, doc.content);
      
      // Normalize keyword score to 0-1 range (approximate)
      keywordScore = keywordScore / (keywordScore + 10);

      // Combined score
      final combinedScore = (vectorScore * vectorWeight) + 
                           (keywordScore * keywordWeight);

      results.add(SearchResult(
        document: doc,
        score: combinedScore,
      ));
    }

    // Sort and return top K
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(topK).toList();
  }

  /// Get all documents
  List<RAGDocument> getAllDocuments() => List.unmodifiable(_documents);

  /// Clear all documents
  void clear() => _documents.clear();

  /// Get document count
  int get documentCount => _documents.length;

  /// Search by metadata
  List<RAGDocument> searchByMetadata(
    String key,
    dynamic value,
  ) {
    return _documents
        .where((doc) => doc.metadata[key] == value)
        .toList();
  }

  /// Get document by ID
  RAGDocument? getDocumentById(String id) {
    try {
      return _documents.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Remove document by ID
  bool removeDocument(String id) {
    final initialLength = _documents.length;
    _documents.removeWhere((doc) => doc.id == id);
    return _documents.length < initialLength;
  }
}
