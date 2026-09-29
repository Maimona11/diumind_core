import 'rag_models.dart';
import 'embedding_service.dart';
import 'vector_store.dart';

/// Main RAG service that orchestrates document processing and retrieval
class RAGService {
  late final EmbeddingService _embeddingService;
  late final VectorStore _vectorStore;
  bool _isInitialized = false;
  final ChunkConfig _chunkConfig;

  RAGService({
    ChunkConfig? chunkConfig,
  }) : _chunkConfig = chunkConfig ?? const ChunkConfig();

  /// Initialize the RAG system with documents
  Future<void> initialize(List<String> documents) async {
    _embeddingService = EmbeddingService();
    _vectorStore = VectorStore(_embeddingService);

    // Initialize embedding service with corpus
    await _embeddingService.initialize(documents);

    // Process and add documents to vector store
    final ragDocuments = <RAGDocument>[];
    
    for (int i = 0; i < documents.length; i++) {
      final chunks = _chunkText(documents[i]);
      
      for (int j = 0; j < chunks.length; j++) {
        ragDocuments.add(RAGDocument(
          content: chunks[j],
          metadata: {
            'sourceIndex': i,
            'chunkIndex': j,
            'totalChunks': chunks.length,
          },
        ));
      }
    }

    await _vectorStore.addDocuments(ragDocuments);
    _isInitialized = true;
  }

  /// Initialize from structured data (courses, quizzes, events)
  Future<void> initializeFromStructured(Map<String, List<String>> structuredData) async {
    final allDocuments = <String>[];
    final ragDocuments = <RAGDocument>[];

    // Convert structured data to documents
    structuredData.forEach((category, items) {
      for (int i = 0; i < items.length; i++) {
        allDocuments.add(items[i]);
        
        final chunks = _chunkText(items[i]);
        for (int j = 0; j < chunks.length; j++) {
          ragDocuments.add(RAGDocument(
            content: chunks[j],
            metadata: {
              'category': category,
              'sourceIndex': i,
              'chunkIndex': j,
              'totalChunks': chunks.length,
            },
          ));
        }
      }
    });

    // Initialize embedding service
    _embeddingService = EmbeddingService();
    _vectorStore = VectorStore(_embeddingService);
    
    await _embeddingService.initialize(allDocuments);
    await _vectorStore.addDocuments(ragDocuments);
    
    _isInitialized = true;
  }

  /// Retrieve relevant context for a query
  Future<String> retrieveContext(
    String query, {
    int topK = 3,
    double minScore = 0.1,
    bool useHybridSearch = true,
  }) async {
    if (!_isInitialized) {
      throw Exception('RAG service not initialized. Call initialize() first.');
    }

    final results = useHybridSearch
        ? await _vectorStore.hybridSearch(query, topK: topK)
        : await _vectorStore.search(query, topK: topK, minScore: minScore);

    if (results.isEmpty) {
      return '';
    }

    // Combine retrieved documents
    final context = StringBuffer();
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      context.writeln('--- Context ${i + 1} (Relevance: ${(result.score * 100).toStringAsFixed(1)}%) ---');
      context.writeln(result.document.content);
      context.writeln();
    }

    return context.toString();
  }

  /// Retrieve relevant documents (returns raw results)
  Future<List<SearchResult>> retrieve(
    String query, {
    int topK = 3,
    bool useHybridSearch = true,
  }) async {
    if (!_isInitialized) {
      throw Exception('RAG service not initialized. Call initialize() first.');
    }

    return useHybridSearch
        ? await _vectorStore.hybridSearch(query, topK: topK)
        : await _vectorStore.search(query, topK: topK);
  }

  /// Add new documents to the existing knowledge base
  Future<void> addDocuments(List<String> documents) async {
    if (!_isInitialized) {
      throw Exception('RAG service not initialized. Call initialize() first.');
    }

    final ragDocuments = <RAGDocument>[];
    
    for (final doc in documents) {
      final chunks = _chunkText(doc);
      for (final chunk in chunks) {
        ragDocuments.add(RAGDocument(content: chunk));
      }
    }

    await _vectorStore.addDocuments(ragDocuments);
  }

  /// Clear all documents from the knowledge base
  void clear() {
    _vectorStore.clear();
    _isInitialized = false;
  }

  /// Get statistics about the knowledge base
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'documentCount': _vectorStore.documentCount,
      'chunkSize': _chunkConfig.chunkSize,
      'chunkOverlap': _chunkConfig.chunkOverlap,
      'vocabularySize': _embeddingService.vocabularySize,
    };
  }

  /// Chunk text into smaller pieces with overlap
  List<String> _chunkText(String text) {
    if (text.length <= _chunkConfig.chunkSize) {
      return [text];
    }

    final chunks = <String>[];
    int start = 0;

    while (start < text.length) {
      int end = start + _chunkConfig.chunkSize;
      
      // Don't exceed text length
      if (end > text.length) {
        end = text.length;
      } else {
        // Try to break at sentence or word boundary
        final remaining = text.substring(start, end);
        final lastPeriod = remaining.lastIndexOf('. ');
        final lastNewline = remaining.lastIndexOf('\n');
        final lastSpace = remaining.lastIndexOf(' ');

        final breakPoint = [lastPeriod, lastNewline, lastSpace]
            .where((i) => i > _chunkConfig.chunkSize ~/ 2)
            .fold<int>(-1, (max, i) => i > max ? i : max);

        if (breakPoint > 0) {
          end = start + breakPoint + 1;
        }
      }

      chunks.add(text.substring(start, end).trim());

      // Move start position with overlap
      start = end - _chunkConfig.chunkOverlap;
      
      // Ensure we make progress
      if (start <= chunks.last.length && start < text.length) {
        start = end;
      }
    }

    return chunks;
  }

  bool get isInitialized => _isInitialized;
  int get documentCount => _vectorStore.documentCount;
}
