require_relative "cinema_model"
require_relative "../db/sql_runner"

class Screening < CinemaModel
  @table = "screenings"
  @columns = ["film_id", "date_time", "available_tickets"]

  attr_reader :id
  attr_accessor *@columns

  def initialize(options)
    set_instance_variables(options)
  end

  def remove_ticket
    avail_int = @available_tickets.to_i
    return false if avail_int <= 0
    @available_tickets = avail_int - 1
    update
    return true
  end

  def film
    foreign_key_select_single("Film")
  end
end
