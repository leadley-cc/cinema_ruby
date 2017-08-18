require_relative "../db/sql_runner"

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
  end

  def save
    sql = "
      INSERT INTO tickets (customer_id, film_id)
      VALUES ($1, $2)
      RETURNING id
    "
    values = [@customer_id, @film_id]
    pg_result = SqlRunner.run(sql, values)
    @id = pg_result[0]["id"].to_i
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
    pg_result = SqlRunner.run(sql)
    return Ticket.map_create(pg_result)
  end

  def Ticket.map_create(hashes)
    return hashes.map {|hash| Ticket.new(hash)}
  end
end
