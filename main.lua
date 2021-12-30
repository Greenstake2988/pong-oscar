Push = require 'push'

Class = require 'class'

require 'Pelota'
require 'Paleta'

ANCHO_VENTANA = 1280
ALTO_VENTANA = 720

ANCHO_VIRTUAL = 432
ALTO_VIRTUAL = 243

VELOCIDAD_DE_LAS_PALETAS = 200

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	math.randomseed(os.time())

	FontPequeno = love.graphics.newFont('font.ttf', 8)

	ScoreFont = love.graphics.newFont('font.ttf', 32)

	love.graphics.setFont(FontPequeno)

	Push:setupScreen(ANCHO_VIRTUAL, ALTO_VIRTUAL,ANCHO_VENTANA, ALTO_VENTANA, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	PLayer1Score = 0
	PLayer2Score = 0

	Jugador1 = Paleta(10, 20, 5, 20)
	Jugador2 = Paleta(ANCHO_VIRTUAL - 10, ALTO_VIRTUAL - 30, 5, 20)

	Pelota = Pelota(ANCHO_VIRTUAL / 2 - 2,
	ALTO_VIRTUAL / 2 - 2, 4, 4)

	EstadoDelJuego = 'inicio'

end

function love.update(dt)

	if love.keyboard.isDown('w') then
		Jugador1.dy = -VELOCIDAD_DE_LAS_PALETAS 	
	elseif love.keyboard.isDown('s') then
		Jugador1.dy = VELOCIDAD_DE_LAS_PALETAS 
	else
		Jugador1.dy = 0
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
			EstadoDelJuego = 'juego'
		else
			EstadoDelJuego = 'inicio'
			
			Pelota:reset()
		end
	end
end

function love.draw()

	Push:apply('start')

	love.graphics.clear(40/255, 45/255, 52/255, 255/255)

	love.graphics.setFont(FontPequeno)

	if EstadoDelJuego == 'inicio' then
		love.graphics.printf('Hola incio PONG!', 0, 20, ANCHO_VIRTUAL, 'center')
	else
		love.graphics.printf('Hola juego PONG!', 0, 20, ANCHO_VIRTUAL, 'center')
	end



	love.graphics.setFont(ScoreFont)

	love.graphics.print(tostring(PLayer1Score), ANCHO_VIRTUAL / 2 - 50, ALTO_VIRTUAL / 3)

	love.graphics.print(tostring(PLayer2Score), ANCHO_VIRTUAL / 2  + 30, ALTO_VIRTUAL / 3)

	Jugador1:render()
	Jugador2:render()

	Pelota:render()

	Push:apply('end')
end



		
