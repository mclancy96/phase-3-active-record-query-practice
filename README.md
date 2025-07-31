# Movie Database Query Challenge

A comprehensive ActiveRecord practice challenge focused on mastering query methods using a movie database domain model.

## 🎯 Learning Objectives

By completing this challenge, you will master:

- All major ActiveRecord query methods
- Complex query combinations and chaining
- Aggregation and calculation methods
- String operations and pattern matching
- Date and numeric comparisons
- Grouping and having clauses
- Advanced SQL techniques within ActiveRecord
- Query optimization and best practices

## 🎬 Domain Model

**Movie** has the following attributes:

- `title` (string) - Movie title
- `director` (string) - Director name
- `genre` (string) - Movie genre
- `release_year` (integer) - Year of release
- `rating` (decimal) - Movie rating (1.0 - 10.0)
- `budget` (decimal) - Production budget in dollars
- `box_office` (decimal) - Total box office earnings
- `runtime` (integer) - Runtime in minutes
- `country` (string) - Country of origin
- `language` (string) - Primary language
- `studio` (string) - Production studio

## 🚀 Getting Started

### Setup

```bash
# Install dependencies
bundle install

# Setup database and seed data
bundle exec rake db:reset

# Run tests
bundle exec rake spec

# Start console for testing
bundle exec rake console
```

### Database Info

- **Database**: SQLite3
- **Records**: 300+ diverse movies
- **Test Coverage**: 100+ comprehensive test cases
- **Genres**: 20 different genres
- **Time Period**: Movies from 1920s to 2020s
- **Global**: Multiple countries and languages

## 📋 Challenge: Implement 100 Query Methods

Your task is to implement **100 different query methods** in the `Movie` model. Each method demonstrates different ActiveRecord query techniques.

### Method Categories

#### 🔍 **Basic Finders (5 methods)**

1. `find_by_exact_title(title)` - Find movie by exact title
2. `by_director(director_name)` - Movies by specific director
3. `in_genre(genre_name)` - Movies in specific genre
4. `released_in_year(year)` - Movies from specific year
5. `by_studio(studio_name)` - Movies from specific studio

#### ⭐ **Rating Queries (5 methods)**

6. `highly_rated` - Movies with rating >= 8.0
7. `poorly_rated` - Movies with rating < 4.0
8. `with_rating(rating)` - Movies with exact rating
9. `rating_between(min, max)` - Movies with rating in range
10. `rating_above(threshold)` - Movies above rating threshold

#### 💰 **Budget & Box Office (7 methods)**

11. `big_budget` - Movies with budget > $100M
12. `low_budget` - Movies with budget < $5M
13. `profitable` - Movies where box_office > budget
14. `unprofitable` - Movies where box_office < budget
15. `budget_between(min, max)` - Movies with budget in range
16. `blockbusters` - Movies with box_office > $500M
17. `box_office_flops` - Movies with box_office < budget \* 0.5

#### 📅 **Year & Date Queries (5 methods)**

18. `from_decade(decade)` - Movies from specific decade (e.g., 1990s)
19. `released_between(start_year, end_year)` - Movies in year range
20. `recent_movies` - Movies from last 5 years
21. `classic_movies` - Movies before 1980
22. `twenty_first_century` - Movies from 2000 onwards

#### 📊 **Ordering & Limiting (8 methods)**

23. `by_rating_desc` - Movies ordered by rating (highest first)
24. `by_year_desc` - Movies ordered by year (newest first)
25. `top_rated(limit)` - Top N highest rated movies
26. `top_grossing(limit)` - Top N highest grossing movies
27. `longest_movies(limit)` - Top N longest movies
28. `shortest_movies(limit)` - Top N shortest movies
29. `paginated(page, per_page)` - Paginated results
30. `random_movies(count)` - Random selection of movies

#### 🔤 **String Operations (5 methods)**

31. `search_title(keyword)` - Case insensitive title search
32. `title_starts_with(letter)` - Titles starting with letter
33. `title_ends_with(word)` - Titles ending with word
34. `title_contains(word)` - Titles containing word
35. `search_director(name)` - Director name partial match

