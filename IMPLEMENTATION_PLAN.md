# DiuMind Student Q/A Chatbot - Implementation Plan

## 🎯 Project Overview
A Flutter-based Q/A chatbot that provides students with personalized information about:
- Courses & course details
- Class routines & schedules
- Next class information (course, room, time)
- Mid-term syllabus
- Upcoming quizzes
- Campus events

## 🏗️ Architecture

### Tech Stack (from Stack.md)
- **Agent Framework**: dartantic_ai
- **RAG Engine**: mobile_rag_engine
- **LLM Provider**: Groq API (Cloud approach)
- **UI Framework**: Flutter

### System Architecture Layers

```
┌─────────────────────────────────────┐
│         UI Layer (Flutter)          │
│  - Chat Interface                   │
│  - Message Display                  │
│  - Input Field                      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Agent Orchestration Layer       │
│  (dartantic_ai)                     │
│  - Query Understanding              │
│  - Context Management               │
│  - Response Generation              │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │                │
┌──────▼──────┐  ┌──────▼──────────────┐
│  RAG Engine │  │   Groq API Service  │
│(mobile_rag) │  │  - API Integration  │
│- Retrieval  │  │  - LLM Inference    │
│- Embedding  │  │  - Response Stream  │
└──────┬──────┘  └─────────────────────┘
       │
┌──────▼──────────────────────────────┐
│         Data Layer                  │
│  - Mock Student Data                │
│  - Courses, Routines, Events        │
│  - Vectorized Knowledge Base        │
└─────────────────────────────────────┘
```

## 📦 Dependencies to Add

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Agent & RAG
  dartantic_ai: ^latest
  mobile_rag_engine: ^latest
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # State Management
  provider: ^6.1.0
  
  # Environment Variables
  flutter_dotenv: ^5.1.0
  
  # JSON Serialization
  json_annotation: ^4.8.1
  
  # UI Components
  flutter_markdown: ^0.6.18
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
```

## 📁 Project Structure

```
lib/
├── main.dart
├── config/
│   └── env_config.dart              # Environment configuration
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   └── utils/
│       └── date_utils.dart          # Date/time utilities
├── data/
│   ├── models/
│   │   ├── student_model.dart       # Student data model
│   │   ├── course_model.dart        # Course information
│   │   ├── routine_model.dart       # Class schedule
│   │   ├── quiz_model.dart          # Quiz information
│   │   └── event_model.dart         # Campus events
│   ├── repositories/
│   │   └── student_repository.dart  # Data access layer
│   └── mock/
│       └── mock_data.dart           # Mock student data
├── services/
│   ├── groq_service.dart            # Groq API integration
│   ├── rag_service.dart             # RAG engine service
│   └── agent_service.dart           # Agent orchestration
├── providers/
│   └── chat_provider.dart           # Chat state management
└── ui/
    ├── screens/
    │   └── chat_screen.dart         # Main chat interface
    └── widgets/
        ├── message_bubble.dart      # Chat message widget
        ├── input_field.dart         # Message input
        └── typing_indicator.dart    # Loading indicator
```

## 🚀 Implementation Steps

### Phase 1: Project Setup

#### 1.1 Update pubspec.yaml
- Add all required dependencies
- Configure assets for mock data

#### 1.2 Environment Configuration
- Create `.env` file for Groq API key
- Set up environment loading

```env
GROQ_API_KEY=your_groq_api_key_here
GROQ_MODEL=mixtral-8x7b-32768
```

### Phase 2: Data Layer

#### 2.1 Create Data Models
```dart
// Student Model
class Student {
  String id;
  String name;
  String department;
  String semester;
  List<String> enrolledCourses;
}

// Course Model
class Course {
  String id;
  String code;
  String name;
  String instructor;
  int credits;
  String room;
  List<ClassSchedule> schedule;
  MidSyllabus? midSyllabus;
}

// Routine Model
class ClassSchedule {
  String courseId;
  String day;
  String startTime;
  String endTime;
  String room;
}

// Quiz Model
class Quiz {
  String id;
  String courseId;
  String title;
  DateTime date;
  String topics;
  int marks;
}

// Event Model
class CampusEvent {
  String id;
  String title;
  DateTime date;
  String location;
  String description;
}
```

#### 2.2 Create Mock Data
Generate comprehensive mock data for:
- Student profile (ID: ST001)
- 5-6 courses with full details
- Weekly routine
- Upcoming quizzes (next 2 weeks)
- Campus events (next month)

### Phase 3: Services Layer

#### 3.1 Groq API Service
```dart
class GroqService {
  Future<String> generateResponse(
    String prompt, 
    String context
  ) async {
    // Make API call to Groq
    // Handle streaming responses
    // Return generated text
  }
}
```

**Features:**
- API authentication
- Request/response handling
- Error handling
- Retry logic

#### 3.2 RAG Service
```dart
class RAGService {
  Future<void> initializeKnowledgeBase(
    List<Document> documents
  ) async {
    // Initialize mobile_rag_engine
    // Create embeddings
    // Build vector store
  }
  
