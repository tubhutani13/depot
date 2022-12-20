# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#---
# Excerpted from "Agile Web Development with Rails 6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails6 for more book information.
#---
# encoding: utf-8
Product.delete_all
Product.create!(title: 'Docker for Rails Developers',
  description:
    %{Build, Ship, and Run Your Applications Everywhere},
  image_url: 'ridocker.jpg',
  price: 38.00,
  discount_price:30,
permalink:"a-a-a-a",
category_id: 8)
# . . .
Product.create!(title: 'Build Chatbot Interactions',
  description:
    %{Responsive, Intuitive Interfaces with Ruby</em>},
  image_url: 'dpchat.jpg',
  price: 20.00,
  discount_price:18,
  permalink:"a-a-b-a",
  category_id: 8)
# . . .

Product.create!(title: 'Programming Crystal',
  description:
    %{Create High-Performance, Safe, Concurrent Appsis a breeze to deploy.},
  image_url: 'crystal.jpg',
  price: 40.00,
  discount_price:30,
  permalink:"a-b-a-a",
  category_id: 8)

