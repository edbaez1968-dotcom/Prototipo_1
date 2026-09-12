-- Jugador: El Duende Recolector
jugador = {
    x = 0,
    y = 0,
    velocidad_x = 60,
    velocidad_y = 120,
    ancho = 0,
    alto = 0,
    origen_x = 0,
    origen_y = 0,
    hitbox_x = 0,
    hitbox_y = 0,
    sprite = nil,
    cuerpo = nil,
    forma = nil,
    acople = nil,
    encontacto = 0,
    
    -- Estadísticas del juego
    vidas = 3,
    meta = 15,          -- Antes 'cancion' (10). Ahora necesita 15 monedas para ganar.
    monedas = 0,        -- Antes 'notas'. Contador de monedas recolectadas.
    
    -- Animaciones
    correr_der = nil,
    correr_izq = nil,
    salto = nil,
    
    -- Sonidos
    salto_sonido = love.audio.newSource("sounds/salto_duende.wav", "static"),
    caminar = love.audio.newSource("sounds/pasos_duende.wav", "static"),
    
    -- Flag para determinar si el jugador puede saltar
    puede_saltar = true,
}

local tag = "jugador"

-- INICIALIZACIÓN
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
    
    -- Animaciones del Duende 
    -- NOTA: Asumo que tu spritesheet del duende tiene el mismo formato (16x16) que el del ninja.
    -- Si es diferente, ajusta los valores de ancho, alto y las coordenadas (columna, fila).
    jugador.correr_der = CrearAnimacion("img/DuendeSprites.png", 3, 16, 16, 12, true, 48, 16)
    jugador.correr_izq = CrearAnimacion("img/DuendeSprites.png", 3, 16, 16, 12, true, 32, 16)
    jugador.salto = CrearAnimacion("img/DuendeSprites.png", 0, 16, 16, 2, false, 16, 96)
    
    -----------
    jugador.acople:setUserData(tag)
    jugador.cuerpo:setFixedRotation(true)
end

-- ACTUALIZAR
function jugador.Actualizar(dt)
    local dx, dy = jugador.cuerpo:getLinearVelocity()
    dx = 0 -- Evita que el jugador se deslice por el piso
    
    if love.keyboard.isDown("right") then
        dx = jugador.velocidad_x
        if not jugador.puede_saltar then
            love.audio.stop(jugador.caminar)
        else 
            love.audio.play(jugador.caminar)
        end
        jugador.correr_der.activado = true
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
        
    elseif love.keyboard.isDown("left") then
        dx = -jugador.velocidad_x
        if not jugador.puede_saltar then
            love.audio.stop(jugador.caminar)
        else 
            love.audio.play(jugador.caminar)
        end
        jugador.correr_izq.activado = true
        jugador.salto.activado = false
        
    else -- IDLE
        jugador.correr_der.activado = false
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
        if jugador.caminar:isPlaying() then
            love.audio.stop(jugador.caminar)
        end
    end
    
    if love.keyboard.isDown("up") then
        if jugador.puede_saltar then
            dy = -jugador.velocidad_y
            love.audio.play(jugador.salto_sonido)
            jugador.puede_saltar = false
        end
    end
    
    if not jugador.puede_saltar then
        jugador.salto.activado = true
    end
    
    -- Evita que salte fuera de la ventana por arriba
    if jugador.cuerpo:getY() < 5 then
        dy = 0
    end
    
    jugador.cuerpo:setLinearVelocity(dx, dy)
    
    ActualizarAnimacion(jugador.correr_der, dt, false)
    ActualizarAnimacion(jugador.correr_izq, dt, false)
    ActualizarAnimacion(jugador.salto, dt, false)
    
    -- Hitbox para colisión con las Monedas
    jugador.hitbox_x = jugador.cuerpo:getX() - jugador.origen_x
    jugador.hitbox_y = jugador.cuerpo:getY() - jugador.origen_y
end

-- DIBUJAR
function jugador.Dibujar()
    DibujarAnimacion(jugador.correr_der, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    DibujarAnimacion(jugador.correr_izq, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    DibujarAnimacion(jugador.salto, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x, jugador.origen_y)
    
    if not jugador.correr_der.activado and not jugador.correr_izq.activado and not jugador.salto.activado then
        love.graphics.draw(jugador.sprite, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 0, 1, 1, jugador.origen_x, jugador.origen_y)
    end
end

-- DEBUG
function jugador.Debug()
    love.graphics.rectangle("line", redondear(jugador.hitbox_x), redondear(jugador.hitbox_y), jugador.ancho, jugador.alto)
    love.graphics.circle("fill", redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 1)
end