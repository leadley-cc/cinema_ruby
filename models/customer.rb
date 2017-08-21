require_relative "cinema_model"
require_relative "../db/sql_runner"

class Customer < CinemaModel
  @columns = ["name", "funds"]

  attr_accessor *@columns

  def initialize(options)
    set_instance_variables(options)
  end

  def remove_funds(price)
    funds_int = @funds.to_i
    return false if funds_int < price
    @funds = funds_int - price
    update
    return true
  end

  def buy_ticket(screening)
    film = screening.film
    return puts "No tickets left!" unless screening.remove_ticket
    return puts "Not enough funds!" unless remove_funds(film.price.to_i)
    ticket_hash = {
      "customer_id" => @id,
      "screening_id" => screening.id
    }
    return Ticket.new(ticket_hash)
  end

  def films_watched
    sql = "
      SELECT DISTINCT films.* FROM films
      INNER JOIN screenings ON films.id = screenings.film_id
      INNER JOIN tickets ON screenings.id = tickets.screening_id
      WHERE tickets.customer_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return Film.map_create(result)
  end

  def ticket_count
    sql = "
      SELECT COUNT(id) FROM tickets
      WHERE customer_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return result[0]["count"].to_i
  end
end
