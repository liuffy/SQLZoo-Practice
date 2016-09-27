# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer


require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford' AND castings.ord > 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    title, actors.name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    ord = 1 AND yr = '1962'
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    yr, COUNT(title)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    name = 'John Travolta'
  GROUP BY
    yr
  HAVING
    COUNT(title) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    title, other_actors.name
  FROM
    actors AS julie
  JOIN castings AS julie_castings
    ON julie_castings.actor_id = julie.id
  JOIN movies
    ON movies.id = julie_castings.movie_id
  JOIN castings AS other_castings
    ON other_castings.movie_id = movies.id
  JOIN actors AS other_actors
    ON other_actors.id = other_castings.actor_id
  WHERE
    julie.name = 'Julie Andrews' AND other_castings.ord = 1
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    all_actors.name
  FROM
    actors AS all_actors
  JOIN castings AS all_castings
    ON all_actors.id = all_castings.actor_id
  WHERE
    all_castings.ord = 1
  GROUP BY
    all_actors.name
  HAVING
    COUNT(*) >= 15
  ORDER BY
    all_actors.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SELECT
    title, COUNT(*)
  FROM
    movies
  JOIN castings
    ON castings.movie_id = movies.id
  WHERE
    yr = '1978'
  GROUP BY
    movies.title
  ORDER BY
    COUNT(*) DESC, title
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT
      DISTINCT other_actors.name
    FROM
      actors AS art_garfunkel
    JOIN castings AS art_garfunkel_castings
      ON art_garfunkel_castings.actor_id = art_garfunkel.id
    JOIN movies
      ON movies.id = art_garfunkel_castings.movie_id
    JOIN castings AS other_castings
      ON other_castings.movie_id = movies.id
    JOIN actors AS other_actors
      ON other_actors.id = other_castings.actor_id
    WHERE
      art_garfunkel.name = 'Art Garfunkel'
      AND other_actors.name != 'Art Garfunkel';
  SQL
end
