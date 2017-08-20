require_relative "cinema_model"
require_relative "../db/sql_runner"

class Ticket < CinemaModel
  @columns = ["customer_id", "film_id", "screening_id"]

  attr_accessor *@columns

  def initialize(options)
    set_instance_variables(options)
  end

  def customer
    foreign_key_select_single("Customer")
  end

  def film
    foreign_key_select_single("Film")
  end

  def screening
    foreign_key_select_single("Screening")
  end
end
