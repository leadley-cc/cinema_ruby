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
  "funds" => 80
})
customer1.save
customer2 = Customer.new({
  "name" => "Moneybags",
  "funds" => 1_000_000
})
customer2.save

film1 = Film.new({
  "title" => "Wonder Woman",
  "price" => 10
})
film1.save

screening1 = film1.add_screening("2017-08-19 15:00", 20)
screening1.save
screening2 = film1.add_screening("2017-08-19 18:00", 30)
screening2.save

ticket1 = customer1.buy_ticket(screening1)
ticket1.save if ticket1
ticket2 = customer1.buy_ticket(screening2)
ticket2.save if ticket2
ticket3 = customer1.buy_ticket(screening2)
ticket3.save if ticket3

binding.pry
nil
