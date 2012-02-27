require 'rubygems'
require 'bundler/setup'
require 'data_mapper'
require 'slim'
require 'sinatra'
require 'thin'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://zcpcbdupnq:bNFsMK6vFJz0on_0NfVy@ec2-107-20-191-126.compute-1.amazonaws.com/zcpcbdupnq")

class Task
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true
  property :completed_at, DateTime
  property :created_at, DateTime


  before :create do
    self.created_at = Time.now
  end

end

DataMapper.finalize

get '/' do
  @tasks = Task.all
  slim :index
end

post '/' do 
  Task.create(params[:task])
  redirect to('/')
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to('/')
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end

put '/task/update/:id' do
  task = Task.get params[:id]
  task.name = params[:task][:name] if !params[:task][:name].nil?
  task.save
  redirect to('/')
end
