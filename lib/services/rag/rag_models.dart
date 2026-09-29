import 'package:uuid/uuid.dart';

/// Represents a document in the RAG system
class RAGDocument {
  final String id;
  final String content;
  final Map<String, dynamic> metadata;
  final List<double>? embedding;
  
  RAGDocument({
    String? id,
    required this.content,
    this.metadata = const {},
    this.embedding,
  }) : id = id ?? const Uuid().v4();

  RAGDocument copyWith({
    String? id,
    String? content,
    Map<String, dynamic>? metadata,
    List<double>? embedding,
  }) {
    return RAGDocument(
      id: id ?? this.id,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      embedding: embedding ?? this.embedding,
    );
  }

  @override
  String toString() => 'RAGDocument(id: $id, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
}

/// Represents a search result with relevance score
class SearchResult {
  final RAGDocument document;
  final double score;

  SearchResult({
    required this.document,
    required this.score,
  });

  @override
  String toString() => 'SearchResult(score: ${score.toStringAsFixed(3)}, doc: ${document.id})';
}

/// Chunk configuration for document processing
class ChunkConfig {
  final int chunkSize;
  final int chunkOverlap;
  
  const ChunkConfig({
    this.chunkSize = 500,
    this.chunkOverlap = 50,
  });
}
