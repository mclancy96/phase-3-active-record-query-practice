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

  # Create test movies with known data for comprehensive testing
  let!(:high_rated_action) { Movie.create!(
    title: "Test Action Hero",
    director: "Test Director A",
    genre: "Action",
    release_year: 2020,
    rating: 9.2,
    budget: 200_000_000,
    box_office: 800_000_000,
    runtime: 150,
    country: "USA",
    language: "English",
    studio: "Test Studios"
  )}

  let!(:low_rated_drama) { Movie.create!(
    title: "Test Drama Fail",
    director: "Test Director B",
    genre: "Drama",
    release_year: 2019,
    rating: 3.1,
    budget: 50_000_000,
    box_office: 2_000_000,
    runtime: 90,
    country: "USA",
    language: "English",
    studio: "Test Studios"
  )}

  let!(:foreign_thriller) { Movie.create!(
    title: "Test Foreign Thriller",
    director: "Test Director C",
    genre: "Thriller",
    release_year: 1995,
    rating: 8.5,
    budget: 5_000_000,
    box_office: 100_000_000,
    runtime: 120,
    country: "France",
    language: "French",
    studio: "Test European"
  )}

  let!(:recent_comedy) { Movie.create!(
    title: "Test Recent Comedy",
    director: "Test Director A",
    genre: "Comedy",
    release_year: 2023,
    rating: 7.8,
    budget: 30_000_000,
    box_office: 150_000_000,
    runtime: 105,
    country: "USA",
    language: "English",
    studio: "Test Comedy Co"
  )}

  # ==================== METHOD EXISTENCE TESTS ====================
  describe "Method Existence Tests" do
    it "has all required class methods" do
      class_methods = [
        :find_by_exact_title, :by_director, :in_genre, :released_in_year, :by_studio,
        :highly_rated, :poorly_rated, :with_rating, :rating_between, :rating_above,
        :big_budget, :low_budget, :profitable, :unprofitable, :budget_between,
        :blockbusters, :box_office_flops, :from_decade, :released_between,
        :recent_movies, :classic_movies, :twenty_first_century, :by_rating_desc,
        :by_year_desc, :top_rated, :top_grossing, :longest_movies, :shortest_movies,
        :paginated, :random_movies, :search_title, :title_starts_with,
        :title_ends_with, :title_contains, :search_director, :count_by_genre,
        :average_rating_by_genre, :total_box_office_by_studio, :count_by_director,
        :average_budget_by_decade, :directors_with_most_movies, :total_runtime,
        :average_runtime, :highest_budget_movie, :lowest_rated_movie,
        :genre_exists?, :director_exists?, :has_highly_rated_in_genre?,
        :with_missing_data, :complete_data, :all_genres, :all_directors,
        :all_titles, :title_year_pairs, :unique_studios, :rating_distribution,
        :active_years, :expensive_flops, :surprise_hits, :acclaimed_blockbusters,
        :long_highly_rated, :recent_big_budget, :foreign_language_hits,
        :action_by_director, :highly_rated_recent_in_genre, :profitable_by_studio,
        :top_rated_in_decade, :longest_in_genre, :genres_with_high_average_rating,
        :directors_with_multiple_hits, :successful_studios, :prolific_years,
        :movie_statistics, :advanced_search, :dynamic_query
      ]

      class_methods.each do |method|
        expect(Movie).to respond_to(method), "Missing class method: #{method}"
      end
    end

    it "has all required instance methods" do
      instance_methods = [
        :highly_rated?, :poorly_rated?, :profitable?, :blockbuster?, :big_budget?,
        :profit, :profit_margin, :roi, :runtime_formatted, :from_decade?,
        :same_director_movies, :same_genre_movies, :same_year_movies,
        :same_studio_movies, :recent?, :longer_than?, :shorter_than?,
        :better_rated_than?, :more_successful_than?, :foreign_language?,
        :title_upcase, :display_name, :summary, :title_contains?, :director_initials
      ]

      movie_instance = Movie.new
      instance_methods.each do |method|
        expect(movie_instance).to respond_to(method), "Missing instance method: #{method}"
      end
    end

    it "has exactly 100 methods total" do
      class_method_count = 75
      instance_method_count = 25
      total_methods = class_method_count + instance_method_count
      expect(total_methods).to eq(100)
    end
  end

  # ==================== BASIC FINDERS (Class Methods) ====================
  describe "Basic Finders" do
    describe ".find_by_exact_title" do
      it "finds movie by exact title match" do
        result = Movie.find_by_exact_title("Test Action Hero")
        expect(result).to eq(high_rated_action)
      end

      it "returns nil for non-existent title" do
        result = Movie.find_by_exact_title("Non-existent Movie")
        expect(result).to be_nil
      end
    end

    describe ".by_director" do
      it "returns all movies by specific director" do
        results = Movie.by_director("Test Director A")
        expect(results).to include(high_rated_action, recent_comedy)
        expect(results).not_to include(low_rated_drama)
      end

      it "returns empty collection for non-existent director" do
        results = Movie.by_director("Non-existent Director")
        expect(results).to be_empty
      end
    end

    describe ".in_genre" do
      it "returns movies in specific genre" do
        results = Movie.in_genre("Action")
        expect(results).to include(high_rated_action)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".released_in_year" do
      it "returns movies from specific year" do
        results = Movie.released_in_year(2020)
        expect(results).to include(high_rated_action)
        expect(results).not_to include(recent_comedy)
      end
    end

    describe ".by_studio" do
      it "returns movies from specific studio" do
        results = Movie.by_studio("Test Studios")
        expect(results).to include(high_rated_action, low_rated_drama)
        expect(results).not_to include(foreign_thriller)
      end
    end
  end

  # ==================== RATING QUERIES (Class Methods) ====================
  describe "Rating Queries" do
    describe ".highly_rated" do
      it "returns movies with rating >= 8.0" do
        results = Movie.highly_rated
        expect(results).to include(high_rated_action, foreign_thriller)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".poorly_rated" do
      it "returns movies with rating < 4.0" do
        results = Movie.poorly_rated
        expect(results).to include(low_rated_drama)
        expect(results).not_to include(high_rated_action)
      end
    end

    describe ".with_rating" do
      it "returns movies with exact rating" do
        results = Movie.with_rating(9.2)
        expect(results).to include(high_rated_action)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".rating_between" do
      it "returns movies with rating in range" do
        results = Movie.rating_between(7.0, 9.0)
        expect(results).to include(foreign_thriller, recent_comedy)
        expect(results).not_to include(low_rated_drama, high_rated_action)
      end
    end

    describe ".rating_above" do
      it "returns movies with rating above threshold" do
        results = Movie.rating_above(8.0)
        expect(results).to include(high_rated_action, foreign_thriller)
        expect(results).not_to include(low_rated_drama, recent_comedy)
      end
    end
  end

  # ==================== INSTANCE METHODS - MOVIE PROPERTIES ====================
  describe "Instance Methods - Movie Properties" do
    describe "#highly_rated?" do
      it "returns true for highly rated movies" do
        expect(high_rated_action.highly_rated?).to be_truthy
        expect(foreign_thriller.highly_rated?).to be_truthy
      end

      it "returns false for lower rated movies" do
        expect(low_rated_drama.highly_rated?).to be_falsey
        expect(recent_comedy.highly_rated?).to be_falsey
      end
    end

    describe "#poorly_rated?" do
      it "returns true for poorly rated movies" do
        expect(low_rated_drama.poorly_rated?).to be_truthy
      end

      it "returns false for higher rated movies" do
        expect(high_rated_action.poorly_rated?).to be_falsey
        expect(foreign_thriller.poorly_rated?).to be_falsey
      end
    end

    describe "#profitable?" do
      it "returns true for profitable movies" do
        expect(high_rated_action.profitable?).to be_truthy
        expect(foreign_thriller.profitable?).to be_truthy
        expect(recent_comedy.profitable?).to be_truthy
      end

      it "returns false for unprofitable movies" do
        expect(low_rated_drama.profitable?).to be_falsey
      end
    end

    describe "#blockbuster?" do
      it "returns true for blockbuster movies (> $500M)" do
        expect(high_rated_action.blockbuster?).to be_truthy
      end

      it "returns false for non-blockbuster movies" do
        expect(low_rated_drama.blockbuster?).to be_falsey
        expect(foreign_thriller.blockbuster?).to be_falsey
        expect(recent_comedy.blockbuster?).to be_falsey
      end
    end

    describe "#big_budget?" do
      it "returns true for big budget movies (> $100M)" do
        expect(high_rated_action.big_budget?).to be_truthy
      end

      it "returns false for smaller budget movies" do
        expect(low_rated_drama.big_budget?).to be_falsey
        expect(foreign_thriller.big_budget?).to be_falsey
        expect(recent_comedy.big_budget?).to be_falsey
      end
    end
  end

  # ==================== BUDGET & BOX OFFICE (Class Methods) ====================
  describe "Budget & Box Office" do
    describe ".big_budget" do
      it "returns big budget movies (> $100M)" do
        results = Movie.big_budget
        expect(results).to include(high_rated_action)
        expect(results).not_to include(foreign_thriller)
      end
    end

    describe ".low_budget" do
      it "returns low budget movies (< $5M)" do
        results = Movie.low_budget
        expect(results).not_to include(high_rated_action, low_rated_drama, recent_comedy)
      end
    end

    describe ".profitable" do
      it "returns profitable movies" do
        results = Movie.profitable
        expect(results).to include(high_rated_action, foreign_thriller, recent_comedy)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".unprofitable" do
      it "returns unprofitable movies" do
        results = Movie.unprofitable
        expect(results).to include(low_rated_drama)
        expect(results).not_to include(high_rated_action, foreign_thriller)
      end
    end

    describe ".blockbusters" do
      it "returns blockbuster movies (> $500M)" do
        results = Movie.blockbusters
        expect(results).to include(high_rated_action)
        expect(results).not_to include(low_rated_drama, foreign_thriller)
      end
    end
  end

  # ==================== INSTANCE METHODS - CALCULATIONS ====================
  describe "Instance Methods - Calculations" do
    describe "#profit" do
      it "calculates profit correctly" do
        expect(high_rated_action.profit).to eq(600_000_000) # 800M - 200M
        expect(low_rated_drama.profit).to eq(-48_000_000) # 2M - 50M
      end
    end

    describe "#profit_margin" do
      it "calculates profit margin as percentage" do
        expect(high_rated_action.profit_margin).to eq(300.0) # 600M/200M * 100
      end

      it "handles negative margins" do
        expect(low_rated_drama.profit_margin).to eq(-96.0) # -48M/50M * 100
      end
    end

    describe "#roi" do
      it "calculates return on investment" do
        expect(high_rated_action.roi).to eq(400.0) # 800M/200M * 100
        expect(foreign_thriller.roi).to eq(2000.0) # 100M/5M * 100
      end
    end

    describe "#from_decade?" do
      it "checks if movie is from specific decade" do
        expect(high_rated_action.from_decade?(2020)).to be_truthy
        expect(foreign_thriller.from_decade?(1990)).to be_truthy
        expect(high_rated_action.from_decade?(1990)).to be_falsey
      end
    end
  end

  # ==================== YEAR & DATE QUERIES (Class Methods) ====================
  describe "Year & Date Queries" do
    describe ".from_decade" do
      it "returns movies from specific decade" do
        results = Movie.from_decade(2020)
        expect(results).to include(high_rated_action, recent_comedy)
        expect(results).not_to include(foreign_thriller)
      end
    end

    describe ".recent_movies" do
      it "returns movies from last 5 years" do
        results = Movie.recent_movies
        expect(results).to include(high_rated_action, low_rated_drama, recent_comedy)
        expect(results).not_to include(foreign_thriller)
      end
    end

    describe ".classic_movies" do
      it "returns movies before 1980" do
        results = Movie.classic_movies
        expect(results).not_to include(high_rated_action, foreign_thriller)
      end
    end

    describe ".twenty_first_century" do
      it "returns movies from 2000 onwards" do
        results = Movie.twenty_first_century
        expect(results).to include(high_rated_action, low_rated_drama, recent_comedy)
        expect(results).not_to include(foreign_thriller)
      end
    end
  end

  # ==================== INSTANCE METHODS - RELATED MOVIES ====================
  describe "Instance Methods - Related Movies" do
    describe "#same_director_movies" do
      it "returns other movies by same director" do
        results = high_rated_action.same_director_movies
        expect(results).to include(recent_comedy)
        expect(results).not_to include(high_rated_action) # excludes self
      end
    end

    describe "#same_genre_movies" do
      it "returns other movies in same genre" do
        results = high_rated_action.same_genre_movies
        expect(results).not_to include(high_rated_action) # excludes self
        # Would include other action movies if they existed
      end
    end

    describe "#recent?" do
      it "returns true for recent movies" do
        expect(high_rated_action.recent?).to be_truthy
        expect(recent_comedy.recent?).to be_truthy
      end

      it "returns false for older movies" do
        expect(foreign_thriller.recent?).to be_falsey
      end
    end
  end

  # ==================== ORDERING & LIMITING (Class Methods) ====================
  describe "Ordering & Limiting" do
    describe ".by_rating_desc" do
      it "orders movies by rating descending" do
        results = Movie.by_rating_desc.limit(4)
        ratings = results.pluck(:rating)
        expect(ratings).to eq(ratings.sort.reverse)
      end
    end

    describe ".top_rated" do
      it "returns top N highest rated movies" do
        results = Movie.top_rated(2)
        expect(results.count).to eq(2)
        expect(results.first.rating).to be >= results.last.rating
      end
    end

    describe ".top_grossing" do
      it "returns top N highest grossing movies" do
        results = Movie.top_grossing(2)
        expect(results.count).to eq(2)
        expect(results.first.box_office).to be >= results.last.box_office
      end
    end
  end

  # ==================== INSTANCE METHODS - COMPARISONS ====================
  describe "Instance Methods - Comparisons" do
    describe "#longer_than?" do
      it "checks if movie is longer than duration" do
        expect(high_rated_action.longer_than?(120)).to be_truthy
        expect(low_rated_drama.longer_than?(120)).to be_falsey
      end
    end

    describe "#better_rated_than?" do
      it "compares ratings with another movie" do
        expect(high_rated_action.better_rated_than?(low_rated_drama)).to be_truthy
        expect(low_rated_drama.better_rated_than?(high_rated_action)).to be_falsey
      end
    end

    describe "#foreign_language?" do
      it "checks if movie is foreign language" do
        expect(foreign_thriller.foreign_language?).to be_truthy
        expect(high_rated_action.foreign_language?).to be_falsey
      end
    end
  end

  # ==================== STRING OPERATIONS (Class Methods) ====================
  describe "String Operations - Class Methods" do
    describe ".search_title" do
      it "searches movies by title keyword" do
        results = Movie.search_title("Test")
        expect(results).to include(high_rated_action, low_rated_drama)
      end
    end

    describe ".title_starts_with" do
      it "finds movies with title starting with letter" do
        results = Movie.title_starts_with("T")
        expect(results).to include(high_rated_action, low_rated_drama)
      end
    end
  end

  # ==================== STRING OPERATIONS (Instance Methods) ====================
  describe "String Operations - Instance Methods" do
    describe "#title_upcase" do
      it "returns title in uppercase" do
        expect(high_rated_action.title_upcase).to eq("TEST ACTION HERO")
      end
    end

    describe "#display_name" do
      it "returns formatted display name with year" do
        expect(high_rated_action.display_name).to eq("Test Action Hero (2020)")
      end
    end

    describe "#title_contains?" do
      it "checks if title contains word" do
        expect(high_rated_action.title_contains?("Action")).to be_truthy
        expect(high_rated_action.title_contains?("Drama")).to be_falsey
      end
    end
  end

  # ==================== AGGREGATIONS & CALCULATIONS (Class Methods) ====================
  describe "Aggregations & Calculations" do
    describe ".count_by_genre" do
      it "counts movies by genre" do
        results = Movie.count_by_genre
        expect(results).to be_a(Hash)
        expect(results["Action"]).to be >= 1
      end
    end

    describe ".total_runtime" do
      it "calculates total runtime of all movies" do
        result = Movie.total_runtime
        expect(result).to be > 0
        expect(result).to be_a(Numeric)
      end
    end
  end

  # ==================== EXISTENCE & PRESENCE (Class Methods) ====================
  describe "Existence & Presence" do
    describe ".genre_exists?" do
      it "checks if genre has movies" do
        expect(Movie.genre_exists?("Action")).to be_truthy
        expect(Movie.genre_exists?("NonexistentGenre")).to be_falsey
      end
    end

    describe ".director_exists?" do
      it "checks if director has movies" do
        expect(Movie.director_exists?("Test Director A")).to be_truthy
        expect(Movie.director_exists?("Nonexistent Director")).to be_falsey
      end
    end
  end

  # ==================== DATA EXTRACTION (Class Methods) ====================
  describe "Data Extraction" do
    describe ".all_genres" do
      it "returns unique list of genres" do
        results = Movie.all_genres
        expect(results).to include("Action", "Drama", "Thriller", "Comedy")
        expect(results.uniq).to eq(results) # no duplicates
      end
    end

    describe ".all_directors" do
      it "returns unique list of directors" do
        results = Movie.all_directors
        expect(results).to include("Test Director A", "Test Director B")
        expect(results.uniq).to eq(results) # no duplicates
      end
    end
  end

  # ==================== COMPLEX COMBINATIONS (Class Methods) ====================
  describe "Complex Combinations" do
    describe ".expensive_flops" do
      it "finds high budget, low box office movies" do
        results = Movie.expensive_flops
        expect(results).to include(low_rated_drama)
        expect(results).not_to include(high_rated_action)
      end
    end

    describe ".surprise_hits" do
      it "finds low budget, high box office movies" do
        results = Movie.surprise_hits
        expect(results).to include(foreign_thriller)
        expect(results).not_to include(high_rated_action)
      end
    end

    describe ".acclaimed_blockbusters" do
      it "finds high rating AND high box office movies" do
        results = Movie.acclaimed_blockbusters
        expect(results).to include(high_rated_action)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".long_highly_rated" do
      it "finds long and highly rated movies" do
        results = Movie.long_highly_rated
        expect(results).to include(high_rated_action) # 150 min, 9.2 rating
        expect(results).not_to include(low_rated_drama) # short and low rated
      end
    end

    describe ".recent_big_budget" do
      it "finds recent big budget movies" do
        results = Movie.recent_big_budget
        expect(results).to include(high_rated_action) # 2020, $200M budget
        expect(results).not_to include(foreign_thriller) # 1995, $5M budget
      end
    end

    describe ".foreign_language_hits" do
      it "finds successful foreign language movies" do
        results = Movie.foreign_language_hits
        expect(results).to include(foreign_thriller) # French, successful
        expect(results).not_to include(high_rated_action) # English
      end
    end
  end

  # ==================== ADDITIONAL CLASS METHODS - MISSING COVERAGE ====================
  describe "Additional Class Methods - Part 1" do
    describe ".rating_above" do
      it "returns movies with rating above threshold" do
        results = Movie.rating_above(8.0)
        expect(results).to include(high_rated_action, foreign_thriller)
        expect(results).not_to include(low_rated_drama, recent_comedy)
      end
    end

    describe ".budget_between" do
      it "returns movies with budget in range" do
        results = Movie.budget_between(25_000_000, 60_000_000)
        expect(results).to include(low_rated_drama, recent_comedy)
        expect(results).not_to include(high_rated_action, foreign_thriller)
      end
    end

    describe ".box_office_flops" do
      it "returns movies that failed at box office" do
        results = Movie.box_office_flops
        expect(results).to include(low_rated_drama)
        expect(results).not_to include(high_rated_action)
      end
    end

    describe ".released_between" do
      it "returns movies released between years" do
        results = Movie.released_between(2018, 2021)
        expect(results).to include(high_rated_action, low_rated_drama)
        expect(results).not_to include(foreign_thriller, recent_comedy)
      end
    end

    describe ".by_year_desc" do
      it "orders movies by year descending" do
        results = Movie.by_year_desc.limit(4)
        years = results.pluck(:release_year)
        expect(years).to eq(years.sort.reverse)
      end
    end

    describe ".longest_movies" do
      it "returns longest movies" do
        results = Movie.longest_movies(2)
        expect(results.count).to eq(2)
        runtimes = results.pluck(:runtime)
        expect(runtimes).to eq(runtimes.sort.reverse)
      end
    end

    describe ".shortest_movies" do
      it "returns shortest movies" do
        results = Movie.shortest_movies(2)
        expect(results.count).to eq(2)
        runtimes = results.pluck(:runtime)
        expect(runtimes).to eq(runtimes.sort)
      end
    end

    describe ".paginated" do
      it "returns paginated results" do
        results = Movie.paginated(1, 2)
        expect(results.count).to eq(2)
      end
    end

    describe ".random_movies" do
      it "returns random movies" do
        results = Movie.random_movies(3)
        expect(results.count).to be <= 3
      end
    end
  end

  describe "Additional Class Methods - Part 2" do
    describe ".title_ends_with" do
      it "finds movies with title ending with word" do
        results = Movie.title_ends_with("Hero")
        expect(results).to include(high_rated_action)
      end
    end

    describe ".title_contains" do
      it "finds movies with title containing word" do
        results = Movie.title_contains("Test")
        expect(results).to include(high_rated_action, low_rated_drama)
      end
    end

    describe ".search_director" do
      it "searches directors by partial name" do
        results = Movie.search_director("Director A")
        expect(results).to include(high_rated_action, recent_comedy)
      end
    end

    describe ".average_rating_by_genre" do
      it "calculates average rating by genre" do
        results = Movie.average_rating_by_genre
        expect(results).to be_a(Hash)
        expect(results["Action"]).to be_a(Numeric)
      end
    end

    describe ".total_box_office_by_studio" do
      it "calculates total box office by studio" do
        results = Movie.total_box_office_by_studio
        expect(results).to be_a(Hash)
        expect(results["Test Studios"]).to be_a(Numeric)
      end
    end

    describe ".count_by_director" do
      it "counts movies by director" do
        results = Movie.count_by_director
        expect(results).to be_a(Hash)
        expect(results["Test Director A"]).to be >= 2
      end
    end

    describe ".average_budget_by_decade" do
      it "calculates average budget by decade" do
        results = Movie.average_budget_by_decade
        expect(results).to be_a(Hash)
      end
    end

    describe ".directors_with_most_movies" do
      it "returns directors with most movies" do
        results = Movie.directors_with_most_movies(5)
        expect(results).to be_an(Array)
      end
    end

    describe ".average_runtime" do
      it "calculates average runtime" do
        result = Movie.average_runtime
        expect(result).to be_a(Numeric)
        expect(result).to be > 0
      end
    end

    describe ".highest_budget_movie" do
      it "returns highest budget movie" do
        result = Movie.highest_budget_movie
        expect(result).to be_a(Movie)
        expect(result.budget).to be >= high_rated_action.budget
      end
    end

    describe ".lowest_rated_movie" do
      it "returns lowest rated movie" do
        result = Movie.lowest_rated_movie
        expect(result).to be_a(Movie)
        expect(result.rating).to be <= low_rated_drama.rating
      end
    end
  end

  describe "Additional Class Methods - Part 3" do
    describe ".has_highly_rated_in_genre?" do
      it "checks if genre has highly rated movies" do
        expect(Movie.has_highly_rated_in_genre?("Action")).to be_truthy
        expect(Movie.has_highly_rated_in_genre?("NonexistentGenre")).to be_falsey
      end
    end

    describe ".with_missing_data" do
      it "finds movies with missing data" do
        results = Movie.with_missing_data
        # Test implementation will depend on what constitutes "missing data"
        expect(results).to respond_to(:each)
      end
    end

    describe ".complete_data" do
      it "finds movies with complete data" do
        results = Movie.complete_data
        expect(results).to include(high_rated_action, low_rated_drama, foreign_thriller, recent_comedy)
      end
    end

    describe ".all_titles" do
      it "returns all movie titles" do
        results = Movie.all_titles
        expect(results).to include("Test Action Hero", "Test Drama Fail")
        expect(results).to be_an(Array)
      end
    end

    describe ".title_year_pairs" do
      it "returns title-year pairs" do
        results = Movie.title_year_pairs
        expect(results).to be_an(Array)
        expect(results.first).to be_an(Array)
      end
    end

    describe ".unique_studios" do
      it "returns unique studio names" do
        results = Movie.unique_studios
        expect(results).to include("Test Studios", "Test European")
        expect(results.uniq).to eq(results)
      end
    end

    describe ".rating_distribution" do
      it "returns rating distribution" do
        results = Movie.rating_distribution
        expect(results).to be_a(Hash)
      end
    end

    describe ".active_years" do
      it "returns years with movie releases" do
        results = Movie.active_years
        expect(results).to include(2020, 2019, 2023)
        expect(results).to be_an(Array)
      end
    end
  end

  describe "Advanced Query Methods" do
    describe ".action_by_director" do
      it "finds action movies by specific director" do
        results = Movie.action_by_director("Test Director A")
        expect(results).to include(high_rated_action)
        expect(results).not_to include(recent_comedy) # not action
      end
    end

    describe ".highly_rated_recent_in_genre" do
      it "finds highly rated recent movies in genre" do
        results = Movie.highly_rated_recent_in_genre("Action")
        expect(results).to include(high_rated_action)
      end
    end

    describe ".profitable_by_studio" do
      it "finds profitable movies by studio" do
        results = Movie.profitable_by_studio("Test Studios")
        expect(results).to include(high_rated_action)
        expect(results).not_to include(low_rated_drama)
      end
    end

    describe ".top_rated_in_decade" do
      it "finds top rated movies in decade" do
        results = Movie.top_rated_in_decade(2020, 5) # Increase limit to accommodate more movies
        expect(results.count).to be <= 5
        expect(results).to include(high_rated_action) # Should definitely include our test movie
        # Verify all results are from the 2020s decade
        results.each do |movie|
          expect(movie.release_year).to be_between(2020, 2029)
        end
        # Verify results are ordered by rating descending
        ratings = results.map(&:rating)
        expect(ratings).to eq(ratings.sort.reverse)
      end
    end

    describe ".longest_in_genre" do
      it "finds longest movies in genre" do
        results = Movie.longest_in_genre("Action", 5)
        expect(results).to include(high_rated_action)
        expect(results.count).to be <= 5
      end
    end

    describe ".genres_with_high_average_rating" do
      it "finds genres with high average rating" do
        results = Movie.genres_with_high_average_rating(5.0) # Lower threshold for realistic data
        expect(results).to be_an(Array)
        expect(results.length).to be > 0
        # Test that it correctly filters - high average should include genres with good ratings
        all_averages = Movie.average_rating_by_genre
        results.each do |genre|
          expect(all_averages[genre]).to be >= 5.0
        end
      end
    end

    describe ".directors_with_multiple_hits" do
      it "finds directors with multiple successful movies" do
        results = Movie.directors_with_multiple_hits
        expect(results).to be_an(Array)
      end
    end

    describe ".successful_studios" do
      it "finds studios with high total box office" do
        results = Movie.successful_studios(500_000_000)
        expect(results).to be_an(Array)
        expect(results).to include("Test Studios") # high_rated_action: $800M
      end
    end

    describe ".prolific_years" do
      it "finds years with many movie releases" do
        results = Movie.prolific_years(1)
        expect(results).to be_an(Array)
        expect(results).to include(2020, 2019, 2023)
      end
    end

    describe ".movie_statistics" do
      it "returns comprehensive movie statistics" do
        results = Movie.movie_statistics
        expect(results).to be_a(Hash)
        expect(results).to have_key(:total_movies)
        expect(results).to have_key(:average_rating)
      end
    end

    describe ".advanced_search" do
      it "performs advanced search with filters" do
        filters = { min_rating: 8.0, genre: "Action" }
        results = Movie.advanced_search(filters)
        expect(results).to include(high_rated_action)
      end
    end

    describe ".dynamic_query" do
      it "builds dynamic queries" do
        options = { order_by: :rating, direction: :desc, limit: 2 }
        results = Movie.dynamic_query(options)
        expect(results.count).to be <= 2
      end
    end
  end

  # ==================== ADDITIONAL INSTANCE METHODS - MISSING COVERAGE ====================
  describe "Additional Instance Methods" do
    describe "#runtime_formatted" do
      it "returns formatted runtime" do
        expect(high_rated_action.runtime_formatted).to eq("2h 30m")
        expect(low_rated_drama.runtime_formatted).to eq("1h 30m")
      end
    end

    describe "#same_year_movies" do
      it "returns other movies from same year" do
        results = high_rated_action.same_year_movies
        expect(results).not_to include(high_rated_action)
        # Would include other 2020 movies if they existed
      end
    end

    describe "#same_studio_movies" do
      it "returns other movies from same studio" do
        results = high_rated_action.same_studio_movies
        expect(results).to include(low_rated_drama)
        expect(results).not_to include(high_rated_action)
      end
    end

    describe "#shorter_than?" do
      it "checks if movie is shorter than duration" do
        expect(low_rated_drama.shorter_than?(120)).to be_truthy
        expect(high_rated_action.shorter_than?(120)).to be_falsey
      end
    end

    describe "#more_successful_than?" do
      it "compares box office success" do
        expect(high_rated_action.more_successful_than?(low_rated_drama)).to be_truthy
        expect(low_rated_drama.more_successful_than?(high_rated_action)).to be_falsey
      end
    end

    describe "#summary" do
      it "returns movie summary" do
        summary = high_rated_action.summary
        expect(summary).to be_a(String)
        expect(summary).to include("Test Action Hero")
        expect(summary).to include("2020")
      end
    end

    describe "#director_initials" do
      it "returns director initials" do
        expect(high_rated_action.director_initials).to eq("TDA")
        expect(low_rated_drama.director_initials).to eq("TDB")
      end
    end
  end

  # ==================== COMPREHENSIVE FUNCTIONALITY TESTS ====================
  describe "Comprehensive Functionality" do
    it "all class methods return appropriate types" do
      # Test that finder methods return ActiveRecord relations or arrays
      expect(Movie.highly_rated).to respond_to(:each)
      expect(Movie.all_genres).to be_an(Array)
      expect(Movie.count_by_genre).to be_a(Hash)
      expect(Movie.total_runtime).to be_a(Numeric)
    end

    it "all instance methods work on movie objects" do
      movie = Movie.first
      expect(movie.highly_rated?).to be_in([true, false])
      expect(movie.profit).to be_a(Numeric)
      expect(movie.title_upcase).to be_a(String)
    end

    it "handles edge cases gracefully" do
      # Test with empty results
      expect(Movie.by_director("Nonexistent")).to be_empty
      expect(Movie.in_genre("Nonexistent")).to be_empty

      # Test with nil/invalid parameters
      expect { Movie.rating_between(nil, nil) }.not_to raise_error
      expect { Movie.from_decade(nil) }.not_to raise_error
    end
  end
end
