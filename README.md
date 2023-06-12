# Noldor

Noldor is a wrapper/SDK/library around the https://the-one-api.dev/ api. The API lists the Lord of the Rings movies, books, qoutes and chapters.

This Library provides convenient access to the books and movies api

### Requirements

- Ruby >=2.6

## Installation
This can be installed as a gem

```ruby
gem 'noldor', github: 'omenkish/eneojo-omede-noldor
```

OR  via this Github repo path. Add this line to your application's Gemfile:

```ruby
gem 'noldor'
```

And then execute:

    $ bundle install


## Usage

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

movies.data.docs.first.box_office_revenue_in_millions

# retrieve single movie
movie = Noldor::Resources::Movie.find(id: 'movie_id')

#returns an array of 1 movie that can be accessed by docs like this
movie.data.docs.first.name

# fetch quotes for a movie
quotes = Noldor::Resources::Movie.movie_quotes(movie_id: 'movie_id')
quote.data.docs.first

# fetch all movies
movies = Noldor::Resources::Book.all

Books.data.docs.first.name

# retrieve single Book
book = Noldor::Resources::Book.find(id: 'book_id')

#returns an array of 1 book that can be accessed by docs like this
book.data.docs.first.name

# fetch quotes for a Book
quotes = Noldor::Resources::Book.book_chapters(book_id: 'book_id')
quote.data.docs.first
```

### Params
```ruby
# using params as hash
Noldor::Resources::Movie.all(options: { limit: 3, page: 2 })

chapter = Noldor::Resources::Book.book_chapters(book_id: 'book_id', options: { sort: 'DESC'})

```

## Development

Instructions to run tests:

```sh
bundle install
```

Run all tests:

```sh
bundle exec rspec
```

Run a single test:

```sh
bundle exec rspec spec/lib/resources/book_spec.rb
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/omenkish/eneojo-omede-noldor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