  Future<List<String>> retrieveContext(
    String query
  ) async {
    // Query vector store
    // Return relevant context
  }
}
```

**Features:**
- Document preprocessing
- Embedding generation
- Semantic search
- Context retrieval

#### 3.3 Agent Service
```dart
class AgentService {
  Future<String> processQuery(String userQuery) async {
    // 1. Retrieve relevant context from RAG
    // 2. Build prompt with context
    // 3. Call Groq API
    // 4. Return response
  }
}
```

**Features:**
- Query classification
- Context injection
- Prompt engineering
- Response formatting

### Phase 4: UI Layer

#### 4.1 Chat Screen
Simple, clean chat interface with:
- Message list (scrollable)
- User messages (right-aligned, blue)
- Bot messages (left-aligned, grey)
- Input field at bottom
- Send button
- Typing indicator

#### 4.2 State Management
- Provider for chat state
- Message history
- Loading states
- Error handling

### Phase 5: Integration

#### 5.1 Connect All Layers
```
User Input → Agent Service → RAG Service (retrieval)
                ↓
         Groq Service (generation)
                ↓
         Format Response → Update UI
```

#### 5.2 Prompt Engineering
Create system prompt for student assistant:
```
You are a helpful student assistant for [University Name]. 
You have access to information about:
- Student's enrolled courses
- Class schedules and routines
- Upcoming quizzes and exams
- Campus events
- Mid-term syllabus

Answer student questions clearly and concisely.
Always provide specific details like room numbers, times, and dates.
If you don't have information, politely say so.

Context: {retrieved_context}
Question: {user_question}
```

## 📝 Mock Data Examples

### Sample Student Data
```json
{
  "student": {
    "id": "ST2024001",
    "name": "John Doe",
    "department": "Computer Science",
    "semester": "6th",
    "email": "john.doe@university.edu"
  },
  "courses": [
    {
      "code": "CSE401",
      "name": "Machine Learning",
      "instructor": "Dr. Smith",
      "credits": 3,
      "room": "AB-305",
      "schedule": [
        {"day": "Sunday", "time": "10:00 AM - 11:30 AM"},
        {"day": "Tuesday", "time": "10:00 AM - 11:30 AM"}
      ],
      "midSyllabus": {
        "topics": [
          "Introduction to ML",
          "Linear Regression",
          "Logistic Regression",
          "Neural Networks Basics"
        ],
        "midDate": "2026-03-25"
      }
    }
  ],
  "quizzes": [
    {
      "course": "CSE401",
      "title": "Quiz 2",
      "date": "2026-03-15",
      "topics": "Neural Networks",
      "marks": 10
    }
  ],
  "events": [
    {
      "title": "Tech Fest 2026",
      "date": "2026-03-20",
      "location": "Main Auditorium",
      "description": "Annual technology festival"
    }
  ]
}
```

## 🎨 UI Design

### Simple Chat Interface
```
┌────────────────────────────────────┐
│  📱 DiuMind Student Assistant      │
├────────────────────────────────────┤
│                                    │
│  🤖 Hello! I'm your student       │
│     assistant. Ask me about       │
│     courses, schedule, quizzes... │
│                                    │
│                  What's my next   │
│                  class? 👤         │
│                                    │
│  🤖 Your next class is Machine    │
│     Learning (CSE401) on Tuesday  │
│     at 10:00 AM in Room AB-305    │
│                                    │
├────────────────────────────────────┤
│  Type your question...        [>] │
└────────────────────────────────────┘
```

## 🧪 Testing Strategy

### Test Queries
1. "What's my next class?"
2. "Show me my routine for today"
3. "When is my Machine Learning mid?"
4. "What topics are in CSE401 mid syllabus?"
5. "Do I have any quizzes this week?"
6. "What events are coming up?"
7. "Which room is my Database class in?"
8. "Who teaches Machine Learning?"

## ⚙️ Configuration

### Groq API Setup
1. Sign up at https://console.groq.com
2. Generate API key
3. Add to `.env` file
4. Choose model (recommended: mixtral-8x7b-32768 or llama2-70b-4096)

### RAG Configuration
- Chunk size: 512 tokens
- Overlap: 50 tokens
- Top-k retrieval: 3-5 documents
- Similarity threshold: 0.7

## 📊 Success Metrics

### Prototype Goals
- ✅ Respond to all 8 test queries accurately
- ✅ Response time < 3 seconds
- ✅ Clean, intuitive UI
- ✅ Proper context retrieval
- ✅ API error handling

## 🔄 Future Enhancements (Not in Prototype)
- Local LLM fallback (Qwen 3.5)
- Multi-user support
- Real database integration
- Voice input
- Push notifications for classes/quizzes
- Calendar integration

## 📚 Resources

### Documentation
- Groq API: https://console.groq.com/docs
- dartantic_ai: https://pub.dev/packages/dartantic_ai
- mobile_rag_engine: https://pub.dev/packages/mobile_rag_engine

### Example Prompts for RAG
```
Document 1: "Student ST2024001 is enrolled in CSE401 Machine Learning 
taught by Dr. Smith. Classes are on Sunday and Tuesday 10:00-11:30 AM 
in room AB-305."

Document 2: "The mid-term exam for CSE401 is scheduled for March 25, 
2026. Topics include: Introduction to ML, Linear Regression, Logistic 
Regression, and Neural Networks Basics."

Document 3: "Upcoming quiz in CSE401: Quiz 2 on March 15, 2026 covering 
Neural Networks topic, worth 10 marks."
```

## 🎯 Development Timeline

### Day 1: Setup & Data
- Project setup
- Dependencies installation
- Mock data creation

### Day 2: Services
- Groq API integration
- RAG engine setup
- Agent service

### Day 3: UI & Integration
- Chat UI
- Connect all components
- Testing & refinement

---

**Next Steps**: Start with Phase 1 - Project Setup
