require_relative "cinema_model"
require_relative "../db/sql_runner"

class Ticket < CinemaModel
  @columns = ["customer_id", "film_id", "screening_id"]

  attr_accessor *@columns
  fk_selector "Customer", "Film", "Screening"

  def initialize(options)
    set_instance_variables(options)
  end
end
