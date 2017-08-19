require_relative "models/customer"
require_relative "models/film"
require_relative "models/screening"
require_relative "models/ticket"

def get_options_hash(param_names)
  param_names.each_with_object({}) do |param_name, options_hash|
    print param_name.capitalize + ": "
    options_hash[param_name] = gets.chomp
  end
end

def main_loop
  input = gets.chomp.downcase
  case input

    # TODO: help
    # TODO: list films, view film details, view film screenings
    # TODO: buy ticket, check/add funds, add screening
    # TODO: remove customer, cancel ticket, remove screening

  when "exit", "quit", "bye"
    puts "Goodbye!"
    exit
  when "add customer", "new customer"
    options_hash = get_options_hash(["name", "funds"])
    Customer.new(options_hash).save
    puts "Customer added!"
  when "add film", "new film"
    options_hash = get_options_hash(["title", "price"])
    Film.new(options_hash).save
    puts "Film added!"
  when "remove film", "delete film"
    print "Title: "
    film = Film.find_by_title(gets.chomp)
    if film
      film.delete
      puts "Film deleted!"
    else
      puts "No such film found!"
    end
  else
    puts "I'm sorry Dave, I'm afraid I can't do that."
  end
  puts "Would you like to do anything else?"
end

puts "Welcome to CodeClan Cinema!"
puts "What would you like to do today?"
loop { main_loop }
