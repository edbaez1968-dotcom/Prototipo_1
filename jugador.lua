-- Jugador: El Duende Recolector
jugador = {
    x = 0, y = 0,
	 -- Físicas de movimiento
    velocidad_max = 100,    -- Velocidad tope (no puede correr más rápido que esto)
    aceleracion = 250,      -- Qué tan rápido gana velocidad al tocar tecla
    friccion = 0.90,
    velocidad_x = 80, velocidad_y = 120,
    ancho = 0, alto = 0,
    origen_x = 0, origen_y = 0,
    hitbox_x = 0, hitbox_y = 0,
    sprite = nil, cuerpo = nil, forma = nil, acople = nil,
    encontacto = 0,
    vidas = 3, meta = 7, monedas = 0,
    correr_der = nil, correr_izq = nil, salto = nil,
    salto_sonido = love.audio.newSource("sounds/whoosh.wav", "static"),
    caminar = nil,
    puede_saltar = true,
}

local tag = "jugador"

function jugador.Crear(x, y)
    jugador.x = x
    jugador.y = y
    jugador.sprite = love.graphics.newImage("img/Duende.png")
    jugador.ancho = jugador.sprite:getWidth()
    jugador.alto = jugador.sprite:getHeight()
    jugador.origen_x = jugador.ancho / 2
    jugador.origen_y = jugador.alto / 2
    
    jugador.cuerpo = love.physics.newBody(world, x, y, "dynamic")
    jugador.forma = love.physics.newRectangleShape(jugador.sprite:getWidth(), jugador.sprite:getHeight())
    jugador.acople = love.physics.newFixture(jugador.cuerpo, jugador.forma)
    
    
    jugador.correr_der = CrearAnimacion("img/DuendeSprites.png", 9, 14, 16, 10, false, 16, 16)
    jugador.correr_izq = CrearAnimacion("img/DuendeSprites.png", 9, 14, 16, 10, false, 16, 16)
    jugador.salto = CrearAnimacion("img/DuendeSprites.png", 9, 16, 14, 10, false, 16, 16)
    
    jugador.correr_der.activado = false
    jugador.correr_izq.activado = false
    jugador.salto.activado = false
    
    jugador.acople:setUserData(tag)
    jugador.cuerpo:setFixedRotation(true)
end

function jugador.Actualizar(dt)
    jugador.cuerpo:setAwake(true) 
    -- Obtenemos la velocidad actual (no la reseteamos a 0)
    local dx, dy = jugador.cuerpo:getLinearVelocity()
    
    -- --- LÓGICA DE RESBALAMIENTO ---
    if love.keyboard.isDown("right") then
        -- Acelerar hacia la derecha
        dx = dx + (jugador.aceleracion * dt)
        jugador.correr_der.activado = true
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
        
    elseif love.keyboard.isDown("left") then
        -- Acelerar hacia la izquierda
        dx = dx - (jugador.aceleracion * dt)
        jugador.correr_izq.activado = true
        jugador.correr_der.activado = false
        jugador.salto.activado = false
        
    else
        -- IDLE: Aplicar fricción (resbalar hasta detenerse)
        dx = dx * jugador.friccion
        
        -- Detener completamente si la velocidad es muy baja (evita vibración)
        if math.abs(dx) < 1 then 
            dx = 0 
        end
        
        jugador.correr_der.activado = false
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
    end
    
    -- Limitar la velocidad máxima para que no acelere infinitamente
    if dx > jugador.velocidad_max then dx = jugador.velocidad_max end
    if dx < -jugador.velocidad_max then dx = -jugador.velocidad_max end
    
    -- --- SALTO ---
    if love.keyboard.isDown("up") then
        if jugador.puede_saltar then
            dy = -jugador.velocidad_y
            if jugador.salto_sonido then 
                love.audio.play(jugador.salto_sonido) 
            end
            jugador.puede_saltar = false
        end
    end
    
    if not jugador.puede_saltar then
        jugador.salto.activado = true
    end
    
    -- Techo
    if jugador.cuerpo:getY() < 5 then
        dy = 0
    end
    
    -- Aplicar velocidades finales
    jugador.cuerpo:setLinearVelocity(dx, dy)
    
    if love.keyboard.isDown("right") then
        dx = jugador.velocidad_x
        jugador.correr_der.activado = true
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
    elseif love.keyboard.isDown("left") then
        dx = -jugador.velocidad_x
        jugador.correr_izq.activado = true
        jugador.correr_der.activado = false
        jugador.salto.activado = false
    else
        jugador.correr_der.activado = false
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
    end
    
    if love.keyboard.isDown("up") then
        if jugador.puede_saltar then
            dy = -jugador.velocidad_y
            if jugador.salto_sonido then love.audio.play(jugador.salto_sonido) end
            jugador.puede_saltar = false
        end
    end
    
    if not jugador.puede_saltar then
        jugador.salto.activado = true
    end
    
    if jugador.cuerpo:getY() < 5 then dy = 0 end
    
    jugador.cuerpo:setLinearVelocity(dx, dy)
    
    ActualizarAnimacion(jugador.correr_der, dt, false)
    ActualizarAnimacion(jugador.correr_izq, dt, false)
    ActualizarAnimacion(jugador.salto, dt, false)
    
    jugador.hitbox_x = jugador.cuerpo:getX() - jugador.origen_x
    jugador.hitbox_y = jugador.cuerpo:getY() - jugador.origen_y
end

function jugador.Dibujar()
    DibujarAnimacion(jugador.correr_der, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    DibujarAnimacion(jugador.correr_izq, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    DibujarAnimacion(jugador.salto, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    
    if not jugador.correr_der.activado and not jugador.correr_izq.activado and not jugador.salto.activado then
        love.graphics.draw(jugador.sprite, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 0, 1, 1, jugador.origen_x, jugador.origen_y)
    end
end

function jugador.Debug()
    love.graphics.rectangle("line", redondear(jugador.hitbox_x), redondear(jugador.hitbox_y), jugador.ancho, jugador.alto)
    love.graphics.circle("fill", redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 1)
end