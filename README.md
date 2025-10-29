📓 Journali App
Journali is a simple and elegant daily journal app built with SwiftUI using the MVVM architecture.
It allows users to create, edit, bookmark, and search through personal journal entries — all within a clean, dark-themed interface.


✨ Features
Splash Screen – A smooth intro screen before navigating to the main view.
Home Screen – Displays all journal entries sorted by date or bookmark status.
Editor Screen – Write, edit, and save journal entries with an intuitive text editor.
Search Bar – Quickly find journals by title or content.
Dark Mode – Full app experience in dark theme.
Modern Glass Design – Uses blur and light effects for a polished look.


🧩 Architecture (MVVM)
The app follows the Model–View–ViewModel design pattern:
Model:
Defines the JournalEntry structure containing the title, body, date, and bookmark status.
ViewModel:
Handles the app’s logic — creating, saving, filtering, sorting, and deleting journal entries (HomeViewModel).
Views:
SplashView – Welcome screen
HomeView – Main journal list
EditorView – Journal writing/editing screen
EntryRow – Card layout for each journal entry
EmptyStateView – Displayed when no journals exist
