# MovieSearchingApp
1. Project Overview
Project Name: Movie Searching App
Description: A simple movie database app built using UIKit in Swift. The app fetches movie data from the OMDB API, allowing users to search for movies and view detailed information about each movie.

2. Installation Guide
Prerequisites: Xcode, Swift 5.0 or later, Internet connection for API requests.
Steps to Install:
Clone the repository: git clone <repository_url>
Open the project in Xcode.
Build the project using the Cmd + B shortcut.
Run the app using the Cmd + R shortcut.

3. Architecture Overview
MVVM (Model-View-ViewModel): The app follows the MVVM design pattern, where:

Model: Represents the data and business logic of the app. It includes the structures that define the app’s data (e.g., Movie, Detail).

View: The UI components that present the data to the user. The views are responsible for rendering the UI elements and receiving user input (e.g., HomeViewController, MovieDetailViewController, MovieCVC). In this architecture, the views bind to the ViewModel to display data.

ViewModel: Acts as an intermediary between the Model and the View. It retrieves data from the Model, processes it as needed, and then exposes it in a form that the View can easily use. The ViewModel also handles any UI logic that doesn't belong to the View itself, like managing the state of loading indicators (e.g., HomeViewModel, MovieDetailViewModel).

4. Code Documentation
4.1. HomeViewController
Purpose: Handles the search functionality and displays the list of movies in a collection view.
4.2. MovieCVC
Purpose: Custom collection view cell to display movie information.
4.3. ViewModel Classes
Purpose: Manage data fetching and business logic, separating it from the view.

5. API Documentation
OMDB API: Describe how the app interacts with the OMDB API.
Base URL: http://www.omdbapi.com/
Endpoints: Describe the endpoints used (e.g., /, /?s=, /?i=)
Parameters:
