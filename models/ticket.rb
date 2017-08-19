require_relative "../db/sql_runner"

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
    @screening_id = options["screening_id"].to_i
  end

  def customer
    sql = "SELECT * FROM customers WHERE id = $1"
    result = SqlRunner.run(sql, [@customer_id])
    return Customer.new(result[0])
  end

  def film
    sql = "SELECT * FROM films WHERE id = $1"
    result = SqlRunner.run(sql, [@film_id])
    return Film.new(result[0])
  end

  def screening
    sql = "SELECT * FROM screenings WHERE id = $1"
    result = SqlRunner.run(sql, [@screening_id])
    return Screening.new(result[0])
  end

  def save
    sql = "
      INSERT INTO tickets (customer_id, film_id, screening_id)
      VALUES ($1, $2, $3)
      RETURNING id
    "
    values = [@customer_id, @film_id, @screening_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def update
    sql = "
      UPDATE tickets
      SET (customer_id, film_id, screening_id) = ($1, $2, $3)
      WHERE id = $4
    "
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def Ticket.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def Ticket.all
    sql = "SELECT * FROM tickets"
    result = SqlRunner.run(sql)
    return Ticket.map_create(result)
  end

  def Ticket.map_create(hashes)
    return hashes.map {|hash| Ticket.new(hash)}
  end
end
