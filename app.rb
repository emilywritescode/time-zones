require 'sinatra'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

class User
  include Mongoid::Document
  store_in collection: "users"

  field :name, type: String
  field :time_zone, type: String

  validates :name, presence: true
  validates :time_zone, presence: true

  has_many :persons
end


class Person
  include Mongoid::Document
  store_in collection: "persons"

  field :name, type: String
  field :pronoun_subject, type: String
  field :pronoun_object, type: String
  field :pronoun_possessive, type: String
  field :time_zone, type: String
  field :location, type: String

  validates :name, presence: true
  validates :time_zone, presence: true

  belongs_to :user
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

post '/persons' do
    person = Person.new(params[:person])
    if person.save
      person.to_json
      status 201
    else
      status 422
      person.errors.to_json
    end
end

# All the Persons that belong to a User
get '/persons/:user_id' do |user_id|
  persons = Person.where(user_id: user_id)
  persons.to_json
end
