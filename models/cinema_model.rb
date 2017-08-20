require_relative "../db/sql_runner"

class CinemaModel
  class << self
    attr_reader :table, :columns
  end

  def set_instance_variables(options)
    self.class.columns.each do |column|
      instance_variable_set("@#{column}", options[column])
    end
    instance_variable_set("@id", options["id"]) unless @id
  end

  def sql_columns_str
    self.class.columns.join(", ")
  end

  def sql_placeholder_str(length)
    return "" if length < 1
    str = "$1"
    (2..length).each {|x| str << ", $#{x}"}
    return str
  end

  def sql_values_array(with_id = true)
    array = []
    self.class.columns.each do |column|
      array << send(column)
    end
    array << @id if with_id
    return array
  end

  def update_with_hash(options)
    set_instance_variables(options)
    update
  end

  def options_hash
    options_hash = {"id" => @id}
    self.class.columns.each do |column|
      options_hash[column] = send(column)
    end
    return options_hash
  end

  def save
    columns_no = self.class.columns.count
    sql = "
      INSERT INTO #{self.class.table}
      (#{sql_columns_str})
      VALUES (#{sql_placeholder_str(columns_no)})
      RETURNING id
    "
    values = sql_values_array(with_id = false)
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"]
  end

  def update
    columns_no = self.class.columns.count
    sql = "
      UPDATE #{self.class.table}
      SET (#{sql_columns_str})
      = (#{sql_placeholder_str(columns_no)})
      WHERE id = $#{columns_no + 1}
    "
    SqlRunner.run(sql, sql_values_array)
  end

  def delete
    sql = "DELETE FROM #{self.class.table} WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def self.delete_all
    SqlRunner.run("DELETE FROM #{self.table}")
  end

  def self.all
    result = SqlRunner.run("SELECT * FROM #{self.table}")
    return self.map_create(result)
  end

  def self.map_create(hashes)
    return hashes.map {|hash| self.new(hash)}
  end
end
