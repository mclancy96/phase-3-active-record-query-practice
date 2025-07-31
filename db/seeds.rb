require_relative '../config/environment'

# Clear existing data if table exists
begin
  Movie.destroy_all
rescue ActiveRecord::StatementInvalid
  # Table doesn't exist yet, that's OK
end

puts "Creating diverse movie dataset..."

# Genres to cover
genres = ['Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi', 'Romance', 'Thriller', 'Fantasy', 'Animation', 'Documentary', 'Crime', 'Adventure', 'Mystery', 'War', 'Western', 'Musical', 'Biography', 'Family', 'Sport', 'History']

# Major studios
studios = ['Warner Bros.', 'Universal Pictures', 'Paramount Pictures', '20th Century Fox', 'Sony Pictures', 'Disney', 'MGM', 'Columbia Pictures', 'Lionsgate', 'New Line Cinema', 'Miramax', 'Focus Features', 'A24', 'Searchlight Pictures', 'United Artists', 'Legendary Entertainment', 'Summit Entertainment', 'StudioCanal', 'Working Title Films', 'Independent']

# Directors (mix of famous and lesser known)
directors = [
  'Steven Spielberg', 'Christopher Nolan', 'Martin Scorsese', 'Quentin Tarantino', 'Tim Burton',
  'Ridley Scott', 'James Cameron', 'George Lucas', 'Alfred Hitchcock', 'Stanley Kubrick',
  'Francis Ford Coppola', 'David Fincher', 'Paul Thomas Anderson', 'Wes Anderson', 'Coen Brothers',
  'Spike Lee', 'Woody Allen', 'Clint Eastwood', 'Ron Howard', 'Robert Zemeckis',
  'John Carpenter', 'Sam Raimi', 'Guillermo del Toro', 'Jordan Peele', 'Greta Gerwig',
  'Denis Villeneuve', 'Rian Johnson', 'Ari Aster', 'Robert Eggers', 'Chloé Zhao',
  'Kathryn Bigelow', 'Sofia Coppola', 'Patty Jenkins', 'Lulu Wang', 'Barry Jenkins',
  'Ryan Coogler', 'Taika Waititi', 'Yorgos Lanthimos', 'Luca Guadagnino', 'Chazelle Damien'
]

# Countries and languages
countries = ['USA', 'UK', 'France', 'Germany', 'Italy', 'Spain', 'Japan', 'South Korea', 'China', 'India', 'Canada', 'Australia', 'Mexico', 'Brazil', 'Russia', 'Poland', 'Sweden', 'Denmark', 'Netherlands', 'New Zealand']
languages = ['English', 'Spanish', 'French', 'German', 'Italian', 'Japanese', 'Korean', 'Mandarin', 'Hindi', 'Portuguese', 'Russian', 'Polish', 'Swedish', 'Danish', 'Dutch', 'Arabic', 'Hebrew', 'Thai', 'Turkish', 'Greek']

