-- Objetivo y "enemigo" del juego: Monedas del Bosque
Monedas = {}
Monedas.__index = Monedas

-- INICIALIZACIÓN
function Monedas:Nueva(x, y, ruta, velocidad, escala, ruta_sonido, tipo)
    local o = setmetatable({}, Monedas)
    o.x = x
    o.y = y
    o.escala = escala
    o.sprite = love.graphics.newImage(ruta)
    o.ancho = o.sprite:getWidth()
    o.alto = o.sprite:getHeight()
    o.origen_x = o.ancho / 2 
    o.origen_y = o.alto / 2 
    o.hitbox_x = 0
    o.hitbox_y = 0
    o.hitbox_ancho = 0
    o.hitbox_alto = 0
    o.velocidad = velocidad
    o.recolectada = false -- Antes 'atrapado'
    o.sonido = love.audio.newSource(ruta_sonido, "static")
    
    -- Definir tipo y valor de la moneda
    o.tipo = tipo -- "oro" o "plata"
    o.valor = (tipo == "plata") and 2 or 1 
    
    return o
end

-- FUNCIONES DE COMPORTAMIENTO
function Monedas:Colisiones()
    local x1 = jugador.hitbox_x
    local y1 = jugador.hitbox_y
    local ancho1 = jugador.ancho
    local alto1 = jugador.alto
    local x2 = self.hitbox_x
    local y2 = self.hitbox_y
    local ancho2 = self.hitbox_ancho
    local alto2 = self.hitbox_alto
    
    return x1 < x2 + ancho2 and
           x2 < x1 + ancho1 and
           y1 < y2 + alto2 and
           y2 < y1 + alto1
end

function Monedas:PosicionarMoneda()
    local borde = math.random(1, 4)
    if borde == 1 then
        self.x = math.random(0, ventana.ancho)
        self.y = 0
    elseif borde == 2 then
        self.x = math.random(0, ventana.ancho)
        self.y = ventana.alto
    elseif borde == 3 then
        self.x = 0 -- Corregido: antes usaba ventana.alto para X
        self.y = math.random(0, ventana.alto)
    elseif borde == 4 then
        self.x = ventana.ancho -- Corregido: antes usaba ventana.alto para X
        self.y = math.random(0, ventana.alto)
    end
    self.recolectada = false
end

-- En caso de colisión, controla la recolección y el cambio de variables
function Monedas:Recolectar(tipo_ataque)
    if self.recolectada then
        self:PosicionarMoneda()
        
        -- Verificar si el ataque coincide con el tipo de moneda
        if tipo_ataque == self.tipo then
            jugador.monedas = jugador.monedas + self.valor
            love.audio.play(self.sonido)
            
            if jugador.monedas >= jugador.meta then
                victoria = true
                love.audio.stop(sonidos.musica)
                love.audio.play(sonidos.victoria)
            end
        else 
            -- Si el duende usa el ataque incorrecto, pierde vida
            jugador.vidas = jugador.vidas - 1
            love.audio.play(sonidos.sfx_hit)
            
            if jugador.vidas == 0 then
                derrota = true
                love.audio.stop(sonidos.musica)
                love.audio.play(sonidos.derrota)
            end
        end
    end
end

------ ACTUALIZACIÓN --------
function Monedas:Actualizar(x, y, a, al, dt)
    -- Persecución al jugador
    local dist_x = math.abs(self.x - x)
    local dist_y = math.abs(self.y - y)
    
    if dist_x > dist_y then
         if dist_x > a then
             if self.x < x then
                 self.x = self.x + (self.velocidad * dt)
             elseif self.x > x then
                 self.x = self.x - (self.velocidad * dt)
             end
         end
     else
         if dist_y > al then
             if self.y < y then
                 self.y = self.y + (self.velocidad * dt)
             elseif self.y > y then
                 self.y = self.y - (self.velocidad * dt)
             end
         end
     end
     
     self.hitbox_ancho = self.ancho * self.escala
     self.hitbox_alto = self.alto * self.escala
     self.hitbox_x = self.x - (self.hitbox_ancho / 2)
     self.hitbox_y = self.y - (self.hitbox_alto / 2)
end

------ RENDER --------
function Monedas:Dibujar()
    love.graphics.draw(self.sprite, redondear(self.x), redondear(self.y), 0, self.escala, self.escala, self.origen_x, self.origen_y)
end

------ DEBUG --------
function Monedas:Debug()
    love.graphics.rectangle("line", redondear(self.hitbox_x), redondear(self.hitbox_y), self.hitbox_ancho, self.hitbox_alto)
    love.graphics.circle("fill", redondear(self.x), redondear(self.y), 1)
end