Eric Yelong Tabuchi
CSE 438 Lab 4

Features
* This app uses a tab bar to search for movies and check for their saved favorites
	* Each tab has a custom image representing it 
	* There also is a tab that credits TMDb as the source of the movie data and The Noun Project for the source of the custom tab images
* Searching for movies is done by typing into a search bar
	* The search is performed when the user decides to search. On iOS software keyboard, it'd be from hitting the Return key or hitting the Enter key on the Hardware keyboard in the simulator.
	* The search uses an API from The Movie Database and populates a collection view with multiple columns with at most 20 movies. The API request is processed involving JSON results and the Codable protocol. 
		* There is a text field that shows how many search results are given
		* Each cell within the collection view shows the poster for the movie and its title. If the movie does not have a poster available from the database, a default replacement image is given instead.
		* While searching, a spinner is shown spinning to indicate the request is in progress and will disappear when finished. This request is also done in the background and does not lock up the user interface, as demonstrated by still being able to type and edit the search bar while searching.
* For smooth scrolling, images are cached and cells are reused on the collection view
* When you tap on a movie in the search screen, it takes you to a new screen where you are greeted by a larger image of the poster as well as further information about the movie.
	* This information includes: 1. Reminding the user about the title of the film, 2. The release data, 3. The user score / rating, and 4. A summary about the movie
		* If there is no summary available, it is replaced with N/A
	* In addition, there is a button at the bottom of the screen labeled "Favorite". Tapping that button will save that movie to your favorites which you can view in the Favorites tab.
* The favorites tab is a table showing a list of the various movie titles you have favorited. 
	* Movies you have favorited are kept track of using UserDefaults which means that information is maintained between app launches
	* Sliding your finger / mouse horizontally gives you the option to delete that data and remove it from the list of favorites.
* This project adheres to the MVC design pattern and Swift guidelines
	* For organized work, a custom subclass was made for the UICollectionViewCell and UITableViewCell to store the necessary information at each part of the application. Custom UIViewController were made to house the extra details when selecting a movie that would be pushed onto the navigation stack as well as having a view controller for managing displaying favorites.

Creative Portion
* 1. Searching For TV Shows
	* The API is not limited to searching for movies. It can also search for TV shows and people in the industry. When thinking about what people would prioritize searching, despite the importance of the people involved in the industry, I feel more people would want to look up TV shows over people if they only had to implement one.
	* An additional tab was added that allows users to also look up TV shows
	* The implementation of searching for TV shows is based off of the one used to search for movies and also uses the TMDb API 
	* Users can tap on searched show results to see additional information and favorite TV shows
* 2. Improving the Favorites Section
	* The base version of the Favorites Tab in the app is to basically only display the names of favorited movies and the ability to remove them from your favorites
	* There is now a button labelled "Clear" on the favorites screen that deletes all of the movies from your favorites list
		* On a side note, this feature has also been added to searching movies or TV shows when you either completely empty out the text field or you press the clear button that is built into the search bar.
	* The user can now tap onto a cell in the favorites screen and be redirected to a screen with the same information that is displayed if you tap a movie in the search tab. Since the movie is already in your favorites, there is no Add to Favorites button available.
	* The favorites screen has been updated further to distinguish between Favorited Movies and TV Shows
		* To help distinguish the titles of shows and films from the labels, a bullet point has been added to each favorited entry
* 3. New and Popular Movies
	* Sometimes you will not be always "in the know" on what is popular in film and TV. If there was a way to display and check the database for movies / shows that are popular or new while still maintaining a compact and simple way to use, it would be rather convenient for the user.
	* There are two additional buttons available when searching for movies or TV shows. They are labelled "Latest" and "Trending"
	* Clicking the trending button for either movies or TV shows will make an API request and display up to 20 movies / shows that are considered "trending" or popular according to the database
		* The API request can specify the time range you would like to gauge trendiness and I have decided to display the most popular TV shows and movies over the last week. Checking popularity over the course of one day seems too short but checking popularity over one week seems more reasonable to me. 
		* Just like searching for content with the search bars, you can click on the cells for trending movies to see more information about them and favorite
	* Clicking the latest button for either movies or TV shows will make an API request and display up to 20 movies / shows that are either upcoming or recently released projects.
		* What applies to the cells produced by clicking the trending button also applies with these search results.
	* When launching the app, it shows what is trending for both movies and TV shows by calling the API request in viewDidLoad()

Extra Credit
* Completed Studio 3 and submitted to Canvas

Sources
* For the spinner part of the assignment, I looked this up and it was over two lines
https://www.raywenderlich.com/25358187-spinner-and-progress-bar-in-swift-getting-started

* For my custom UIViewController subclass, I wanted to know how to add the Favorite button programmatically 
https://www.appsdeveloperblog.com/create-uibutton-in-swift-programmatically/

* I wanted to see if there was a way to not programmatically add UI elements to a subclass of a UICollectionViewCell and instead use Storyboard. The following link is a video explaining how you could make a custom collection view cell.
https://youtu.be/59dCm9GaWvs

* Afterwards, the same Youtube channel made the same tutorial for UITableViewCells so I checked it too to see if anything were different
https://youtu.be/mKzYqzT3f4Q

* I used TMDb forum posts and the provided API documentation to understand querying movies and shows
https://www.themoviedb.org/talk/5aeaaf56c3a3682ddf0010de