#### 🧮 **Calculations & Aggregations (10 methods)**

36. `count_by_genre` - Count movies by genre
37. `average_rating_by_genre` - Average rating per genre
38. `total_box_office_by_studio` - Total earnings per studio
39. `count_by_director` - Count movies per director
40. `average_budget_by_decade` - Average budget per decade
41. `directors_with_most_movies(limit)` - Most prolific directors
42. `total_runtime` - Sum of all movie runtimes
43. `average_runtime` - Average movie length
44. `highest_budget_movie` - Movie with highest budget
45. `lowest_rated_movie` - Movie with lowest rating

#### ✅ **Existence & Presence (5 methods)**

46. `genre_exists?(genre)` - Check if genre exists
47. `director_exists?(director)` - Check if director has movies
48. `has_highly_rated_in_genre?(genre)` - Genre has highly rated movies
49. `with_missing_data` - Movies with null/missing fields
50. `complete_data` - Movies with complete data

#### 📋 **Data Extraction (7 methods)**

51. `all_genres` - Array of unique genres
52. `all_directors` - Array of unique directors
53. `all_titles` - Array of all movie titles
54. `title_year_pairs` - Array of [title, year] pairs
55. `unique_studios` - Array of unique studios
56. `rating_distribution` - Hash of rating counts
57. `active_years` - Sorted array of years with movies

#### 🎯 **Complex Combinations (6 methods)**

58. `expensive_flops` - High budget, low box office
59. `surprise_hits` - Low budget, high box office
60. `acclaimed_blockbusters` - High rating, high box office
61. `long_highly_rated` - Long runtime, high rating
62. `recent_big_budget` - Recent + high budget
63. `foreign_language_hits` - Non-English successful movies

#### 🔗 **Scoping & Chaining (5 methods)**

64. `action_by_director(director)` - Action movies by director
65. `highly_rated_recent_in_genre(genre)` - Multiple conditions
66. `profitable_by_studio(studio)` - Profitable movies by studio
67. `top_rated_in_decade(decade, limit)` - Best of decade
68. `longest_in_genre(genre, limit)` - Longest in genre

#### 📈 **Having Clauses (4 methods)**

69. `genres_with_high_average_rating(threshold)` - Genres above rating
70. `directors_with_multiple_hits` - Directors with multiple good movies
71. `successful_studios(min_total)` - Studios above total box office
72. `prolific_years(min_count)` - Years with many releases

#### 🎛️ **Select Specific Fields (4 methods)**

73. `basic_info` - Select title, director, year
74. `financial_info` - Select title, budget, box_office
75. `with_profit_calculation` - Add calculated profit column
76. `with_profit_margin` - Add calculated profit margin

#### 🌍 **Language & Country (6 methods)**

77. `in_language(language)` - Movies in specific language
78. `from_country(country)` - Movies from specific country
79. `english_language` - English language movies
80. `foreign_language` - Non-English movies
81. `count_by_language` - Count by language
82. `count_by_country` - Count by country

#### ⏱️ **Runtime Queries (5 methods)**

83. `longer_than(minutes)` - Movies longer than duration
84. `shorter_than(minutes)` - Movies shorter than duration
85. `runtime_between(min, max)` - Runtime in range
86. `epic_movies` - Movies > 3 hours (180 min)
87. `short_movies` - Movies < 90 minutes

#### 🔧 **Advanced SQL Fragments (3 methods)**

88. `complex_rating_search(min_rating, genre)` - Complex WHERE with SQL
89. `movies_with_roi_above(roi_threshold)` - Return on investment calculation
90. `matching_genres(genre_list)` - Movies matching genre list

#### 🏆 **Final Complex Queries (10 methods)**

91. `movie_statistics` - Comprehensive stats hash
92. `best_in_each_genre` - Top movie per genre
93. `most_profitable_director` - Director with highest total profit
94. `best_decade_by_rating` - Decade with best average rating
95. `studio_dominance_by_genre` - Studio market share by genre
96. `advanced_search(filters)` - Dynamic search with filters hash
97. `similar_to(movie_id)` - Find similar movies
98. `trending_analysis` - Analyze trends over time
99. `outliers` - Find movies with unusual patterns
100.  `dynamic_query(options)` - Ultimate dynamic query builder

