Paleta = Class{}

function Paleta:init(x ,y, ancho, alto)
    self.x = x
    self.y = y
    self.ancho = ancho
    self.alto = alto
    self.dy = 0
end

function Paleta:reset()
    self.x = ANCHO_VIRTUAL / 2 - 2
    self.y = ALTURA_VIRTUAL / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 10
    self.dx = math.random(-50, 50)
end

function Paleta:update(dt)
    
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(ALTURA_VIRTUAL - self.alto, self.y + self.dy * dt)
    end
end

function Paleta:render()
    love.graphics.rectangle('fill', self.x, self.y, self.ancho, self.alto)
end