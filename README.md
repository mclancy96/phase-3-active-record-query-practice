# ActiveRecord Query Practice Challenge

A comprehensive ActiveRecord query practice challenge for Phase 3 students. This challenge focuses on mastering ActiveRecord query methods through implementing 100 different methods on a Movie model.

## Overview

This challenge provides hands-on practice with:
- **75 Class Methods** - Methods that work on collections of movies
- **25 Instance Methods** - Methods that work on individual movie objects
- Complex ActiveRecord queries including joins, aggregations, and calculations
- Real-world database scenarios with 300+ diverse movie records

## Learning Objectives

By completing this challenge, you will master:
- ActiveRecord query methods (`.where`, `.find_by`, `.order`, `.limit`, etc.)
- Aggregation methods (`.count`, `.sum`, `.average`, `.group`, etc.)
- Comparison operators and SQL fragments
- Method chaining and scoping
- **Class vs Instance Methods** - Understanding when to use each approach
- Complex query building and optimization

## Setup

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Set up the database:**
   ```bash
   bundle exec rake db:create_migration
   bundle exec rake db:migrate
   bundle exec rake db:seed
   ```

3. **Verify setup:**
   ```bash
   bundle exec rake db:reset
   bundle exec rspec --format documentation
   ```

## Understanding Method Types

This challenge includes both **class methods** and **instance methods** to give you comprehensive ActiveRecord practice:

### Class Methods (75 methods)
Class methods work on collections and are called on the `Movie` class itself:
```ruby
# Examples of class methods
Movie.highly_rated          # Returns collection of movies with rating >= 8.0
Movie.by_director("Nolan")  # Returns collection of movies by Christopher Nolan
Movie.from_decade(1990)     # Returns collection of movies from the 1990s
```

Use class methods when you need to:
- Query multiple records
- Filter collections
- Perform aggregations across many records
- Get statistical data

### Instance Methods (25 methods)
Instance methods work on individual movie objects:
```ruby
# Examples of instance methods
movie = Movie.first
movie.highly_rated?         # Returns true/false for this specific movie
movie.profit               # Returns the profit for this specific movie
movie.same_director_movies # Returns other movies by the same director
```

Use instance methods when you need to:
- Check properties of a single record
- Perform calculations on one record
- Compare one record with others
- Format data for a specific record

## Database Schema

The `movies` table includes:
- `title` (string) - Movie title
- `director` (string) - Director name  
- `genre` (string) - Movie genre
- `release_year` (integer) - Year released
- `rating` (decimal) - IMDb-style rating (1.0-10.0)
- `budget` (integer) - Production budget in dollars
- `box_office` (integer) - Box office earnings in dollars
- `runtime` (integer) - Runtime in minutes
- `country` (string) - Country of origin
- `language` (string) - Primary language
- `studio` (string) - Production studio

## Method Categories

### Basic Finders (Class Methods)
1. `find_by_exact_title(title)` - Find movie by exact title match
2. `by_director(director_name)` - Find movies by director
3. `in_genre(genre_name)` - Find movies in specific genre
4. `released_in_year(year)` - Find movies from specific year
5. `by_studio(studio_name)` - Find movies by studio

### Rating Queries (Class Methods)
6. `highly_rated` - Movies with rating >= 8.0
7. `poorly_rated` - Movies with rating < 4.0
8. `with_rating(rating)` - Movies with exact rating
9. `rating_between(min, max)` - Movies with rating in range
10. `rating_above(threshold)` - Movies above rating threshold

### Movie Properties (Instance Methods)
11. `highly_rated?` - Check if this movie is highly rated
12. `poorly_rated?` - Check if this movie is poorly rated
13. `profitable?` - Check if this movie is profitable
14. `blockbuster?` - Check if this movie is a blockbuster
15. `big_budget?` - Check if this movie has big budget

### Budget & Box Office (Class Methods)
16. `big_budget` - Movies with budget > $100M
17. `low_budget` - Movies with budget < $5M
18. `profitable` - Movies where box_office > budget
19. `unprofitable` - Movies where box_office < budget
20. `budget_between(min, max)` - Movies with budget in range
21. `blockbusters` - Movies with box_office > $500M
22. `box_office_flops` - Movies with poor box office performance

### Calculations (Instance Methods)
23. `profit` - Calculate profit for this movie
24. `profit_margin` - Calculate profit margin percentage
25. `roi` - Calculate return on investment
26. `runtime_formatted` - Format runtime as "2h 15m"
27. `from_decade?(decade)` - Check if movie is from specific decade

