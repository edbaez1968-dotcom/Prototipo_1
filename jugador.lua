jugador = {
    x= 0,
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

    vidas = 3,
    cancion = 10,
    notas = 0,

    --Animaciones
    correr_der = nil,
    correr_izq = nil,
    salto = nil,

    --Sonidos
    salto_sonido = love.audio.newSource("sounds/jump.wav", "static"),
    caminar = love.audio.newSource("sounds/pasos.wav", "static"),

    --Flag para determinar si el jugador puede saltar
    puede_saltar = true,
}


local tag = "jugador"

--INICIALIZACIÓN
function jugador.Crear(x, y)

    jugador.x = x
    jugador.y = y
    jugador.sprite = love.graphics.newImage("img/Ninja.png")
    jugador.ancho = jugador.sprite:getWidth()
    jugador.alto = jugador.sprite:getHeight()
    jugador.origen_x = jugador.ancho/2
    jugador.origen_y = jugador.alto/2
    jugador.cuerpo = love.physics.newBody(world, x, y, "dynamic")
    jugador.forma = love.physics.newRectangleShape(jugador.sprite:getWidth(), jugador.sprite:getHeight())
    jugador.acople = love.physics.newFixture(jugador.cuerpo, jugador.forma)

    --Animaciones
    jugador.correr_der = CrearAnimacion("img/NinjaSprites.png",3,16,16,12, true, 48, 16)
    jugador.correr_izq = CrearAnimacion("img/NinjaSprites.png",3,16,16,12, true, 32, 16)
    jugador.salto = CrearAnimacion("img/NinjaSprites.png",0,16,16,2, false, 16, 96)
    -----------

    jugador.acople:setUserData(tag)

    jugador.cuerpo:setFixedRotation(true)
end


--ACTUALIZAR
function jugador.Actualizar(dt)

local dx, dy = jugador.cuerpo:getLinearVelocity()
dx=0 -- Evita que el jugador se deslice por el piso

    if love.keyboard.isDown("right") then
        dx = jugador.velocidad_x
        
        if not jugador.puede_saltar then
            love.audio.stop(jugador.caminar)
            else love.audio.play(jugador.caminar)
        end

        jugador.correr_der.activado = true
        jugador.correr_izq.activado = false
        jugador.salto.activado = false
    
    elseif love.keyboard.isDown("left") then
        dx = - jugador.velocidad_x
        
        if not jugador.puede_saltar then
            love.audio.stop(jugador.caminar)
            else love.audio.play(jugador.caminar)
        end
        
        jugador.correr_izq.activado = true
        jugador.salto.activado = false


        --IDLE -- esto podría ser una función que devuelva booleanos para verificar si se esta moviendo
    else jugador.correr_der.activado = false
         jugador.correr_izq.activado = false
         jugador.salto.activado = false
         if jugador.caminar:isPlaying()then
            love.audio.stop(jugador.caminar)
         end
    end

    if  love.keyboard.isDown("up")  then
        if jugador.puede_saltar then
            dy = - jugador.velocidad_y
            love.audio.play(jugador.salto_sonido)
            jugador.puede_saltar = false
        end
    end
 
    if not jugador.puede_saltar then
        jugador.salto.activado = true
    end

-- Envita que salte fuera de la ventana
    if jugador.cuerpo:getY() < 5 then
        dy = 0
    end

jugador.cuerpo:setLinearVelocity(dx,dy)

ActualizarAnimacion(jugador.correr_der,dt, false)
ActualizarAnimacion(jugador.correr_izq,dt, false)
ActualizarAnimacion(jugador.salto,dt, false)

-- Hitbox para colision con Notas Musicales (posiblemente se cambie mas adelante)
jugador.hitbox_x = jugador.cuerpo:getX() - jugador.origen_x
jugador.hitbox_y = jugador.cuerpo:getY() - jugador.origen_y

end

--DIBUJAR
function jugador.Dibujar()
    --love.graphics.polygon("fill", jugador.cuerpo:getWorldPoints(jugador.forma:getPoints()))
    
DibujarAnimacion(jugador.correr_der, redondear(jugador.cuerpo:getX()), redondear(jugador. cuerpo:getY()), jugador.origen_x, jugador.origen_y)
DibujarAnimacion(jugador.correr_izq, redondear(jugador.cuerpo:getX()), redondear(jugador. cuerpo:getY()), jugador.origen_x, jugador.origen_y)
DibujarAnimacion(jugador.salto, redondear(jugador.cuerpo:getX()), redondear(jugador. cuerpo:getY()), jugador.origen_x, jugador.origen_y)

    if not jugador.correr_der.activado and not jugador.correr_izq.activado and not jugador.salto.activado then
        love.graphics.draw(jugador.sprite, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 0,1,1, jugador.origen_x, jugador.origen_y)
    end
end

--DEBUG
function jugador.Debug()
    love.graphics.rectangle("line", redondear(jugador.hitbox_x), redondear(jugador.hitbox_y), jugador.ancho, jugador.alto)
    love.graphics.circle("fill", redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), 1)
end