require 'sinatra/base'
require './exceptions'
require './memotest'

class MyApplication < Sinatra::Base
	
	configure do
		enable :sessions
	end

	get '/' do
		erb :bienvenido
	end

	post '/crear_partida' do
		erb :crear_partida
	end

	post '/jugando' do
		cantFichas = params[:cantPares]
		begin
			partida = Memotest.new Integer(cantFichas)
			rescue DemasiadosParesException
				erb :demasiados_pares_error
			rescue PocosParesException
				erb :pocos_pares_error
			rescue ArgumentError
				erb :caracteres_invalidos_error
			else
				session[:memotest] = partida #Guardo la partida en la sesion
				erb :jugando
		end
	end


	post '/resultado' do
		partida = session[:memotest]
		opcion1 = params[:opcion1]
		opcion2 = params[:opcion2]
		partida.arriesgar(opcion1, opcion2)#Arriesgo las opciones
		params[:opcion1] = opcion1
		params[:opcion2] = opcion2
		params[:resultado1] = partida.get_fichas[Integer(opcion1)]
		params[:resultado2] = partida.get_fichas[Integer(opcion2)]
		session[:memotest] = partida
		erb :resultado
	end

	
	run! if app_file == $0
end
