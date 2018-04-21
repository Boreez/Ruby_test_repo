require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
	@username = params[:username]
	@password = params[:password]

		if @username == 'admin' && @password = 'secret'

			redirect '/clients.txt'
#  		session[:identity] = params['username']
#  		where_user_came_from = session[:previous_url] || '/'
#  		redirect to where_user_came_from
		else
				erb :login_form
		end
				
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

#===========================================================


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@client = params[:client]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	f = File.open './public/clients.txt','a'
	f.write "Client: #{@client}, phone number: #{@phone}, date and time: #{@datetime}, barber: #{@barber}\n"
	f.close

	erb :message

end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@message = params[:message]

	f = File.open './public/contacts.txt','a'
	f.write "Email: #{@email}, message: #{@message}"
	f.close

	erb :contacts_message

end
