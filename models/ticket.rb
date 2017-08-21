require_relative "cinema_model"
require_relative "../db/sql_runner"

class Ticket < CinemaModel
  @columns = ["customer_id", "screening_id"]

  attr_accessor *@columns
  fk_selector "Customer", "Screening"

  def initialize(options)
    set_instance_variables(options)
  end

  def film
    sql = "
      SELECT films.* FROM films
      INNER JOIN screenings ON films.id = screenings.film_id
      WHERE screenings.id = $1
    "
    result = SqlRunner.run(sql, [@screening_id])
    return Film.new(result[0])
  end
end
