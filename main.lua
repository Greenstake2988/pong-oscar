Push = require 'push'

Class = require 'class'

require 'Pelota'
require 'Paleta'

ANCHO_VENTANA = 1280
ALTO_VENTANA = 720

ANCHO_VIRTUAL = 432
ALTURA_VIRTUAL = 243

VELOCIDAD_DE_LAS_PALETAS = 200

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	love.window.setTitle("PONG!")

	math.randomseed(os.time())

	FontPequeno = love.graphics.newFont('font.ttf', 8)
	FontGrande =  love.graphics.newFont('font.ttf', 16)
	ScoreFont =   love.graphics.newFont('font.ttf', 32)

	love.graphics.setFont(FontPequeno)

	Sonidos = {
		['golpeo_de_paleta'] = love.audio.newSource('musica/golpeo_de_paleta.wav', 'static'),
		['score'] = love.audio.newSource('musica/score.wav', 'static'),
		['golpeo_de_pared'] = love.audio.newSource('musica/golpeo_de_pared.wav', 'static')
	}


	Push:setupScreen(ANCHO_VIRTUAL, ALTURA_VIRTUAL,ANCHO_VENTANA, ALTO_VENTANA, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	Jugador1Score = 0
	Jugador2Score = 0

	JugadorQueSaca = 1

	Jugador1 = Paleta(10, 20, 5, 20)
	Jugador2 = Paleta(ANCHO_VIRTUAL - 10, ALTURA_VIRTUAL - 30, 5, 20)

	AI = Paleta(ANCHO_VIRTUAL - 10, ALTURA_VIRTUAL - 30, 5, 20)


	Pelota = Pelota(ANCHO_VIRTUAL / 2 - 2,
	ALTURA_VIRTUAL / 2 - 2, 4, 4)

	EstadoDelJuego = 'inicio'

end

function love.resize(ancho, altura)
	Push:resize(ancho, altura)
	
end

function love.update(dt)
	if EstadoDelJuego == 'sirviendo' then
		Pelota.dy = math.random(-50, 50)
		if JugadorQueSaca == 1 then
			Pelota.dx = math.random(140, 200)
		else
			Pelota.dx = -math.random(140, 200)
		end
	elseif EstadoDelJuego == 'juego' then
		if Pelota:collides(Jugador1) then
			Pelota.dx = -Pelota.dx * 1.03
			Pelota.x = Jugador1.x + 5
			
			if Pelota.dy < 0 then
				Pelota.dy = -math.random(10, 150)
			else
				Pelota.dy = math.random(10, 150)
			end

			Sonidos.golpeo_de_paleta:play()
		end

		if Pelota:collides(Jugador2) then
			Pelota.dx = -Pelota.dx * 1.03
			Pelota.x = Jugador2.x - 4
			
			if Pelota.dy < 0 then
				Pelota.dy = -math.random(10, 150)
			else
				Pelota.dy = math.random(10, 150)
			end

			Sonidos.golpeo_de_paleta:play()
		end

		if Pelota.y <= 0 then
			Pelota.y = 0
			Pelota.dy = -Pelota.dy
			Sonidos.golpeo_de_pared:play()
		end

		if Pelota.y >= ALTURA_VIRTUAL - 4 then
			Pelota.y = ALTURA_VIRTUAL - 4
			Pelota.dy = -Pelota.dy
			Sonidos.golpeo_de_pared:play()

		end

		if Pelota.x < 0 then
			JugadorQueSaca = 1
			Jugador2Score = Jugador2Score + 1
			Sonidos.score:play()

			if Jugador2Score == 10 then
				JugadorQueGano = 2
				EstadoDelJuego = 'termino'
			else
				EstadoDelJuego = 'sirviendo'
				Pelota:reset()
			end
		end

		if Pelota.x > ANCHO_VIRTUAL then
			JugadorQueSaca = 2
			Jugador1Score = Jugador1Score + 1
			Sonidos.score:play()

			if Jugador1Score == 10 then
				JugadorQueGano = 1
				EstadoDelJuego = 'termino'
			else
				EstadoDelJuego = 'sirviendo'
				Pelota:reset()
			end
		end
	end

	if love.keyboard.isDown('w') then
		Jugador1.dy = -VELOCIDAD_DE_LAS_PALETAS 	
	elseif love.keyboard.isDown('s') then
		Jugador1.dy = VELOCIDAD_DE_LAS_PALETAS 
	else
		--el AI toma el control
		--Jugador1.dy = 0
		if Pelota.y  < Jugador1.y + 10 then
			Jugador1.dy = -VELOCIDAD_DE_LAS_PALETAS
		elseif Pelota.y  > Jugador1.y - 10 then
			Jugador1.dy = VELOCIDAD_DE_LAS_PALETAS
		else
			Jugador1.dy = 0
		end
	end

	if love.keyboard.isDown('up') then
		Jugador2.dy = -VELOCIDAD_DE_LAS_PALETAS 	
	elseif love.keyboard.isDown('down') then
		Jugador2.dy = VELOCIDAD_DE_LAS_PALETAS 
	else
		Jugador2.dy = 0
	end
	if EstadoDelJuego == 'juego' then
		Pelota:update(dt)
	end

	Jugador1:update(dt)
	Jugador2:update(dt)
end

function love.keypressed(key)

	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if EstadoDelJuego == 'inicio' then
			EstadoDelJuego = 'sirviendo'
		elseif EstadoDelJuego == 'sirviendo' then
			EstadoDelJuego = 'juego'
		elseif EstadoDelJuego == 'termino' then
			EstadoDelJuego = 'sirviendo'

			Pelota:reset()

			Jugador1Score = 0
			Jugador2Score = 0

			if JugadorQueGano == 1 then
				JugadorQueSaca = 2
			else
				JugadorQueSaca = 1
			end
		end
	end
end

function love.draw()

	Push:apply('start')

	love.graphics.clear(40/255, 45/255, 52/255, 255/255)

	love.graphics.setFont(FontPequeno)

	MostrarScore()

	if EstadoDelJuego == 'inicio' then
		love.graphics.setFont(FontPequeno)
		love.graphics.printf('Bienvenido a PONG!', 0, 10, ANCHO_VIRTUAL, 'center')
		love.graphics.printf('Presiona Enter para comenzar', 0, 20, ANCHO_VIRTUAL, 'center')

	elseif EstadoDelJuego == 'sirviendo' then
		love.graphics.setFont(FontPequeno)
		love.graphics.printf('Jugador ' .. tostring(JugadorQueSaca) .. " sirve!", 
            0, 10, ANCHO_VIRTUAL, 'center')
		love.graphics.printf('Presiona Enter para servir', 0, 20, ANCHO_VIRTUAL, 'center')
	elseif EstadoDelJuego == 'juego' then
	
	elseif EstadoDelJuego == 'termino' then
		love.graphics.setFont(FontGrande)
		love.graphics.printf('Jugador ' .. tostring(JugadorQueGano) .. " gana!", 
            0, 10, ANCHO_VIRTUAL, 'center')
		love.graphics.setFont(FontPequeno)
		love.graphics.printf('Presiona Enter para reiniciar', 0, 30, ANCHO_VIRTUAL, 'center')

	end

	Jugador1:render()
	Jugador2:render()

	Pelota:render()

	MostrarFPS()

	Push:apply('end')
end

function MostrarFPS()
	love.graphics.setFont(FontPequeno)
	love.graphics.setColor(0, 255 , 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)

end

function MostrarScore()
	love.graphics.setFont(ScoreFont)
	love.graphics.print(tostring(Jugador1Score), ANCHO_VIRTUAL / 2 - 50, 
        ALTURA_VIRTUAL / 3)
	love.graphics.print(tostring(Jugador2Score), ANCHO_VIRTUAL / 2 + 30, 
        ALTURA_VIRTUAL / 3)

	end
