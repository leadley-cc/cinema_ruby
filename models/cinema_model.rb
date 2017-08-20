module CinemaModel
  @@columns ||= []

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
end
