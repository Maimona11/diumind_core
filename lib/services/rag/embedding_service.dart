import 'dart:math';

/// Simple embedding service using TF-IDF-like approach
/// For production, this can be replaced with Groq embeddings or other services
class EmbeddingService {
  // Simple vocabulary for embedding generation
  final Map<String, int> _vocabulary = {};
  final Map<String, double> _idf = {};
  bool _isInitialized = false;

  /// Initialize the embedding service with a corpus
  Future<void> initialize(List<String> corpus) async {
    _vocabulary.clear();
    _idf.clear();
    
    // Build vocabulary
    int vocabIndex = 0;
    final docFrequency = <String, int>{};
    
    for (final text in corpus) {
      final words = _tokenize(text);
      final uniqueWords = words.toSet();
      
      for (final word in uniqueWords) {
        if (!_vocabulary.containsKey(word)) {
          _vocabulary[word] = vocabIndex++;
        }
        docFrequency[word] = (docFrequency[word] ?? 0) + 1;
      }
    }
    
    // Calculate IDF
    final numDocs = corpus.length;
    for (final entry in docFrequency.entries) {
      _idf[entry.key] = log(numDocs / entry.value);
    }
    
    _isInitialized = true;
  }

  /// Generate embedding for text using TF-IDF
  List<double> generateEmbedding(String text) {
    if (!_isInitialized) {
      throw Exception('EmbeddingService not initialized. Call initialize() first.');
    }
    
    final words = _tokenize(text);
    final wordCounts = <String, int>{};
    
    // Count word frequencies
    for (final word in words) {
      wordCounts[word] = (wordCounts[word] ?? 0) + 1;
    }
    
    // Create TF-IDF vector
    final embedding = List<double>.filled(_vocabulary.length, 0.0);
    
    for (final entry in wordCounts.entries) {
      final word = entry.key;
      final count = entry.value;
      
      if (_vocabulary.containsKey(word)) {
        final index = _vocabulary[word]!;
        final tf = count / words.length;
        final idf = _idf[word] ?? 0.0;
        embedding[index] = tf * idf;
      }
    }
    
    // Normalize the vector
    return _normalize(embedding);
  }

  /// Calculate cosine similarity between two embeddings
  double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Embeddings must have the same length');
    }
    
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    
    if (normA == 0.0 || normB == 0.0) return 0.0;
    
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  /// Tokenize text into words
  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty && word.length > 2)
        .toList();
  }

  /// Normalize a vector
  List<double> _normalize(List<double> vector) {
    double norm = 0.0;
    for (final value in vector) {
      norm += value * value;
    }
    norm = sqrt(norm);
    
    if (norm == 0.0) return vector;
    
    return vector.map((v) => v / norm).toList();
  }

  /// Calculate BM25 score (alternative ranking function)
  double bm25Score(String query, String document, {double k1 = 1.5, double b = 0.75}) {
    final queryWords = _tokenize(query);
    final docWords = _tokenize(document);
    
    if (docWords.isEmpty) return 0.0;
    
    final avgDocLength = 100.0; // Approximate average document length
    final docLength = docWords.length.toDouble();
    
    double score = 0.0;
    
    for (final word in queryWords) {
      final termFreq = docWords.where((w) => w == word).length;
      final idf = _idf[word] ?? 0.0;
      
      final numerator = termFreq * (k1 + 1);
      final denominator = termFreq + k1 * (1 - b + b * (docLength / avgDocLength));
      
      score += idf * (numerator / denominator);
    }
    
    return score;
  }

  /// Get vocabulary size
  int get vocabularySize => _vocabulary.length;
}