# Sample movie titles by genre
movie_titles = {
  'Action' => ['Thunder Force', 'Steel Warriors', 'Night Raid', 'Velocity', 'Iron Strike', 'Shadow Operations', 'Crimson Dawn', 'Code Red', 'Firepower', 'Last Stand'],
  'Comedy' => ['Laugh Track', 'Comic Relief', 'Funny Business', 'Jest Quest', 'Smile Factory', 'Humor Me', 'Chuckle Vision', 'Wit Happens', 'Gag Reel', 'Belly Laughs'],
  'Drama' => ['Deep Waters', 'Emotional Journey', 'Life Stories', 'Human Condition', 'Tears of Joy', 'Heart Strings', 'Soul Search', 'Breaking Point', 'Inner Light', 'Truth Unveiled'],
  'Horror' => ['Midnight Terror', 'Haunted Mansion', 'Scream Factory', 'Dark Shadows', 'Nightmare Fuel', 'Blood Moon', 'Evil Awakens', 'Paranormal', 'Creepy Crawlers', 'Fear Factor'],
  'Sci-Fi' => ['Future World', 'Space Odyssey', 'Cyber Dreams', 'Time Paradox', 'Alien Contact', 'Robot Revolution', 'Quantum Leap', 'Star Voyage', 'Tech Noir', 'Galaxy Quest'],
  'Romance' => ['Love Story', 'Heart to Heart', 'Romantic Getaway', 'Love Letters', 'Cupid\'s Arrow', 'Sweet Dreams', 'Together Forever', 'First Kiss', 'Wedding Bells', 'Love Actually'],
  'Thriller' => ['Edge of Danger', 'Suspense', 'Cat and Mouse', 'Mind Games', 'High Stakes', 'Ticking Clock', 'Double Cross', 'Final Hour', 'Tension Rising', 'Close Call'],
  'Fantasy' => ['Magic Kingdom', 'Dragon Quest', 'Enchanted Forest', 'Wizard\'s Tale', 'Fairy Tale', 'Mythical Journey', 'Spell Bound', 'Magical Realm', 'Fantasy Island', 'Dream World'],
  'Animation' => ['Cartoon Adventures', 'Animated Dreams', 'Pixel Perfect', 'Toon Town', 'Character Study', 'Frame by Frame', 'Moving Pictures', 'Art in Motion', 'Colorful World', 'Digital Magic'],
  'Documentary' => ['Real Stories', 'Truth Revealed', 'Behind the Scenes', 'Documentary Film', 'Life Examined', 'Hidden Truth', 'Investigative Report', 'Real World', 'Fact or Fiction', 'True Story']
}

movies_data = []

# Create diverse movies
300.times do |i|
  genre = genres.sample
  title_base = movie_titles[genre]&.sample || "#{genre} Movie #{i + 1}"
  # Check for duplicate titles only if table exists
  begin
    title = "#{title_base} #{rand(1000..9999)}" if Movie.exists?(title: title_base)
  rescue ActiveRecord::StatementInvalid
    # Table doesn't exist yet, that's OK
  end
  title ||= title_base

  # Generate realistic release years with different distributions
  if rand < 0.6
    release_year = rand(2000..2024)  # 60% modern movies
  elsif rand < 0.8
    release_year = rand(1980..1999)  # 20% 80s-90s movies
  else
    release_year = rand(1920..1979)  # 20% classic movies
  end

  # Generate ratings with realistic distribution
  if rand < 0.1
    rating = rand(1.0..3.0).round(1)  # 10% terrible movies
  elsif rand < 0.3
    rating = rand(3.1..5.0).round(1)  # 20% below average
  elsif rand < 0.7
    rating = rand(5.1..7.0).round(1)  # 40% average movies
  elsif rand < 0.9
    rating = rand(7.1..8.5).round(1)  # 20% good movies
  else
    rating = rand(8.6..10.0).round(1) # 10% excellent movies
  end

  # Generate budgets based on release year and genre
  case genre
  when 'Action', 'Sci-Fi', 'Fantasy', 'Adventure'
    if release_year >= 2010
      budget = rand(50_000_000..300_000_000)
    elsif release_year >= 1990
      budget = rand(20_000_000..150_000_000)
    else
      budget = rand(1_000_000..50_000_000)
    end
  when 'Animation'
    if release_year >= 2000
      budget = rand(75_000_000..200_000_000)
    else
      budget = rand(10_000_000..100_000_000)
    end
  when 'Documentary', 'Drama', 'Horror'
    if release_year >= 2000
      budget = rand(500_000..25_000_000)
    else
      budget = rand(100_000..10_000_000)
    end
  else
    if release_year >= 2000
      budget = rand(5_000_000..80_000_000)
    else
      budget = rand(500_000..30_000_000)
    end
  end

  # Generate box office based on budget, rating, and genre
  multiplier = case rating
               when 8.0..10.0 then rand(2.5..6.0)
               when 7.0..7.9 then rand(1.8..4.0)
               when 6.0..6.9 then rand(1.2..2.5)
               when 4.0..5.9 then rand(0.6..1.5)
               else rand(0.1..0.8)
               end

  # Some movies are flops regardless of quality
  multiplier *= 0.3 if rand < 0.15

  # Blockbusters sometimes exceed expectations
  multiplier *= rand(1.5..3.0) if genre.in?(['Action', 'Sci-Fi', 'Animation']) && rating > 7.5 && rand < 0.2

  box_office = (budget * multiplier).round(2)

  # Runtime by genre
  runtime = case genre
            when 'Documentary'
              rand(60..180)
            when 'Animation', 'Comedy', 'Horror'
              rand(80..110)
            when 'Action', 'Thriller', 'Sci-Fi'
              rand(95..150)
            when 'Drama', 'Romance'
              rand(90..140)
            when 'Fantasy', 'Adventure'
              rand(100..180)
            else
              rand(85..130)
            end

  country = countries.sample
  language = if country == 'USA' || country == 'UK' || country == 'Canada' || country == 'Australia'
               'English'
             elsif country == 'Spain' || country == 'Mexico'
               'Spanish'
             elsif country == 'France'
               'French'
             elsif country == 'Germany'
               'German'
             elsif country == 'Japan'
               'Japanese'
             elsif country == 'South Korea'
               'Korean'
             elsif country == 'China'
               'Mandarin'
             elsif country == 'India'
               rand < 0.7 ? 'Hindi' : 'English'
             else
               languages.sample
             end

  movies_data << {
    title: title,
    director: directors.sample,
    genre: genre,
    release_year: release_year,
    rating: rating,
    budget: budget,
    box_office: box_office,
    runtime: runtime,
    country: country,
    language: language,
    studio: studios.sample
  }
