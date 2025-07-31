class Movie < ActiveRecord::Base
  # ==================== BASIC FINDERS (Class Methods) ====================

  # 1. Find movie by exact title
  def self.find_by_exact_title(title)
    find_by(title: title)
  end

  # 2. Find all movies by director
  def self.by_director(director_name)
    where(director: director_name)
  end

  # 3. Find movies in specific genre
  def self.in_genre(genre_name)
    where(genre: genre_name)
  end

  # 4. Find movies released in specific year
  def self.released_in_year(year)
    where(release_year: year)
  end

  # 5. Find movies by studio
  def self.by_studio(studio_name)
    where(studio: studio_name)
  end

  # ==================== RATING QUERIES (Class Methods) ====================

  # 6. Find highly rated movies (>= 8.0)
  def self.highly_rated
    where("rating >= ?", 8.0)
  end

  # 7. Find poorly rated movies (< 4.0)
  def self.poorly_rated
    where("rating < ?", 4.0)
  end

  # 8. Find movies with specific rating
  def self.with_rating(rating)
    where(rating: rating)
  end

  # 9. Find movies with rating between range
  def self.rating_between(min_rating, max_rating)
    where(rating: min_rating..max_rating)
  end

  # 10. Find movies with rating above threshold
  def self.rating_above(threshold)
    where("rating > ?", threshold)
  end

  # ==================== INSTANCE METHODS - MOVIE PROPERTIES ====================

  # 11. Check if this movie is highly rated (>= 8.0)
  def highly_rated?
    rating >= 8.0
  end

  # 12. Check if this movie is poorly rated (< 4.0)
  def poorly_rated?
    rating < 4.0
  end

  # 13. Check if this movie is profitable
  def profitable?
    box_office > budget
  end

  # 14. Check if this movie is a blockbuster (> $500M box office)
  def blockbuster?
    box_office > 500_000_000
  end

  # 15. Check if this movie is big budget (> $100M)
  def big_budget?
    budget > 100_000_000
  end

  # ==================== BUDGET & BOX OFFICE (Class Methods) ====================

  # 16. Find big budget movies (> $100M)
  def self.big_budget
    where("budget > ?", 100_000_000)
  end

  # 17. Find low budget movies (< $5M)
  def self.low_budget
    where("budget < ?", 5_000_000)
  end

  # 18. Find profitable movies
  def self.profitable
    where("box_office > budget")
  end

  # 19. Find unprofitable movies
  def self.unprofitable
    where("box_office <= budget")
  end

  # 20. Find movies with budget in range
  def self.budget_between(min_budget, max_budget)
    where(budget: min_budget..max_budget)
  end

  # 21. Find blockbuster movies (> $500M box office)
  def self.blockbusters
    where("box_office > ?", 500_000_000)
  end

  # 22. Find box office flops (< $10M box office)
  def self.box_office_flops
    where("box_office < ?", 10_000_000)
  end

  # ==================== INSTANCE METHODS - CALCULATIONS ====================

  # 23. Calculate profit
  def profit
    box_office - budget
  end

  # 24. Calculate profit margin as percentage
  def profit_margin
    return 0 if budget.zero?
    ((box_office - budget).to_f / budget * 100).round(2)
  end

  # 25. Calculate return on investment
  def roi
    return 0 if budget.zero?
    (box_office.to_f / budget * 100).round(2)
  end

  # 26. Format runtime as "Xh Ym"
  def runtime_formatted
    return "0m" if runtime.nil? || runtime.zero?
    hours = runtime / 60
    minutes = runtime % 60
    "#{hours}h #{minutes}m"
  end

  # 27. Check if movie is from specific decade
  def from_decade?(decade)
    return false if release_year.nil?
    release_year >= decade && release_year < decade + 10
  end

  # ==================== YEAR & DATE QUERIES (Class Methods) ====================

  # 28. Find movies from specific decade
  def self.from_decade(decade)
    return none if decade.nil?
    where(release_year: decade..decade+9)
  end

  # 29. Find movies released between years
  def self.released_between(start_year, end_year)
    where(release_year: start_year..end_year)
  end

  # 30. Find recent movies (last 5 years)
  def self.recent_movies
    current_year = Date.current.year
    where("release_year >= ?", current_year - 6)
  end

  # 31. Find classic movies (before 1980)
  def self.classic_movies
    where("release_year < ?", 1980)
  end

  # 32. Find 21st century movies (2000 onwards)
  def self.twenty_first_century
    where("release_year >= ?", 2000)
  end

  # ==================== INSTANCE METHODS - RELATED MOVIES ====================

  # 33. Find other movies by same director
  def same_director_movies
    self.class.where(director: director).where.not(id: id)
  end

  # 34. Find other movies in same genre
  def same_genre_movies
    self.class.where(genre: genre).where.not(id: id)
  end

  # 35. Find other movies from same year
  def same_year_movies
    self.class.where(release_year: release_year).where.not(id: id)
  end

  # 36. Find other movies from same studio
  def same_studio_movies
    self.class.where(studio: studio).where.not(id: id)
  end

  # 37. Check if movie is recent (within last 5 years)
  def recent?
    return false if release_year.nil?
    release_year >= Date.current.year - 6
  end

  # ==================== ORDERING & LIMITING (Class Methods) ====================

  # 38. Order movies by rating descending
  def self.by_rating_desc
    order(rating: :desc)
  end

  # 39. Order movies by year descending
  def self.by_year_desc
    order(release_year: :desc)
  end

  # 40. Get top N highest rated movies
  def self.top_rated(limit = 10)
    order(rating: :desc).limit(limit)
  end

  # 41. Get top N highest grossing movies
  def self.top_grossing(limit = 10)
    order(box_office: :desc).limit(limit)
  end

  # 42. Get longest movies
  def self.longest_movies(limit = 10)
    order(runtime: :desc).limit(limit)
  end

  # 43. Get shortest movies
  def self.shortest_movies(limit = 10)
    order(runtime: :asc).limit(limit)
  end

  # 44. Paginate results
  def self.paginated(page, per_page = 20)
    offset((page - 1) * per_page).limit(per_page)
  end

  # 45. Get random movies
  def self.random_movies(count = 5)
    order("RANDOM()").limit(count)
  end

  # ==================== INSTANCE METHODS - COMPARISONS ====================

  # 46. Check if movie is longer than duration
  def longer_than?(minutes)
    return false if runtime.nil?
    runtime > minutes
  end

  # 47. Check if movie is shorter than duration
  def shorter_than?(minutes)
    return false if runtime.nil?
    runtime < minutes
  end

  # 48. Compare ratings with another movie
  def better_rated_than?(other_movie)
    return false if rating.nil? || other_movie.rating.nil?
    rating > other_movie.rating
  end

  # 49. Compare box office success
  def more_successful_than?(other_movie)
    return false if box_office.nil? || other_movie.box_office.nil?
    box_office > other_movie.box_office
  end

  # 50. Check if movie is foreign language
  def foreign_language?
    language != "English"
  end

  # ==================== STRING OPERATIONS (Class Methods) ====================

  # 51. Search movies by title keyword
  def self.search_title(keyword)
    where("title LIKE ?", "%#{keyword}%")
  end

  # 52. Find movies with title starting with letter
  def self.title_starts_with(letter)
    where("title LIKE ?", "#{letter}%")
  end

  # 53. Find movies with title ending with word
  def self.title_ends_with(word)
    where("title LIKE ?", "%#{word}")
  end

  # 54. Find movies with title containing word
  def self.title_contains(word)
    where("title LIKE ?", "%#{word}%")
  end

  # 55. Search directors by partial name
  def self.search_director(name)
    where("director LIKE ?", "%#{name}%")
  end

  # ==================== STRING OPERATIONS (Instance Methods) ====================

  # 56. Return title in uppercase
  def title_upcase
    title.upcase
  end

  # 57. Return formatted display name with year
  def display_name
    "#{title} (#{release_year})"
  end

  # 58. Return movie summary
  def summary
    "#{title} (#{release_year}) - #{genre} film directed by #{director}. Rating: #{rating}/10"
  end

  # 59. Check if title contains word
  def title_contains?(word)
    title.downcase.include?(word.downcase)
  end

  # 60. Return director initials
  def director_initials
    director.split.map(&:first).join
  end

  # ==================== AGGREGATIONS & CALCULATIONS (Class Methods) ====================

  # 61. Count movies by genre
  def self.count_by_genre
    group(:genre).count
  end

  # 62. Calculate average rating by genre
  def self.average_rating_by_genre
    group(:genre).average(:rating)
  end

  # 63. Calculate total box office by studio
  def self.total_box_office_by_studio
    group(:studio).sum(:box_office)
  end

  # 64. Count movies by director
  def self.count_by_director
    group(:director).count
  end

  # 65. Calculate average budget by decade
  def self.average_budget_by_decade
    select(Arel.sql("(release_year / 10) * 10 as decade, AVG(budget) as avg_budget"))
      .group(Arel.sql("(release_year / 10) * 10"))
      .pluck(Arel.sql("(release_year / 10) * 10"), Arel.sql("AVG(budget)"))
      .to_h
  end

  # 66. Find directors with most movies
  def self.directors_with_most_movies(limit = 10)
    group(:director).count.sort_by { |_, count| -count }.first(limit).map(&:first)
  end

  # 67. Calculate total runtime of all movies
  def self.total_runtime
    sum(:runtime)
  end

  # 68. Calculate average runtime
  def self.average_runtime
    average(:runtime)
  end

  # 69. Find highest budget movie
  def self.highest_budget_movie
    order(budget: :desc).first
  end

  # 70. Find lowest rated movie
  def self.lowest_rated_movie
    order(rating: :asc).first
  end

  # ==================== EXISTENCE & PRESENCE (Class Methods) ====================

  # 71. Check if genre exists
  def self.genre_exists?(genre_name)
    exists?(genre: genre_name)
  end

  # 72. Check if director exists
  def self.director_exists?(director_name)
    exists?(director: director_name)
  end

  # 73. Check if genre has highly rated movies
  def self.has_highly_rated_in_genre?(genre_name)
    exists?(genre: genre_name, rating: 8.0..Float::INFINITY)
  end

  # 74. Find movies with missing data
  def self.with_missing_data
    where("rating IS NULL OR budget IS NULL OR box_office IS NULL OR runtime IS NULL")
  end

  # 75. Find movies with complete data
  def self.complete_data
    where.not(rating: nil).where.not(budget: nil).where.not(box_office: nil).where.not(runtime: nil)
  end

  # ==================== DATA EXTRACTION (Class Methods) ====================

  # 76. Get all unique genres
  def self.all_genres
    distinct.pluck(:genre).compact.sort
  end

  # 77. Get all unique directors
  def self.all_directors
    distinct.pluck(:director).compact.sort
  end

  # 78. Get all movie titles
  def self.all_titles
    pluck(:title)
  end

  # 79. Get title-year pairs
  def self.title_year_pairs
    pluck(:title, :release_year)
  end

  # 80. Get unique studio names
  def self.unique_studios
    distinct.pluck(:studio).compact.sort
  end

  # 81. Get rating distribution
  def self.rating_distribution
    group("ROUND(rating)").count
  end

  # 82. Get active years (years with releases)
  def self.active_years
    distinct.pluck(:release_year).compact.sort
  end

  # ==================== COMPLEX COMBINATIONS (Class Methods) ====================

  # 83. Find expensive flops (high budget, low box office)
  def self.expensive_flops
    where("budget >= ? AND box_office < budget * 0.5", 50_000_000)
  end

  # 84. Find surprise hits (low budget, high box office)
  def self.surprise_hits
    where("budget < ? AND box_office > budget * 10", 20_000_000)
  end

  # 85. Find acclaimed blockbusters (high rating AND high box office)
  def self.acclaimed_blockbusters
    where("rating >= ? AND box_office > ?", 8.0, 500_000_000)
  end

  # 86. Find long highly rated movies
  def self.long_highly_rated
    where("runtime > ? AND rating >= ?", 120, 8.0)
  end

  # 87. Find recent big budget movies
  def self.recent_big_budget
    current_year = Date.current.year
    where("release_year >= ? AND budget > ?", current_year - 6, 100_000_000)
  end

  # 88. Find successful foreign language movies
  def self.foreign_language_hits
    where.not(language: "English").where("box_office > budget * 5")
  end

  # ==================== ADVANCED QUERY METHODS (Class Methods) ====================

  # 89. Find action movies by specific director
  def self.action_by_director(director_name)
    where(genre: "Action", director: director_name)
  end

  # 90. Find highly rated recent movies in genre
  def self.highly_rated_recent_in_genre(genre_name)
    current_year = Date.current.year
    where(genre: genre_name)
      .where("rating >= ?", 8.0)
      .where("release_year >= ?", current_year - 6)
  end

  # 91. Find profitable movies by studio
  def self.profitable_by_studio(studio_name)
    where(studio: studio_name).where("box_office > budget")
  end

  # 92. Find top rated movies in decade
  def self.top_rated_in_decade(decade, limit = 5)
    where(release_year: decade..decade+9)
      .order(rating: :desc)
      .limit(limit)
  end

  # 93. Find longest movies in genre
  def self.longest_in_genre(genre_name, limit = 5)
    where(genre: genre_name)
      .order(runtime: :desc)
      .limit(limit)
  end

  # 94. Find genres with high average rating
  def self.genres_with_high_average_rating(threshold = 6.5)
    group(:genre)
      .having("AVG(rating) >= ?", threshold)
      .pluck(:genre)
  end

  # 95. Find directors with multiple hits
  def self.directors_with_multiple_hits
    joins("INNER JOIN (#{select(:director).where('box_office > budget * 3').group(:director).having('COUNT(*) >= 2').to_sql}) hits ON hits.director = movies.director")
      .distinct
      .pluck(:director)
  end

  # 96. Find successful studios
  def self.successful_studios(min_total = 1_000_000_000)
    group(:studio)
      .having("SUM(box_office) >= ?", min_total)
      .pluck(:studio)
  end

  # 97. Find prolific years
  def self.prolific_years(min_count = 10)
    group(:release_year)
      .having("COUNT(*) >= ?", min_count)
      .pluck(:release_year)
  end

  # 98. Get comprehensive movie statistics
  def self.movie_statistics
    {
      total_movies: count,
      average_rating: average(:rating)&.round(2),
      average_budget: average(:budget)&.round(0),
      average_box_office: average(:box_office)&.round(0),
      total_box_office: sum(:box_office),
      most_common_genre: group(:genre).count.max_by { |_, count| count }&.first,
      year_range: [minimum(:release_year), maximum(:release_year)]
    }
  end

  # 99. Advanced search with multiple filters
  def self.advanced_search(filters = {})
    query = all
    query = query.where("rating >= ?", filters[:min_rating]) if filters[:min_rating]
    query = query.where("rating <= ?", filters[:max_rating]) if filters[:max_rating]
    query = query.where(genre: filters[:genre]) if filters[:genre]
    query = query.where("release_year >= ?", filters[:min_year]) if filters[:min_year]
    query = query.where("release_year <= ?", filters[:max_year]) if filters[:max_year]
    query = query.where("budget >= ?", filters[:min_budget]) if filters[:min_budget]
    query = query.where("budget <= ?", filters[:max_budget]) if filters[:max_budget]
    query
  end

  # 100. Dynamic query builder
  def self.dynamic_query(options = {})
    query = all

    # Apply ordering
    if options[:order_by]
      direction = options[:direction] || :asc
      query = query.order(options[:order_by] => direction)
    end

    # Apply limit
    query = query.limit(options[:limit]) if options[:limit]

    # Apply offset
    query = query.offset(options[:offset]) if options[:offset]

    query
  end
end
