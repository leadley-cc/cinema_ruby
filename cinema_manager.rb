require "readline"
require_relative "models/customer"
require_relative "models/film"
require_relative "models/screening"
require_relative "models/ticket"

def readline_editable(prompt, editable)
  Readline.pre_input_hook = -> {
    Readline.insert_text(editable)
    Readline.redisplay
  }
  Readline.readline(prompt)
end

def get_options_hash(param_names, options_hash = {})
  param_names.each do |param_name|
    options_hash[param_name] = readline_editable(
      param_name.capitalize + ": ",
      options_hash[param_name].to_s || ""
    )
  end
  return options_hash
end

def main_loop
  input = gets.chomp.downcase
  case input

    # TODO: buy ticket, check/add funds, add screening
    # TODO: remove customer, cancel ticket, remove screening
    # TODO: update/edit customer, film, screening, ticket

  when "exit", "quit", "bye"
    puts "Goodbye!"
    exit
  when "help"
    puts "Possible commands: " +
      "exit, help, " +
      "list films, add film, edit film, delete film, " +
      "add customer"
  when "list films", "view films"
    puts "Here are the currently available films:"
    Film.all.each { |film| puts film.title }
  when "film details", "film screenings"
    print "Title: "
    film = Film.find_by_title(gets.chomp)
    if film
      puts "Ticket price: £#{film.price}"
      puts "Here are the screening times for #{film.title}: "
      film.screenings.each do |screening|
        puts "#{screening.date_time}" +
          " (#{screening.available_tickets} tickets available)"
      end
    else
      puts "No such film found!"
    end
  when "add customer", "new customer"
    options_hash = get_options_hash(["name", "funds"])
    Customer.new(options_hash).save
    puts "Customer added!"
  when "add film", "new film"
    options_hash = get_options_hash(["title", "price"])
    Film.new(options_hash).save
    puts "Film added!"
  when "update film", "edit film"
    print "Title: "
    film = Film.find_by_title(gets.chomp)
    if film
      puts "Please enter new details:"
      new_options = get_options_hash(["title", "price"], film.options_hash)
      film.update_with_hash(new_options)
      puts "Film updated!"
    else
      puts "No such film found!"
    end
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
