-- Resolucion
ventana={
    ancho = 160,
alto = 144,
escala = 4
}

jugador = {
    y = 0,
    x = 0,
    alto,
    ancho,
    origen_x,
    origen_y,
    velocidad= 50,
    sprite= nil
}

enemigo = {
    y = 100,
    x = 100,
    velocidad=50,
    sprite= nil
}



function love.load()
    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest","nearest")
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
    jugador.sprite = love.graphics.newImage("imagen/pers_000.png")
    enemigo.sprite= love.graphics.newImage("imagen/Squeletron.jpg")

    jugador.ancho= jugador.sprite:getWidth()
    jugador.alto= jugador.sprite:getHeight()
    jugador.origen_x= jugador.ancho/2
    jugador.origen_y= jugador.alto/2
    jugador.x =ventana.ancho /2
    jugador.y =ventana.alto /2
end
    function love.update(dt)
    -- Incrementaremos la variable en 1 unidad por cada segundo que la tecla "up" (flecha de arriba) esté pulsada.
    if love.keyboard.isDown("right") then
        jugador.x =  jugador.x + (jugador.velocidad * dt)  
    end
    if love.keyboard.isDown("left") then
        jugador.x =  jugador.x - (jugador.velocidad * dt)  
    end
    if love.keyboard.isDown("down") then
        jugador.y =  jugador.y + (jugador.velocidad * dt)  
    end
    if love.keyboard.isDown("up") then
        jugador.y =  jugador.y - (jugador.velocidad * dt)  
    end
    -- Persecución
    local dist_x= math.abs(enemigo.x-jugador.x)
    local dist_y= math.abs(enemigo.y-jugador.y)
    if dist_x> dist_y then
        if dist_x> jugador.ancho then
            if enemigo.x < jugador.x then

            enemigo.x = enemigo.x + (enemigo.velocidad * dt)
            elseif enemigo.x > jugador.x then
             enemigo.x = enemigo.x - (enemigo.velocidad * dt)
            end
        end
    else
         if dist_y> jugador.alto then
            if enemigo.y < jugador.y then
                enemigo.y = enemigo.y + (enemigo.velocidad * dt)
            elseif enemigo.y > jugador.y then
                enemigo.y = enemigo.y - (enemigo.velocidad * dt)
            end
        end
    end
end -- de la funcion

function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()
        love.graphics.draw(jugador.sprite,jugador.x,jugador.y,0,1,1,jugador.origen_x,jugador.origen_y)
        love.graphics.draw(enemigo.sprite,enemigo.x,enemigo.y)
    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)
end