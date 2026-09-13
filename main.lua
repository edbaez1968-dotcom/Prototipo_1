require("escenario")
require("jugador")
require("monedas")
require("animaciones")

-- VENTANA (pixel art)
ventana = {
    ancho = 160,
    alto = 144,
    escala = 4
}

entidad1 = nil
entidad2 = nil
contacto = false
nx, ny = nil
depurar = false
derrota = false
victoria = false

-- SONIDOS
sonidos = {
    musica = love.audio.newSource("sounds/musica.ogg", "stream"),
	
salto_sonido = love.audio.newSource("sounds/jump.wav", "static"),
caminar = love.audio.newSource("sounds/pasos.wav", "static"),
    victoria = love.audio.newSource("sounds/victoria.wav", "static"),
    derrota = love.audio.newSource("sounds/derrota.wav", "static"),
    sfx_hit = love.audio.newSource("sounds/hit.wav", "static"),
    sfx_whoosh = love.audio.newSource("sounds/whoosh.wav", "static"),
    moneda_oro = love.audio.newSource("sounds/moneda_oro.wav", "static"),
    moneda_plata = love.audio.newSource("sounds/moneda_plata.wav", "static"),
}

-- VARIABLES DE JUEGO
ataque_oro = nil
ataque_plata = nil
moneda_oro = nil
moneda_plata = nil

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES FÍSICAS
function iniciarContacto(a, b, col)
    contacto = true
    nx, ny = col:getNormal()
    
    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto + 1
    end
    
    if (a:getUserData() == "jugador" and b:getUserData() == "Piso") or
       (a:getUserData() == "jugador" and b:getUserData() == "Plataforma") or
       (b:getUserData() == "jugador" and a:getUserData() == "Piso") or
       (b:getUserData() == "jugador" and a:getUserData() == "Plataforma") then
        if ny > 0.5 then
            jugador.puede_saltar = true
        end
    end
    
    entidad1 = a:getUserData()
    entidad2 = b:getUserData()
end

function terminarContacto(a, b, col)
    contacto = false
    
    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto - 1
    end
    
    if jugador.encontacto <= 0 then
        jugador.puede_saltar = false
        jugador.encontacto = 0
    end
    
    entidad1 = nil
    entidad2 = nil
end

-- REDONDEO para pixel art
function redondear(n)
    return math.floor(n + 0.5)
end

-- DEBUG
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    
    if moneda_oro and moneda_oro.recolectada then
        love.graphics.print("ORO RECOLECTADA", 10, 25)
    end
    if moneda_plata and moneda_plata.recolectada then
        love.graphics.print("PLATA RECOLECTADA", 10, 40)
    end
    
    love.graphics.setColor(1, 1, 1)
end

function debugHitboxes()
    love.graphics.setColor(0, 1, 0)
    jugador:Debug()
    if moneda_oro then moneda_oro:Debug() end
    if moneda_plata then moneda_plata:Debug() end
    love.graphics.setColor(1, 1, 1)
end

-- INTERACCIÓN INPUT
function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        depurar = not depurar
    elseif key == "q" and ataque_oro and not ataque_oro.activado then
        ataque_oro.activado = true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "w" and ataque_plata and not ataque_plata.activado then
        ataque_plata.activado = true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "r" then
        -- Reiniciar juego
        if derrota or victoria then
            derrota = false
            victoria = false
            jugador.vidas = 3
            jugador.monedas = 0
            jugador.Crear(ventana.ancho/2, 20)
            moneda_oro:PosicionarMoneda()
            moneda_plata:PosicionarMoneda()
            love.audio.play(sonidos.musica)
        end
    end
end

------------------------ INICIAR - ACTUALIZAR - RENDERIZAR ----------------------

-- INICIALIZACIÓN
function love.load()
    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 9.81 * 16, true)
    world:setCallbacks(iniciarContacto, terminarContacto)
    
    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- MÚSICA
    sonidos.musica:setLooping(true)
    sonidos.musica:setVolume(0.70)
    love.audio.play(sonidos.musica)
    
    -- CANVAS
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
    
    -- JUGADOR
    jugador.Crear(ventana.ancho/2, 20)
    
    -- MONEDAS
    moneda_oro = Monedas:Nueva(130, 130, "img/MonedaOro.png", 10, 1, "sounds/moneda_oro.wav", "oro")
    moneda_plata = Monedas:Nueva(130, 130, "img/MonedaPlata.png", 15, 1, "sounds/moneda_plata.wav", "plata")
    
    -- ATAQUES
    ataque_oro = CrearAnimacion("img/AtaqueOro.png", 3, 32, 32, 12, false, 32, 0)
    ataque_oro.activado = false
    
    ataque_plata = CrearAnimacion("img/AtaquePlata.png", 4, 25, 24, 12, false, 25, 0)
    ataque_plata.activado = false
    
    -- POSICIONES INICIALES
    math.randomseed(os.time())
    moneda_oro:PosicionarMoneda()
    moneda_plata:PosicionarMoneda()
    
    -- ESCENARIO
    CrearEscenario()
end

-- ACTUALIZACIÓN
function love.update(dt)
    if derrota or victoria then
        return
    end
    
    world:update(dt)
    jugador.Actualizar(dt)
    
    -- Animaciones de ataque
    ActualizarAnimacion(ataque_oro, dt, true)
    ActualizarAnimacion(ataque_plata, dt, true)
    
    -- Movimiento de monedas
    moneda_oro:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    moneda_plata:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    
    -- Verificación de colisión
    moneda_oro.recolectada = moneda_oro:Colisiones()
    moneda_plata.recolectada = moneda_plata:Colisiones()
    
    -- Recolección con verificación de ataque
    if moneda_oro.recolectada then
        if ataque_oro.activado then
            moneda_oro:Recolectar()
        end
    end
    
    if moneda_plata.recolectada then
        if ataque_plata.activado then
            moneda_plata:Recolectar()
        end
    end
end

-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()
    
    DibujarEscenario()
    jugador:Dibujar()
    
    -- Ataques
    love.graphics.setColor(1, 0.8, 0)
    DibujarAnimacion(ataque_oro, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 8, jugador.origen_y + 8)
    
    love.graphics.setColor(0.8, 0.8, 1)
    DibujarAnimacion(ataque_plata, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 5, jugador.origen_y + 5)
    
    love.graphics.setColor(1, 1, 1)
    
    -- Monedas
    moneda_oro:Dibujar()
    moneda_plata:Dibujar()
    
    if depurar then
        debugHitboxes()
    end
    
    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, ventana.escala, ventana.escala)
    
    if depurar then
        debugUI()
    end
    
    -- UI
    love.graphics.setColor(1, 1, 1)
    if not derrota then
        love.graphics.print("Vidas: " .. jugador.vidas, 10, 10)
    end
    if not victoria then
        love.graphics.print("Monedas: " .. jugador.monedas .. "/7", 10, 25)
    end
    
    -- Instrucciones
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Q=Oro  W=Plata", 10, 40)
    love.graphics.setColor(1, 1, 1)
    
    -- Pantallas de fin
    if victoria then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("¡VICTORIA!", ventana.ancho * ventana.escala / 2 - 40, ventana.alto * ventana.escala / 2 - 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Presiona R para reiniciar", ventana.ancho * ventana.escala / 2 - 60, ventana.alto * ventana.escala / 2 + 10)
    elseif derrota then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("DERROTA", ventana.ancho * ventana.escala / 2 - 35, ventana.alto * ventana.escala / 2 - 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Presiona R para reiniciar", ventana.ancho * ventana.escala / 2 - 60, ventana.alto * ventana.escala / 2 + 10)
    end
end