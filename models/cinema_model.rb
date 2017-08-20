module CinemaModel
  @@columns ||= []

  def set_instance_variables(options)
    @@columns.each do |column|
      puts "@#{column}: " + options[column].to_s
      instance_variable_set("@#{column}", options[column])
    end
  end
end
