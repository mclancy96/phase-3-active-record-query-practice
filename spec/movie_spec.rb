require_relative '../config/environment'

RSpec.describe Movie do
  before(:all) do
    # Run migrations and seed data if needed
    unless ActiveRecord::Base.connection.table_exists?(:movies)
      ActiveRecord::Migration.suppress_messages do
        require_relative '../db/migrate/001_create_movies'
        CreateMovies.new.up
      end

      # Load seed data
      load File.join(__dir__, '..', 'db', 'seeds.rb')
    end
  end

  before(:each) do
    # Ensure we have test data
    expect(Movie.count).to be > 0
  end

  # ==================== BASIC FINDERS ====================
  describe "Basic Finders" do
    describe ".find_by_exact_title" do
      it "finds movie by exact title match" do
        movie = Movie.first
        result = Movie.find_by_exact_title(movie.title)
        expect(result).to eq(movie)
      end

      it "returns nil for non-existent title" do
        result = Movie.find_by_exact_title("Non-existent Movie")
        expect(result).to be_nil
      end
    end

    describe ".by_director" do
      it "returns all movies by specific director" do
        director = Movie.first.director
        results = Movie.by_director(director)
        expect(results).to all(have_attributes(director: director))
      end

      it "returns empty collection for non-existent director" do
        results = Movie.by_director("Non-existent Director")
        expect(results).to be_empty
      end
    end

    describe ".in_genre" do
      it "returns movies in specific genre" do
        genre = Movie.first.genre
        results = Movie.in_genre(genre)
        expect(results).to all(have_attributes(genre: genre))
      end
    end

    describe ".released_in_year" do
      it "returns movies from specific year" do
        year = Movie.first.release_year
        results = Movie.released_in_year(year)
        expect(results).to all(have_attributes(release_year: year))
      end
    end

    describe ".by_studio" do
      it "returns movies from specific studio" do
        studio = Movie.first.studio
        results = Movie.by_studio(studio)
        expect(results).to all(have_attributes(studio: studio))
      end
    end
  end

  # ==================== RATING QUERIES ====================
  describe "Rating Queries" do
    describe ".highly_rated" do
      it "returns movies with rating >= 8.0" do
        results = Movie.highly_rated
        expect(results).to all(have_attributes(rating: be >= 8.0))
      end
    end

    describe ".poorly_rated" do
      it "returns movies with rating < 4.0" do
        results = Movie.poorly_rated
        expect(results).to all(have_attributes(rating: be < 4.0))
      end
    end

    describe ".with_rating" do
      it "returns movies with exact rating" do
        rating = Movie.first.rating
        results = Movie.with_rating(rating)
        expect(results).to all(have_attributes(rating: rating))
      end
    end

    describe ".rating_between" do
      it "returns movies with rating in range" do
        results = Movie.rating_between(7.0, 8.0)
        expect(results).to all(have_attributes(rating: be_between(7.0, 8.0)))
      end
    end

    describe ".rating_above" do
      it "returns movies with rating above threshold" do
        results = Movie.rating_above(7.5)
        expect(results).to all(have_attributes(rating: be > 7.5))
      end
    end
  end

  # ==================== BUDGET & BOX OFFICE ====================
  describe "Budget & Box Office Queries" do
    describe ".big_budget" do
      it "returns movies with budget > $100M" do
        results = Movie.big_budget
        expect(results).to all(have_attributes(budget: be > 100_000_000))
      end
    end

    describe ".low_budget" do
      it "returns movies with budget < $5M" do
        results = Movie.low_budget
        expect(results).to all(have_attributes(budget: be < 5_000_000))
      end
    end

    describe ".profitable" do
      it "returns movies where box_office > budget" do
        results = Movie.profitable
        results.each do |movie|
          expect(movie.box_office).to be > movie.budget
        end
      end
    end

    describe ".unprofitable" do
      it "returns movies where box_office < budget" do
        results = Movie.unprofitable
        results.each do |movie|
          expect(movie.box_office).to be < movie.budget
        end
      end
    end

    describe ".budget_between" do
      it "returns movies with budget in range" do
        results = Movie.budget_between(10_000_000, 50_000_000)
        expect(results).to all(have_attributes(budget: be_between(10_000_000, 50_000_000)))
      end
    end

    describe ".blockbusters" do
      it "returns movies with box_office > $500M" do
        results = Movie.blockbusters
        expect(results).to all(have_attributes(box_office: be > 500_000_000))
      end
    end

    describe ".box_office_flops" do
      it "returns movies with box_office < budget * 0.5" do
        results = Movie.box_office_flops
        results.each do |movie|
          expect(movie.box_office).to be < (movie.budget * 0.5)
        end
      end
    end
  end

  # ==================== YEAR & DATE QUERIES ====================
  describe "Year & Date Queries" do
    describe ".from_decade" do
      it "returns movies from specific decade" do
        results = Movie.from_decade(2000)
        expect(results).to all(have_attributes(release_year: be_between(2000, 2009)))
      end
    end

    describe ".released_between" do
      it "returns movies released between years" do
        results = Movie.released_between(2000, 2010)
        expect(results).to all(have_attributes(release_year: be_between(2000, 2010)))
      end
    end

    describe ".recent_movies" do
      it "returns movies from last 5 years" do
        current_year = Date.current.year
        results = Movie.recent_movies
        expect(results).to all(have_attributes(release_year: be >= (current_year - 5)))
      end
    end

    describe ".classic_movies" do
      it "returns movies before 1980" do
        results = Movie.classic_movies
        expect(results).to all(have_attributes(release_year: be < 1980))
      end
    end

    describe ".twenty_first_century" do
      it "returns movies from 2000 onwards" do
        results = Movie.twenty_first_century
        expect(results).to all(have_attributes(release_year: be >= 2000))
      end
    end
  end

  # ==================== ORDERING & LIMITING ====================
  describe "Ordering & Limiting" do
    describe ".by_rating_desc" do
      it "returns movies ordered by rating descending" do
        results = Movie.by_rating_desc.limit(10)
        ratings = results.pluck(:rating)
        expect(ratings).to eq(ratings.sort.reverse)
      end
    end

    describe ".by_year_desc" do
      it "returns movies ordered by release year descending" do
        results = Movie.by_year_desc.limit(10)
        years = results.pluck(:release_year)
        expect(years).to eq(years.sort.reverse)
      end
    end

    describe ".top_rated" do
      it "returns top N highest rated movies" do
        results = Movie.top_rated(5)
        expect(results.count).to eq(5)
        ratings = results.pluck(:rating)
        expect(ratings).to eq(ratings.sort.reverse)
      end
    end

    describe ".top_grossing" do
      it "returns top N highest grossing movies" do
        results = Movie.top_grossing(5)
        expect(results.count).to eq(5)
        box_office = results.pluck(:box_office)
        expect(box_office).to eq(box_office.sort.reverse)
      end
    end

    describe ".longest_movies" do
      it "returns longest movies by runtime" do
        results = Movie.longest_movies(5)
        expect(results.count).to eq(5)
        runtimes = results.pluck(:runtime)
        expect(runtimes).to eq(runtimes.sort.reverse)
      end
    end

    describe ".shortest_movies" do
      it "returns shortest movies by runtime" do
        results = Movie.shortest_movies(5)
        expect(results.count).to eq(5)
        runtimes = results.pluck(:runtime)
        expect(runtimes).to eq(runtimes.sort)
      end
    end

    describe ".paginated" do
      it "returns paginated results" do
        page1 = Movie.paginated(1, 10)
        page2 = Movie.paginated(2, 10)
        expect(page1.count).to eq(10)
        expect(page2.count).to eq(10)
        expect(page1.pluck(:id) & page2.pluck(:id)).to be_empty
      end
    end

    describe ".random_movies" do
      it "returns random movies" do
        results1 = Movie.random_movies(5)
        results2 = Movie.random_movies(5)
        expect(results1.count).to eq(5)
        expect(results2.count).to eq(5)
        # Note: This test might occasionally fail due to randomness
      end
    end
  end

  # ==================== STRING OPERATIONS ====================
  describe "String Operations" do
    describe ".search_title" do
      it "finds movies with case insensitive title search" do
        movie = Movie.first
        keyword = movie.title.split.first.downcase
        results = Movie.search_title(keyword)
        expect(results.pluck(:title).join.downcase).to include(keyword)
      end
    end

    describe ".title_starts_with" do
      it "finds movies with title starting with letter" do
        letter = Movie.first.title[0]
        results = Movie.title_starts_with(letter)
        expect(results).to all(have_attributes(title: start_with(letter)))
      end
    end

    describe ".title_ends_with" do
      it "finds movies with title ending with word" do
        word = "Movie"
        results = Movie.title_ends_with(word)
        results.each do |movie|
          expect(movie.title.downcase).to end_with(word.downcase)
        end
      end
    end

    describe ".title_contains" do
      it "finds movies with title containing word" do
        word = "The"
        results = Movie.title_contains(word)
        results.each do |movie|
          expect(movie.title.downcase).to include(word.downcase)
        end
      end
    end

    describe ".search_director" do
      it "finds movies by director partial match" do
        director = Movie.first.director
        partial_name = director.split.first
        results = Movie.search_director(partial_name)
        expect(results.pluck(:director).join.downcase).to include(partial_name.downcase)
      end
    end
  end

  # ==================== CALCULATIONS & AGGREGATIONS ====================
  describe "Calculations & Aggregations" do
    describe ".count_by_genre" do
      it "returns count of movies by genre" do
        results = Movie.count_by_genre
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Integer))
      end
    end

    describe ".average_rating_by_genre" do
      it "returns average rating by genre" do
        results = Movie.average_rating_by_genre
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Numeric))
      end
    end

    describe ".total_box_office_by_studio" do
      it "returns total box office by studio" do
        results = Movie.total_box_office_by_studio
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Numeric))
      end
    end

    describe ".count_by_director" do
      it "returns count of movies by director" do
        results = Movie.count_by_director
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Integer))
      end
    end

    describe ".average_budget_by_decade" do
      it "returns average budget by decade" do
        results = Movie.average_budget_by_decade
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Numeric))
      end
    end

    describe ".directors_with_most_movies" do
      it "returns directors ordered by movie count" do
        results = Movie.directors_with_most_movies(5)
        expect(results).to be_a(Hash)
        expect(results.count).to be <= 5
        counts = results.values
        expect(counts).to eq(counts.sort.reverse)
      end
    end

    describe ".total_runtime" do
      it "returns total runtime of all movies" do
        result = Movie.total_runtime
        expect(result).to be_a(Numeric)
        expect(result).to be > 0
      end
    end

    describe ".average_runtime" do
      it "returns average runtime" do
        result = Movie.average_runtime
        expect(result).to be_a(Numeric)
        expect(result).to be > 0
      end
    end

    describe ".highest_budget_movie" do
      it "returns movie with highest budget" do
        result = Movie.highest_budget_movie
        expect(result).to be_a(Movie)
        expect(result.budget).to eq(Movie.maximum(:budget))
      end
    end

    describe ".lowest_rated_movie" do
      it "returns movie with lowest rating" do
        result = Movie.lowest_rated_movie
        expect(result).to be_a(Movie)
        expect(result.rating).to eq(Movie.minimum(:rating))
      end
    end
  end

  # ==================== EXISTENCE & PRESENCE ====================
  describe "Existence & Presence" do
    describe ".genre_exists?" do
      it "returns true if genre exists" do
        genre = Movie.first.genre
        expect(Movie.genre_exists?(genre)).to be true
      end

      it "returns false if genre doesn't exist" do
        expect(Movie.genre_exists?("Non-existent Genre")).to be false
      end
    end

    describe ".director_exists?" do
      it "returns true if director has movies" do
        director = Movie.first.director
        expect(Movie.director_exists?(director)).to be true
      end

      it "returns false if director doesn't exist" do
        expect(Movie.director_exists?("Non-existent Director")).to be false
      end
    end

    describe ".has_highly_rated_in_genre?" do
      it "checks for highly rated movies in genre" do
        # Find a genre that has highly rated movies
        genre_with_high_rating = Movie.where("rating >= 8.0").first&.genre
        if genre_with_high_rating
          expect(Movie.has_highly_rated_in_genre?(genre_with_high_rating)).to be true
        else
          skip "No highly rated movies in test data"
        end
      end
    end

    describe ".with_missing_data" do
      it "finds movies with null/missing fields" do
        results = Movie.with_missing_data
        # This depends on test data having some missing fields
        expect(results).to be_a(ActiveRecord::Relation)
      end
    end

    describe ".complete_data" do
      it "finds movies with complete data" do
        results = Movie.complete_data
        expect(results).to be_a(ActiveRecord::Relation)
      end
    end
  end

  # ==================== DATA EXTRACTION ====================
  describe "Data Extraction" do
    describe ".all_genres" do
      it "returns array of unique genres" do
        results = Movie.all_genres
        expect(results).to be_a(Array)
        expect(results.uniq).to eq(results)
      end
    end

    describe ".all_directors" do
      it "returns array of unique directors" do
        results = Movie.all_directors
        expect(results).to be_a(Array)
        expect(results.uniq).to eq(results)
      end
    end

    describe ".all_titles" do
      it "returns array of all movie titles" do
        results = Movie.all_titles
        expect(results).to be_a(Array)
        expect(results.count).to eq(Movie.count)
      end
    end

    describe ".title_year_pairs" do
      it "returns array of [title, year] pairs" do
        results = Movie.title_year_pairs
        expect(results).to be_a(Array)
        expect(results.first).to be_a(Array)
        expect(results.first.count).to eq(2)
      end
    end

    describe ".unique_studios" do
      it "returns array of unique studios" do
        results = Movie.unique_studios
        expect(results).to be_a(Array)
        expect(results.uniq).to eq(results)
      end
    end

    describe ".rating_distribution" do
      it "returns hash of rating counts" do
        results = Movie.rating_distribution
        expect(results).to be_a(Hash)
        expect(results.values).to all(be_a(Integer))
      end
    end

    describe ".active_years" do
      it "returns sorted array of years with movies" do
        results = Movie.active_years
        expect(results).to be_a(Array)
        expect(results).to eq(results.sort)
      end
    end
  end

  # ==================== COMPLEX COMBINATIONS ====================
  describe "Complex Combinations" do
    describe ".expensive_flops" do
      it "finds high budget movies with low returns" do
        results = Movie.expensive_flops
        results.each do |movie|
          expect(movie.budget).to be > 50_000_000  # Expensive
          expect(movie.box_office).to be < (movie.budget * 0.8)  # Flop
        end
      end
    end

    describe ".surprise_hits" do
      it "finds low budget movies with high returns" do
        results = Movie.surprise_hits
        results.each do |movie|
          expect(movie.budget).to be < 20_000_000  # Low budget
          expect(movie.box_office).to be > (movie.budget * 3)  # High return
        end
      end
    end

    describe ".acclaimed_blockbusters" do
      it "finds highly rated high grossing movies" do
        results = Movie.acclaimed_blockbusters
        results.each do |movie|
          expect(movie.rating).to be >= 8.0
          expect(movie.box_office).to be > 200_000_000
        end
      end
    end

    describe ".long_highly_rated" do
      it "finds long movies with high ratings" do
        results = Movie.long_highly_rated
        results.each do |movie|
          expect(movie.runtime).to be > 150
          expect(movie.rating).to be >= 8.0
        end
      end
    end

    describe ".recent_big_budget" do
      it "finds recent high budget movies" do
        current_year = Date.current.year
        results = Movie.recent_big_budget
        results.each do |movie|
          expect(movie.release_year).to be >= (current_year - 5)
          expect(movie.budget).to be > 100_000_000
        end
      end
    end

    describe ".foreign_language_hits" do
      it "finds successful non-English movies" do
        results = Movie.foreign_language_hits
        results.each do |movie|
          expect(movie.language).not_to eq('English')
          expect(movie.box_office).to be > 50_000_000
        end
      end
    end
  end

  # Test additional method categories with basic structure
  # Students can expand these tests as they implement methods

  describe "Scoping & Chaining" do
    describe ".action_by_director" do
      it "returns action movies by specific director" do
        expect { Movie.action_by_director("Steven Spielberg") }.not_to raise_error
      end
    end
  end

  describe "Having Clauses" do
    describe ".genres_with_high_average_rating" do
      it "returns genres with high average ratings" do
        expect { Movie.genres_with_high_average_rating(7.0) }.not_to raise_error
      end
    end
  end

  describe "Select Specific Fields" do
    describe ".basic_info" do
      it "returns movies with basic info fields" do
        expect { Movie.basic_info }.not_to raise_error
      end
    end
  end

  describe "Language & Country" do
    describe ".in_language" do
      it "returns movies in specific language" do
        expect { Movie.in_language("English") }.not_to raise_error
      end
    end
  end

  describe "Runtime Queries" do
    describe ".longer_than" do
      it "returns movies longer than specified duration" do
        expect { Movie.longer_than(120) }.not_to raise_error
      end
    end
  end

  describe "Advanced Queries" do
    describe ".movie_statistics" do
      it "returns comprehensive statistics" do
        expect { Movie.movie_statistics }.not_to raise_error
      end
    end

    describe ".dynamic_query" do
      it "builds dynamic queries" do
        expect { Movie.dynamic_query({}) }.not_to raise_error
      end
    end
  end
end