### Year & Date Queries (Class Methods)
28. `from_decade(decade)` - Movies from specific decade
29. `released_between(start_year, end_year)` - Movies in year range
30. `recent_movies` - Movies from last 5 years
31. `classic_movies` - Movies before 1980
32. `twenty_first_century` - Movies from 2000 onwards

### Related Movies (Instance Methods)
33. `same_director_movies` - Other movies by same director
34. `same_genre_movies` - Other movies in same genre
35. `same_year_movies` - Other movies from same year
36. `same_studio_movies` - Other movies from same studio
37. `recent?` - Check if movie is recent

### Ordering & Limiting (Class Methods)
38. `by_rating_desc` - Movies ordered by rating (highest first)
39. `by_year_desc` - Movies ordered by year (newest first)
40. `top_rated(limit)` - Top N highest rated movies
41. `top_grossing(limit)` - Top N highest grossing movies
42. `longest_movies(limit)` - Longest movies by runtime
43. `shortest_movies(limit)` - Shortest movies by runtime
44. `paginated(page, per_page)` - Paginated results
45. `random_movies(count)` - Random selection of movies

### Comparisons (Instance Methods)
46. `longer_than?(minutes)` - Check if movie is longer than duration
47. `shorter_than?(minutes)` - Check if movie is shorter than duration
48. `better_rated_than?(other_movie)` - Compare ratings with another movie
49. `more_successful_than?(other_movie)` - Compare box office with another movie
50. `foreign_language?` - Check if movie is foreign language

### String Operations (Class Methods)
51. `search_title(keyword)` - Search movies by title
52. `title_starts_with(letter)` - Movies with title starting with letter
53. `title_ends_with(word)` - Movies with title ending with word
54. `title_contains(word)` - Movies with title containing word
55. `search_director(name)` - Search directors by name

### String Operations (Instance Methods)
56. `title_upcase` - Get title in uppercase
57. `display_name` - Get formatted "Title (Year)" string
58. `summary` - Get formatted movie summary
59. `title_contains?(word)` - Check if title contains word
60. `director_initials` - Get director's initials

### Calculations & Aggregations (Class Methods)
61-70. Various aggregation methods including counts, averages, and statistics

### Existence & Presence (Class Methods)  
71-75. Methods to check existence of records and data completeness

### Data Extraction (Class Methods)
76-82. Methods to extract lists and distributions of data

### Complex Combinations (Class Methods)
83-88. Advanced queries combining multiple conditions

### Scoping & Chaining (Class Methods)
89-93. Methods demonstrating ActiveRecord method chaining

### Having Clauses (Class Methods)
94-97. Advanced GROUP BY with HAVING conditions

### Advanced Complex Queries (Class Methods)
98-100. Ultimate challenge methods with dynamic query building

## Running Tests

**Run all tests:**
```bash
bundle exec rspec
```

**Run with detailed output:**
```bash
bundle exec rspec --format documentation
```

**Run specific test groups:**
```bash
bundle exec rspec --format documentation -t "Basic Finders"
```

## Console Testing

Test your implementations in the Rails console:
```bash
bundle exec rake console
```

Example console usage:
```ruby
# Test class methods
Movie.highly_rated
Movie.by_director("Christopher Nolan")
Movie.count_by_genre

# Test instance methods
movie = Movie.first
movie.highly_rated?
movie.profit
movie.same_director_movies
```

## Tips for Success

1. **Start with the basics** - Begin with simple `.where` queries before moving to complex aggregations
2. **Read the TODO comments** - Each method has hints about which ActiveRecord methods to use
3. **Test frequently** - Run tests often to verify your implementations
4. **Use the console** - Experiment with queries in the console to understand the data
5. **Understand method types** - Pay attention to whether you're implementing a class or instance method
6. **Chain methods** - Many solutions require chaining multiple ActiveRecord methods
7. **Refer to documentation** - Use the [ActiveRecord Query Guide](https://guides.rubyonrails.org/active_record_querying.html)

## Method Implementation Examples

### Class Method Example:
```ruby
def self.highly_rated
  where('rating >= ?', 8.0)
end
```

### Instance Method Example:
```ruby
def highly_rated?
  rating >= 8.0
end
```

### Method Chaining Example:
```ruby
def self.top_rated_in_decade(decade, limit = 5)
  from_decade(decade).order(rating: :desc).limit(limit)
end
```

## Submission

Complete all 100 methods in `app/models/movie.rb`. Your implementations should:
- Pass all RSpec tests
- Use appropriate ActiveRecord query methods
- Follow Ruby naming conventions
- Handle edge cases appropriately
- Demonstrate understanding of both class and instance method patterns

Good luck with your ActiveRecord query practice!
