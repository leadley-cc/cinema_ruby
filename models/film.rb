require_relative "../db/sql_runner"

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end

  def add_screening(date_time)
    screening_hash = {
      "film_id" => @id,
      "date_time" => date_time
    }
    return Screening.new(screening_hash)
  end

  def viewers
    sql = "
      SELECT customers.* FROM customers
      INNER JOIN tickets ON customers.id = tickets.customer_id
      WHERE tickets.film_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return Customer.map_create(result)
  end

  def view_count
    sql = "
      SELECT COUNT(id) FROM tickets
      WHERE film_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return result[0]["count"].to_i
  end

  def save
    sql = "
      INSERT INTO films (title, price)
      VALUES ($1, $2)
      RETURNING id
    "
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
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
    result = SqlRunner.run(sql)
    return Film.map_create(result)
  end

  def Film.map_create(hashes)
    return hashes.map {|hash| Film.new(hash)}
  end
end
