# Fullscript - Kombucha Builder

Kombucha Builder is an API for creating and managing kombucha recipes.

## Setup
This app uses Rails 5.2 and Ruby 2.6.3.

However, if you don't have Ruby 2.6 installed, please feel free to change the `.ruby-version` to whatever ruby version you have installed on your computer.

Run `bin/setup` to get all the migrations and seed files set up and going.

## Running specs/tests
In this app there are tests for both rspec and minitest. Please choose whichever testing framework you are most comfortable with!


## Tips
We don't expect everyone will finish all the features below but please try to complete as many as you can. (In our minds a senior dev should be able to complete all 4 features and an intermediate should be able to do about 3.) Even though this is a test example, this should reflect your best production-like code. Please have fun and show us what you can do! 😀


## Feature request #1 - Better filtering

As a user of the API I would like to filter kombucha teas by various attributes. Currently `get /api/kombuchas` returns all of the kombucha teas available but I would like to filter this list.

## Requirements
Design some way that you can filter kombucha ingredients by fizziness, caffeine_level and whether or not it's vegan.

Examples:
* `get /api/kombuchas, params: "fizziness" => "high"` should only return kombucha teas with 'high' fizziness.
* `get /api/kombuchas, params: "caffeine_free" => "true"` should return all kombucha teas that are caffeine free.
* `get /api/kombuchas, params: "vegan" => "true"` should return all vegan kombucha teas.

I should be able to combine these parameters into different combinations. Example: low fizzy, with caffeine but not vegan.


## Feature request #2 - Ratings

Users of this app want a way to add a rating to different kombucha recipes through the API.

#### Requirements:
Make a Rating's model with the following rules:
  * should have a score that returns a number between 1 and 5.
  * Users can only have 1 rating per kombucha.

Add API endpoints so that users can:
 * See their rating
 * Create a rating
 * Update an existing rating
 * In each endpoint, add an attribute in the response to display the average rating of a given kombucha tea. This average rating should be based on all user ratings for that particular kombucha tea.


## Feature request # 3 - Kombucha Flights

As a kombucha restauranteur, I want a way to surprise and delight my customers by generating a random "flight" of kombucha drinks.

#### Requirements:
Build a random flight picker for kombucha recipes with the following rules:
  * Flights should contain 4 different kombucha recipes. They are only valid with 4.
  * Each kombucha tea in the flight should have a different tea base.

* Make an endpoint to create a flight.
  * Add an optional way to select kombucha recipes greater then a given average rating.
  * Add an optional way to select a particular kombucha recipe as part of the flight.


## Feature request 4 - Advanced Filtering

Build out your filtering object with some more advanced features.

#### Requirements
* Included Ingredients: return kombucha teas that contain the ingredients passed to it. Example: find all kombucha's that have coffee in them.
* Not Included Ingredients: return kombucha teas that *do not* contain the ingredients passed to the endpoint. Example: I don't want recipes that contain coffee
* Popular recipes: return kombucha teas that are in 'x' percent or greater of Kombucha flights.
