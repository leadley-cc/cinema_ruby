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

  def update_with_hash(options)
    set_instance_variables(options)
    update
  end

  def options_hash
    options_hash = Hash.new
    @@columns.each do |column|
      options_hash[column] = send("#{column}")
    end
    return options_hash
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
