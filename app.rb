require 'sinatra'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

class User
  include Mongoid::Document
  store_in collection: "users"
  embeds_many :persons, class_name: "Person"

  field :name, type: String
  field :time_zone, type: String

  validates :name, presence: true
  validates :time_zone, presence: true

end


class Person
  include Mongoid::Document
  embedded_in :user, class_name: "User"

  field :name, type: String
  field :pronoun_subject, type: String
  field :pronoun_object, type: String
  field :pronoun_possessive, type: String
  field :time_zone, type: String
  field :location, type: String

  validates :name, presence: true
  validates :time_zone, presence: true

end


get '/users' do
  User.all.to_json
end

post '/users' do
  user = User.new(params[:user])
  if user.save
    user.to_json
    status 201
  else
    status 422
    user.errors.to_json
  end
end

get '/users/:user_id' do |user_id|
  user = User.find(user_id)
  user.to_json
end

get '/persons' do
  Person.all.to_json
end

post '/users/:user_id/persons' do |user_id|
    user = User.find(user_id)
    person = user.persons.create(params[:person])
    if person
      person.to_json
      status 201
    else
      status 422
      person.errors.to_json
    end
end

# All the Persons that belong to a User
get '/users/:user_id/persons' do |user_id|
  user = User.find(user_id)
  persons = user.persons
  persons.to_json
end
