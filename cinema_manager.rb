require_relative "models/customer"
require_relative "models/film"
require_relative "models/screening"
require_relative "models/ticket"

puts "Welcome to CodeClan Cinema!"
puts "What would you like to do today?"
input = gets.chomp.downcase

case input
when "add customer"
  options_hash = get_options_hash(["name", "funds"])
  Customer.new(options_hash).save
  puts "Customer added!"
when "add film"
  options_hash = get_options_hash(["title", "price"])
  Film.new(options_hash).save
  puts "Film added!"
end

def get_options_hash(param_names)
  param_names.each_with_object({}) do |param_name, options_hash|
    print param_name.capitalize + ": "
    options_hash[param_name] = gets.chomp
  end
end
