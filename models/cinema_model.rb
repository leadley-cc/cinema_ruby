require_relative "../db/sql_runner"

class CinemaModel
  @@table = ""
  @@columns = []

  def set_instance_variables(options)
    @@columns.each do |column|
      next if (column == "id") && @id
      puts "@#{column}: " + options[column].to_s
      instance_variable_set("@#{column}", options[column])
    end
  end

  def sql_columns_str
    @@columns.select{|col| col != "id"}.join(", ")
  end

  def sql_placeholder_str(length)
    return "" if length < 1
    str = "$1"
    (2..length).each {|x| str << ", $#{x}"}
    return str
  end

  def sql_values_array(with_id = true)
    array = []
    @@columns.each do |column|
      array << send(column) unless column == "id"
    end
    array << @id if with_id
    return array
  end

  def update_with_hash(options)
    set_instance_variables(options)
    update
  end

  def options_hash
    options_hash = Hash.new
    @@columns.each do |column|
      options_hash[column] = send(column)
    end
    return options_hash
  end

  def save
    sql = "
      INSERT INTO #{@@table}
      (#{sql_columns_str})
      VALUES (#{sql_placeholder_str(@@columns.count - 1)})
      RETURNING id
    "
    values = sql_values_array(with_id = false)
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def update
    columns_no = @@columns.count
    puts sql = "
      UPDATE #{@@table}
      SET (#{sql_columns_str})
      = (#{sql_placeholder_str(columns_no - 1)})
      WHERE id = $#{columns_no}
    "
    SqlRunner.run(sql, sql_values_array)
  end

  def delete
    sql = "DELETE FROM #{@@table} WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def self.delete_all
    SqlRunner.run("DELETE FROM #{@@table}")
  end

  def self.all
    result = SqlRunner.run("SELECT * FROM #{@@table}")
    return self.map_create(result)
  end

  def self.map_create(hashes)
    return hashes.map {|hash| self.new(hash)}
  end
end
