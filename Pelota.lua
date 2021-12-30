Pelota = Class{}

function Pelota:init(x ,y, ancho, alto)
    self.x = x
    self.y = y
    self.ancho = ancho
    self.alto = alto
    
    self.dy = math.random(2) == 1 and -100 or 10
    self.dx = math.random(-50, 50)
end

function Pelota:reset()
    self.x = ANCHO_VIRTUAL / 2 - 2
    self.y = ALTO_VIRTUAL / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 10
    self.dx = math.random(-50, 50)
end

function Pelota:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    
end

function Pelota:render()
    love.graphics.rectangle('fill', self.x, self.y, self.ancho, self.alto)
end