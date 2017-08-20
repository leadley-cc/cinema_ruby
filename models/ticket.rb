require_relative "cinema_model"
require_relative "../db/sql_runner"

class Ticket < CinemaModel
  @table = "tickets"
  @columns = ["customer_id", "film_id", "screening_id"]

  attr_reader :id
  attr_accessor *@columns

  def initialize(options)
    set_instance_variables(options)
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
end
