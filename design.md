### Designer

The Noldor gem is designed with extensibility and maintainability in mind. 
The SDK is well tested to ensure code reliability.

Every resource has a file named after it in the resources folder (mirroring a rails model implementation).

Each model is returned as an instance of openstruct for easy access to geetter methods (TODO: I plan to change this to instances of the particular resourrce class).

The `Base` module of resources provides an abstraction/interface to conveniently carry out different operations on the 3rd party API.

Errors are properly handled.


The library needs to be configured with your account's secret key which you can get by creating an account [here](https://the-one-api.dev/). Set `Noldor.credentials.api_key` to its value. You can set your configurations in two ways:

```ruby
require 'noldor'

Noldor.credentials.api_key = 'YOUR_API_KEY'
Noldor.credentials.exception_enabled = false

```

OR you can pass in a block like this

```ruby
Noldor.configure do |config|
    config.api_key = 'YOUR_API_KEY'
    config.exception_enabled = false
end

```

Exceptions are enabled by default.


After setting your api key, `Book` and `Movie` resources are available to you.

```ruby

# fetch all movies
movies = Noldor::Resources::Movie.all

movies.data.data.first.box_office_revenue_in_millions

# retrieve single movie
movie = Noldor::Resources::Movie.find(id: 'movie_id')

movie.data.name

# fetch quotes for a movie
quotes = Noldor::Resources::Movie.movie_quotes(movie_id: 'movie_id')
quote.data.data.first

# fetch all books
books = Noldor::Resources::Book.all

books.data.data.first.name

# retrieve single Book
book = Noldor::Resources::Book.find(id: 'book_id')
book.data.name

# fetch quotes for a Book
quotes = Noldor::Resources::Book.book_chapters(book_id: 'book_id')
quote.data.data.first
```
