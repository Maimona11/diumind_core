# DiuMind - Student Q/A Chatbot 🎓🤖

A Flutter-based AI chatbot that provides students with personalized information about their courses, schedules, quizzes, and campus events.

## 🌟 Features

- **Course Information**: Get details about enrolled courses, instructors, credits, and rooms
- **Smart Scheduling**: Ask about your next class, today's schedule, or weekly routine
- **Mid-Term Syllabus**: View topics covered in mid-term exams for each course
- **Quiz Tracking**: Stay updated on upcoming quizzes and their topics
- **Campus Events**: Discover upcoming university events, workshops, and festivals
- **Natural Language**: Chat naturally - the AI understands conversational queries

## 🏗️ Tech Stack

- **Frontend**: Flutter (Cross-platform UI)
- **State Management**: Provider
- **LLM**: Groq Cloud API (Mixtral-8x7b-32768)
- **Architecture**: Cloud-based with RAG approach

### Planned (Future)
- **Agent Framework**: dartantic_ai
- **RAG Engine**: mobile_rag_engine
- **Local LLM**: Qwen 3.5 (0.8b/2b) with MNN inference

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.11.1+)
- Groq API key ([Get one here](https://console.groq.com))

### Installation

1. **Clone the repository**
   ```bash
   cd diumind_core
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Configuration**
   - The `.env` file is already configured with your API key

4. **Run the app**
   ```bash
   # For Android
   flutter run -d <device-id>
   
   # For Linux
   flutter run -d linux
   
   # For Web
   flutter run -d chrome
   ```

## 📱 Usage

Simply type your questions in natural language:

- "What's my next class?"
- "Show me today's schedule"
- "When is the Machine Learning mid exam?"
- "Do I have any quizzes this week?"
- "What events are coming up?"

The chatbot understands context and provides accurate, personalized responses.

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Comprehensive guide with test queries and troubleshooting
- **[IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)** - Detailed architecture and implementation plan
- **[FLUTTER_COMMANDS.md](FLUTTER_COMMANDS.md)** - Flutter command reference
- **[Stack.md](Stack.md)** - Technology stack overview

## 🎨 UI Preview

Minimal, clean chat interface with:
- WhatsApp-style message bubbles
- Real-time typing indicators
- Smooth auto-scrolling
- Timestamp for each message

## 🧪 Mock Data

The prototype includes rich mock data for testing:
- 1 Student profile (John Doe, CSE 6th semester)
- 5 Courses with complete details
- 4 Upcoming quizzes
- 4 Campus events
- Weekly class schedules with room numbers

## 🔄 Current Status

✅ **Prototype Complete** - Cloud approach with Groq API  
✅ Mock data implementation  
✅ Simple chat UI  
✅ Context-aware responses  

🚧 **Future Enhancements**:
- True RAG with mobile_rag_engine
- Local LLM fallback (Qwen 3.5)
- Multi-user support
- Real database integration
- Voice input/output

## 📊 Project Structure

```
lib/
├── main.dart                    # App entry point
├── data/
│   ├── models/                  # Data models
│   └── mock/                    # Mock student data
├── services/
│   ├── groq_service.dart       # Groq API integration
│   └── context_service.dart    # Context retrieval
├── providers/
│   └── chat_provider.dart      # State management
└── ui/
    ├── screens/                 # Chat screen
    └── widgets/                 # UI components
```

## 🤝 Contributing

This is a prototype project. Contributions and suggestions are welcome!

## 📄 License

This project is part of the DIU academic work.

## 🙏 Acknowledgments

- Groq for providing fast LLM inference
- Flutter team for the amazing framework
- DIU for the inspiration

---

**Made with ❤️ for DIU Students**
