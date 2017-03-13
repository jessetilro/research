# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({
  email: 'jesse@jessetilro.nl',
  first_name: 'Jesse',
  last_name: 'Tilro',
  password: 'testtest'
  })

User.create({
  email: 'otherguy@jessetilro.nl',
  first_name: 'Other',
  last_name: 'Guy',
  password: 'testtest'
  })

Source.create({
  title: 'Een Uitgebreid Verhaal over Karamel en Walvissen.',
  authors: 'Koekepeer M.',
  year: 2017,
  abstract: 'Lorem ipsum...',
  user: User.first
  })

Source.create({
  title: 'Waarom Ruikt Mijn Haar Naar Gras? Feiten en Statistieken Over Mens Naar Plant Transformaties.',
  authors: 'Boom A., Bos P.',
  year: 2017,
  abstract: 'Lorem ipsum...',
  user: User.first
  })

Source.create({
  user: User.first,
  bibtex_type: :book,
  bibtex_key: :rails,
  address: 'Raleigh, North Carolina',
  authors: 'Ruby, Sam and Thomas, Dave, and Hansson, David Heinemeier',
  subtitle: 'Agile Web Development with Rails',
  edition: 'third',
  keywords: 'ruby, rails',
  publisher: 'The Pragmatic Bookshelf',
  series: 'The Facets of Ruby',
  title: 'Agile Web Development with Rails',
  year: '2009'
  })

Review.create({
  user_id: User.first.id,
  source_id: Source.last.id,
  comment: 'I liked this Source and totally approve it.',
  rating: (1 + Random.rand(9))
  })

Review.create({
  user_id: User.last.id,
  source_id: Source.last.id,
  comment: 'I liked this Source and totally approve it.',
  rating: (1 + Random.rand(9))
  })
