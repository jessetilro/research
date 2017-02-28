# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({
  email: 'jesse@jessetilro.nl',
  password: 'testtest'
  })

Source.create({
  title: 'Een Uitgebreid Verhaal over Karamel en Walvissen.',
  authors: 'Koekepeer M.',
  year: 2017,
  kind: :paper,
  abstract: 'Lorem ipsum...',
  description: 'Dit sprak mij wel aan!',
  user: User.first
  })

Source.create({
  title: 'Waarom Ruikt Mijn Haar Naar Gras? Feiten en Statistieken Over Mens Naar Plant Transformaties.',
  authors: 'Boom A., Bos P.',
  year: 2017,
  kind: :paper,
  abstract: 'Lorem ipsum...',
  description: 'Reuze interessant!',
  user: User.first
  })
