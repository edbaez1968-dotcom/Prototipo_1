require ("escenario")
require ("jugador")
require ("monedas")
require ("animaciones")

-- VENTANA     (pensado para un juego pixel art)
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

ataque = nil
ataque2 = nil
ataque3 = nil
ataque4 = nil
color = nil

derrota = false
victoria = false


--SONIDOS
sonidos = {
    musica = love.audio.newSource("sounds/musica.ogg", "stream"),
    victoria = love.audio.newSource("sounds/victoria.wav", "stream"),
    derrota = love.audio.newSource("sounds/derrota.wav", "stream"),
    sfx_hit = love.audio.newSource("sounds/hit.wav", "static"),
    sfx_whoosh = love.audio.newSource("sounds/whoosh.wav", "static"),
}

---------------------------- FUNCIONES -----------------------------------

-- COLISIONES

-- Por cuerpo físico
function iniciarContacto(a,b,col)

    contacto = true
    nx,ny = col:getNormal()

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto + 1
    end
      
    if a:getUserData() == "jugador" and b:getUserData() == "Piso" or
       a:getUserData() == "jugador" and b:getUserData() == "Plataforma"  then
       if ny > 0.5 then -- Soloe permite saltar si esta en la parte SUPERIOR
        jugador.puede_saltar = true
       end 
    end

    entidad1 = a:getUserData()
    entidad2 = b:getUserData()
  
end

function terminarContacto(a,b,col)
    contacto = false
  

    if a:getUserData() == "jugador" or b:getUserData() == "jugador" then
        jugador.encontacto = jugador.encontacto - 1
    end

    if jugador.encontacto == 0 then
    jugador.puede_saltar = false -- Evita saltar "en caida"
    end

    entidad1 = nil
    entidad2 = nil
end

---------------------------------------------------------------

-- REDONDEO ya que se trabaja con pixel art
function redondear(n)
    return math.floor(n + 0.5)
end


-- DEBUG
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    if nota_roja.atrapado or nota_verde.atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
    end
    love.graphics.setColor(1, 1, 1)
end

function debugHitboxes()
        love.graphics.setColor(0, 1, 0)
        jugador.Debug()
        nota_roja:Debug()
        nota_verde:Debug()
        nota_azul:Debug()
        nota_amarilla:Debug()
        love.graphics.setColor(1, 1, 1)
end


-- INTERACCION INPUT
function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        depurar = not depurar
    elseif key == "q" and not ataque_oro.activado then
		ataque_oro.activado = true
		love.audio.play(sonidos.sfx_whoosh)
	elseif key == "w" and not ataque_plata.activado then
		ataque_plata.activado = true
		love.audio.play(sonidos.sfx_whoosh)
    elseif key == "e" and not ataque3.activado then
        ataque3.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    elseif key == "r" and not ataque4.activado then
        ataque4.activado =true
        love.audio.play(sonidos.sfx_whoosh)
    end 
end

------------------------ INICIAR - ACTUALIZAR - RENDERIZAR ----------------------

-- INICIALIZACION
function love.load()

    --Inicializacion del mundo fisico
    love.physics.setMeter(32)
    world = love.physics.newWorld(0,9.81*16,true)
    world:setCallbacks(iniciarContacto, terminarContacto)

    --Inicializacion de la ventana
    love.window.setMode (ventana.ancho * ventana.escala, ventana.alto * ventana.escala )
    love.graphics.setDefaultFilter("nearest", "nearest")

    --MUSICA
    sonidos.musica:setLooping(true)
    sonidos.musica:setVolume(0.70) -- 0 a 1
    love.audio.play(sonidos.musica)

    -- Incializacion del Canvas
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    --Inicializacion del Jugador
	--Inicializacion del Jugador (Nace más arriba para no chocar con la plataforma central)
	jugador.Crear(ventana.ancho/2, 20)
    --jugador.Crear(ventana.ancho/2, 70)

	-- Iniciar Monedas
	moneda_oro = Monedas:Nueva(130, 130, "img/MonedaOro.png", 10, 1, "sounds/moneda_oro.wav", "oro")
	moneda_plata = Monedas:Nueva(130, 130, "img/MonedaPlata.png", 20, 1, "sounds/moneda_plata.wav", "plata")

	-- Ataques del Duende (Solo 2: Q para Oro, W para Plata)
	ataque_oro = CrearAnimacion("img/AtaqueOro.png", 3, 32, 32, 12, false, 32, 0)
	ataque_oro.activado = false

	ataque_plata = CrearAnimacion("img/AtaquePlata.png", 4, 25, 24, 12, false, 25, 0)
	ataque_plata.activado = false

    ataque3 = CrearAnimacion("img/AtaqueOro.png", 3, 32, 32, 12, false, 32, 0) 
	ataque3.activado = false
	ataque4 = CrearAnimacion("img/AtaqueOro.png", 3, 32, 32, 12, false, 32, 0) 
	ataque4.activado = false
	
	
-- Posiciones iniciales
math.randomseed(os.time())
moneda_oro:PosicionarMoneda()
moneda_plata:PosicionarMoneda()

    -- Posiciones de notas musicales
    math.randomseed(os.time())

    CrearEscenario()
end

-- ACTUALIZACION-- 
function love.update(dt)
    if derrota or victoria then
        return
    end
    
    world:update(dt)
    jugador.Actualizar(dt)
    
    -- Animaciones de ataque del jugador (SOLO 2 ataques ahora)
    ActualizarAnimacion(ataque_oro, dt, true)
    ActualizarAnimacion(ataque_plata, dt, true)
    
    -- Movimiento de las monedas
    moneda_oro:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    moneda_plata:Actualizar(jugador.cuerpo:getX(), jugador.cuerpo:getY(), jugador.ancho, jugador.alto, dt)
    
    -- Verificación de colisión
    moneda_oro.recolectada = moneda_oro:Colisiones()
    moneda_plata.recolectada = moneda_plata:Colisiones()
    
    -- Función que verifica el tipo de ataque y las condiciones de victoria/derrota
    moneda_oro:Recolectar("oro")
    moneda_plata:Recolectar("plata")
end
-- RENDER
function love.draw()
    love.graphics.setCanvas(lienzo)
    love.graphics.clear()
    
    DibujarEscenario()
    jugador:Dibujar() 
    
    -- Dibuja los ataques (SOLO 2)
    love.graphics.setColor(1, 0.8, 0) -- Color dorado
    DibujarAnimacion(ataque_oro, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 8, jugador.origen_y + 8)
    
    love.graphics.setColor(0.8, 0.8, 1) -- Color plateado
    DibujarAnimacion(ataque_plata, redondear(jugador.cuerpo:getX()), redondear(jugador.cuerpo:getY()), jugador.origen_x + 5, jugador.origen_y + 5)
    
    love.graphics.setColor(1, 1, 1)
    
    -- Dibuja las monedas (SOLO 2)
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
    
    -- Interfaz de usuario
    if not derrota then
        love.graphics.print("Vidas: "..jugador.vidas, 10, 10)
    end
    if not victoria then
        love.graphics.print("Monedas: "..jugador.monedas.."/"..jugador.meta, 10, 25)
    end
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Presiona Q (Oro) y W (Plata) para recolectar", 10, 40)
    love.graphics.setColor(1, 1, 1)
end