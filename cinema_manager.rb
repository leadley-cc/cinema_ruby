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

    # TODO: buy ticket, check/add funds
    # TODO: remove customer, cancel ticket, remove screening
    # TODO: update/edit customer, screening, ticket

  when "exit", "quit", "bye"
    puts "Goodbye!"
    exit

  when "help"
    puts "Possible commands: " +
      "exit, help, " +
      "list films, film details, new film, edit film, delete film, " +
      "new customer, new screening"

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

  when "new film", "add film"
    options_hash = get_options_hash(["title", "price"])
    Film.new(options_hash).save
    puts "Film added!"

  when "edit film", "update film"
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

  when "delete film", "remove film"
    print "Title: "
    film = Film.find_by_title(gets.chomp)
    if film
      film.delete
      puts "Film deleted!"
    else
      puts "No such film found!"
    end

  when "new customer", "add customer"
    options_hash = get_options_hash(["name", "funds"])
    Customer.new(options_hash).save
    puts "Customer added!"

  when "new screening", "add screening"
    print "Film title: "
    film = Film.find_by_title(gets.chomp)
    if film
      print "Date and time: "
      date_time = gets.chomp
      print "How many tickets are available?: "
      tickets = gets.chomp
      film.add_screening(date_time, tickets).save
      puts "Screening added!"
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
