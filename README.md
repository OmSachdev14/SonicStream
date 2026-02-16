🎵 Spotify Clone - Full Stack Music Streaming App
A production-ready music streaming application built using the MVVM architecture. This project features a cross-platform Flutter frontend and a high-performance FastAPI backend, delivering a seamless audio experience with real-time state management.

📺 Project Demo

[Pls Click the Here to see the demo](https://github.com/OmSachdev14/spotify_clone/blob/main/Screen-Recording-20260216-223756.MP4)

This version of the README.md is specifically designed to showcase your Full-Stack mastery. It emphasizes the MVVM architecture, high-performance FastAPI backend, and the sophisticated use of Riverpod—the exact details a senior Flutter developer or recruiter looks for to say, "Yes, this person knows Flutter."

🎵 Full-Stack Spotify Clone: Flutter + FastAPI
A high-performance, scalable music streaming platform built with Clean Architecture and MVVM. This project demonstrates professional-grade state management, cloud media integration, and a secure Python-based backend.

📺 Application Demo
(Insert your high-quality thumbnail here with the link to your compressed video or YouTube upload)

🏗️ Architecture & State Management
This project strictly follows the MVVM (Model-View-ViewModel) pattern combined with Clean Architecture principles to ensure the codebase is testable, maintainable, and scalable.

🌊 Riverpod 2.0 (Modern State Management)
The app leverages the full power of the Riverpod ecosystem:

Notifiers & AsyncNotifiers: Used to manage complex UI states and asynchronous data fetching without the boilerplate of standard ChangeNotifiers.

Riverpod Generator: Implements code generation for type-safe, compile-time checked providers.

Reactive UI: Screens automatically rebuild only when specific pieces of state change, ensuring 60 FPS performance on your mobile device.

📂 Feature-First Folder Structure
🛠️ Technical Deep Dive
📱 Frontend: Flutter Mastery
Persistence Strategy: * Hive: Used as a high-speed NoSQL local database for caching song metadata and offline functionality.

Shared Preferences: Handles lightweight key-value storage for user settings and session persistence (e.g., "Is the user logged in?").

Audio Engine: Integrated just_audio with a background service to ensure music keeps playing even when the app is minimized.

Dynamic UI: Custom themes implemented using flex_color_picker for a premium, Spotify-like aesthetic.

⚡ Backend: FastAPI & PostgreSQL
Asynchronous Processing: Built on FastAPI, utilizing Python's async/await to handle thousands of concurrent requests with low latency.

Relational Database: PostgreSQL managed via SQLAlchemy ORM for structured data like user profiles, song relationships, and playlists.

Cloud Media Management: * Cloudinary Integration: Images and high-bitrate audio files are uploaded directly to Cloudinary.

The API handles the secure signature generation and stores only the optimized secure
Implements JWT (JSON Web Tokens) for stateless authentication and Bcrypt for industry-standard password hashing.
