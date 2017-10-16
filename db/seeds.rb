# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Type.create([{ name: "All" }, { name: "Film" }, { name: "Animal World" }, { name: "Cartoon" }, { name: "Music" }, { name: "Learning" }, { name: "Others" }])
Vid.create(name: "Rule The World", address: "https://www.youtube.com/embed/UhblZZITNDE?ecver=2", 
    description: "Karaoke with Vietsub", :types => Type.where(:name => ["All", "Music", "Learning"]))
Vid.create(name: "Telephone In English", address: "https://www.youtube.com/embed/4ckT3aGbhyI?ecver=2", 
    description: "Cambridge University Press Telephone In English 3rd Edition (8 Units-full)", :types => Type.where(:name => ["All", "Learning"]))
Vid.create(name: "Hayao Miyazaki: What You Can Imagine", address: "https://www.youtube.com/embed/8STLqW7OAtk?ecver=2", 
    description: "A famous animation film maker", :types => Type.where(:name => ["All", "Cartoon", "Learning"]))
Vid.create(name: "Lanh Leo (English cover)", address: "https://www.youtube.com/embed/djVhjU4Y1cU?ecver=2", 
    description: "Original song is from China", :types => Type.where(:name => ["All", "Music", "Film"]))

