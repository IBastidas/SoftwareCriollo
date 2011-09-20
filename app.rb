require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'mongoid'

#Mongoid.load!("mongoid.yml")

Mongoid.database = Mongo::Connection.new('staff.mongohq.com','10032').db('softwarecriollo')
Mongoid.database.authenticate('softwarecriollo','letmein')

class Person
  include Mongoid::Document
  field :nombre
  field :email
end

class Suggestion
  include Mongoid::Document
  field :nombre
end

class App < Sinatra::Base

  set :public, File.join(File.dirname(__FILE__), 'public')  
  set :views, File.join(File.dirname(__FILE__), 'views')

  helpers do
    def partial(page, options={})
      haml page, options.merge!(:layout => false)
    end
  end

  set :haml, :format => :html5

  get '/styles.css' do 
    content_type 'text/css', :charset => 'utf-8'
    sass :styles
  end

  get '/' do
    haml :index
  end

  get '/thanks' do
    haml :thanks
  end

  get '/suggestion' do
    haml :suggestion
  end

  post '/thanks' do 
    suggestion = Suggestion.create(params)
    if suggestion.save
      haml :thanks
    else
      #
    end
  end

  post '/suggestion' do 
    person = Person.create(params)
    if person.save
      haml :suggestion
    else
      #
    end
  end
end
