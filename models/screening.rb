require_relative "../db/sql_runner"

class Screening
  attr_reader :id
  attr_accessor :film_id, :date_time

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"].to_i
    @date_time = options["date_time"]
  end

  def film
    sql = "SELECT * FROM films WHERE id = $1"
    result = SqlRunner.run(sql, [@film_id])
    return Film.new(result[0])
  end

  def save
    sql = "
      INSERT INTO screenings (film_id, date_time)
      VALUES ($1, $2)
      RETURNING id
    "
    values = [@film_id, @date_time]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def update
    sql = "
      UPDATE tickets
      SET (film_id, date_time) = ($1, $2)
      WHERE id = $3
    "
    values = [@film_id, @date_time, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def Screening.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def Screening.all
    sql = "SELECT * FROM screenings"
    result = SqlRunner.run(sql)
    return Screening.map_create(result)
  end

  def Screening.map_create(hashes)
    return hashes.map {|hash| Screening.new(hash)}
  end
end
