require "pry"
require_relative "../models/customer"
require_relative "../models/film"
require_relative "../models/screening"
require_relative "../models/ticket"

Ticket.delete_all
Screening.delete_all
Film.delete_all
Customer.delete_all

customer1 = Customer.new({
  "name" => "Michael Leadley",
  "funds" => 0
})
customer1.save

film1 = Film.new({
  "title" => "Wonder Woman",
  "price" => 10
})
film1.save

screening1 = Screening.new({
  "film_id" => film1.id,
  "timedate" => "2017-08-19 15:00"
})
screening1.save

ticket1 = customer1.buy_ticket(film1)
ticket1.save if ticket1

binding.pry
nil