## 🧪 Testing

Each method must pass comprehensive RSpec tests:

```bash
# Run all tests
bundle exec rake spec

# Run specific test group
bundle exec rspec spec/movie_spec.rb -e "Basic Finders"

# Run single test
bundle exec rspec spec/movie_spec.rb -e "find_by_exact_title"
```

### Test Categories

- **Correctness**: Returns expected data
- **Data Types**: Returns proper Ruby types
- **Edge Cases**: Handles empty results, nil inputs
- **Performance**: Efficient query patterns
- **Multiple Scenarios**: Various test conditions

## 💡 Query Method Examples

### Basic Example

```ruby
# Find movies by director
def self.by_director(director_name)
  where(director: director_name)
end
```

### Intermediate Example

```ruby
# Find profitable movies
def self.profitable
  where("box_office > budget")
end
```

### Advanced Example

```ruby
# Find genres with high average rating
def self.genres_with_high_average_rating(threshold = 7.0)
  group(:genre)
    .average(:rating)
    .select { |genre, avg_rating| avg_rating >= threshold }
end
```

## 📚 ActiveRecord Methods Reference

### Query Methods

- `.where()` - Filter records
- `.find()` - Find by ID
- `.find_by()` - Find first matching
- `.order()` - Sort results
- `.limit()` - Limit number of results
- `.offset()` - Skip results (pagination)
- `.group()` - Group by column
- `.having()` - Filter groups
- `.joins()` - Join tables
- `.includes()` - Eager loading
- `.select()` - Choose specific columns
- `.distinct()` - Remove duplicates
- `.exists?()` - Check existence

### Calculation Methods

- `.count()` - Count records
- `.sum()` - Sum numeric column
- `.average()` - Calculate average
- `.minimum()` - Find minimum value
- `.maximum()` - Find maximum value
- `.pluck()` - Extract column values

### String Matching

- `LIKE` - Pattern matching
- `ILIKE` - Case insensitive matching (PostgreSQL)
- Wildcards: `%` (any chars), `_` (single char)

### Comparison Operators

- `>`, `<`, `>=`, `<=` - Numeric comparisons
- `BETWEEN` - Range comparisons
- `IN` - Match any in list
- `IS NULL`, `IS NOT NULL` - Null checks

## 🎯 Success Criteria

To complete this challenge successfully:

1. ✅ Implement all 100 methods in `app/models/movie.rb`
2. ✅ All RSpec tests pass (`bundle exec rake spec`)
3. ✅ Use appropriate ActiveRecord query methods (no raw SQL unless specified)
4. ✅ Handle edge cases (empty results, nil inputs)
5. ✅ Follow Ruby naming conventions
6. ✅ Write efficient queries (avoid N+1 problems)
7. ✅ Use proper return types (ActiveRecord::Relation, Array, Hash, etc.)

## 🏃‍♂️ Getting Started Tips

1. **Start Simple**: Begin with basic finders and work up to complex queries
2. **Use Console**: Test queries in `bundle exec rake console` before implementing
3. **Read Tests**: Understand what each test expects
4. **Check Data**: Use `Movie.first` to see sample data structure
5. **Reference Docs**: Use ActiveRecord documentation for query methods
6. **Debug**: Use `.to_sql` to see generated SQL queries

## 🔗 Resources

- [ActiveRecord Query Interface Guide](https://guides.rubyonrails.org/active_record_querying.html)
- [ActiveRecord API Documentation](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html)
- [SQL Tutorial](https://www.w3schools.com/sql/)

## 🎉 Bonus Challenges

After completing all 100 methods:

1. **Performance Analysis**: Use `EXPLAIN` to analyze query performance
2. **Index Optimization**: Add database indexes for better performance
3. **Custom Scope Chain**: Create chainable scope methods
4. **Query Caching**: Implement query result caching
5. **Benchmark Queries**: Compare different query approaches

Good luck mastering ActiveRecord query methods! 🚀
