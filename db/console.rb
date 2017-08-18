require "pry"
require_relative "../models/customer"
require_relative "../models/film"
require_relative "../models/ticket"

customer1 = Customer.new({
  "name" => "Michael Leadley",
  "funds" => 80
})

film1 = Film.new({
  "title" => "",
  "price" => 10
})

ticket1 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film1.id
})

binding.pry
nil
