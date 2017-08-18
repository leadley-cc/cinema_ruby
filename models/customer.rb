require_relative "../db/sql_runner"

class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i
  end

  def save
    sql = "
      INSERT INTO customers (name, funds)
      VALUES ($1, $2)
      RETURNING id
    "
    values = [@name, @funds]
    pg_result = SqlRunner.run(sql, values)
    @id = pg_result[0]["id"].to_i
  end

  def update
    sql = "
      UPDATE customers
      SET (name, funds) = ($1, $2)
      WHERE id = $3
    "
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def Customer.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def Customer.all
    sql = "SELECT * FROM customers"
    pg_result = SqlRunner.run(sql)
    return Customer.map_create(pg_result)
  end

  def Customer.map_create(hashes)
    return hashes.map {|hash| Customer.new(hash)}
  end
end
