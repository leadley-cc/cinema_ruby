require_relative "../db/sql_runner"

class Screening
  attr_reader :id
  attr_accessor :film_id, :timedate

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"].to_i
    @timedate = options["timedate"]
  end

  def film
  end

  def save
  end

  def update
  end

  def delete
  end

  def Screening.delete_all
  end

  def Screening.all
  end
end
