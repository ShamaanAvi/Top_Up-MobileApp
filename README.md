# Top_Up-MobileApp
A straightforward note-taking mobile application built with Flutter, featuring CRUD (Create, Read, Update, Delete) operations for easy note management. Users can add, edit, and delete notes, with the application retaining changes upon reopening. The notes are saved using SQLite, ensuring offline availability, with a focus on simplicity and an intuitive user experience.

Features
Add, Edit, and Delete Notes: Create notes with a title and content, update them as needed, and delete multiple notes using a selection mode.
Persistent Storage: Notes are stored locally on the device with SQLite, allowing offline access.
Date and Time Tracking: Each note records the last edited date and time (format: MM/dd/yyyy HH
).
Minimalist UI: An uncluttered interface focusing on ease of navigation and quick access to note functions.
Installation
  Clone the repository
  Navigate to the project directory:
  Install dependencies:
  Run the app
  
Project Structure
  main.dart: Entry point of the app, handles the main UI structure and navigation.
  database_helper.dart: Manages the SQLite database, including setup and CRUD operations.
  note_model.dart: Defines the data model for notes, converting them to/from SQLite-friendly formats.
  note_editor_page.dart: UI and logic for creating and editing notes.
  notes_page.dart: Displays the list of notes and allows users to delete or edit.
  
Dependencies
  sqflite: SQLite support for Flutter.
  path_provider: Locates the database file on device storage.
  path: Provides path manipulation utilities.
  intl: Handles date formatting for notes.
  
Contributing
Contributions are welcome! Feel free to fork the repository, submit pull requests, and report issues to enhance the project.