end

# Add some specific test movies for edge cases
test_movies = [
  # Movies for specific queries
  {
    title: "The Greatest Movie Ever Made",
    director: "Steven Spielberg",
    genre: "Drama",
    release_year: 1995,
    rating: 10.0,
    budget: 100_000_000,
    box_office: 500_000_000,
    runtime: 180,
    country: "USA",
    language: "English",
    studio: "Universal Pictures"
  },
  {
    title: "Worst Movie Ever",
    director: "Unknown Director",
    genre: "Horror",
    release_year: 2020,
    rating: 1.0,
    budget: 1_000_000,
    box_office: 50_000,
    runtime: 90,
    country: "USA",
    language: "English",
    studio: "Independent"
  },
  {
    title: "Mega Budget Flop",
    director: "Christopher Nolan",
    genre: "Sci-Fi",
    release_year: 2019,
    rating: 6.5,
    budget: 300_000_000,
    box_office: 100_000_000,
    runtime: 150,
    country: "USA",
    language: "English",
    studio: "Warner Bros."
  },
  {
    title: "Surprise Hit",
    director: "Jordan Peele",
    genre: "Horror",
    release_year: 2018,
    rating: 8.5,
    budget: 5_000_000,
    box_office: 200_000_000,
    runtime: 95,
    country: "USA",
    language: "English",
    studio: "A24"
  }
]

movies_data.concat(test_movies)

# Create movies in batches for better performance
movies_data.each_slice(50) do |batch|
  Movie.create!(batch)
end

puts "Created #{Movie.count} movies!"
puts "Genres: #{Movie.distinct.pluck(:genre).sort.join(', ')}"
puts "Release years: #{Movie.minimum(:release_year)} - #{Movie.maximum(:release_year)}"
puts "Rating range: #{Movie.minimum(:rating)} - #{Movie.maximum(:rating)}"
puts "Languages: #{Movie.distinct.pluck(:language).compact.sort.join(', ')}"
puts "Studios: #{Movie.distinct.pluck(:studio).sort.join(', ')}"
