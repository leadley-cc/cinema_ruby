require_relative "../db/sql_runner"

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end

  def save
    sql = "
      INSERT INTO films (title, price)
      VALUES ($1, $2)
      RETURNING id
    "
    values = [@title, @price]
    pg_result = SqlRunner.run(sql, values)
    @id = pg_result[0]["id"].to_i
  end

  def update
    sql = "
      UPDATE films
      SET (title, price) = ($1, $2)
      WHERE id = $3
    "
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def Film.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def Film.all
    sql = "SELECT * FROM films"
    pg_result = SqlRunner.run(sql)
    return Film.map_create(pg_result)
  end

  def Film.map_create(hashes)
    return hashes.map {|hash| Film.new(hash)}
  end
end
