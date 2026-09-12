-- Escenario: Bosque Encantado del Duende
Estructuras = {}
Estructuras.__index = Estructuras

-- Tags temáticos
local tag_arbol_izq = "ArbolIzquierdo"
local tag_arbol_der = "ArbolDerecho"
local tag_suelo = "SueloBosque"
local tag_rama = "RamaFlotante"
local tag_hongo = "HongoGigante"

function Estructuras:Nuevo(x, y, ruta, tag, escalax, escalay)
    local estructura = setmetatable({}, Estructuras)
    estructura.sprite = love.graphics.newImage(ruta)
    estructura.cuerpo = love.physics.newBody(world, x, y)
    estructura.escala_x = escalax
    estructura.escala_y = escalay
    estructura.forma = love.physics.newRectangleShape(
        estructura.sprite:getWidth() * estructura.escala_x, 
        estructura.sprite:getHeight() * estructura.escala_y
    )
    estructura.acople = love.physics.newFixture(estructura.cuerpo, estructura.forma)
    estructura.acople:setUserData(tag)
    estructura.acople:setFriction(0.3) -- Más fricción para sensación de tierra/madera
    return estructura
end

---- FUNCION PARA DIBUJAR ESTRUCTURAS DEL BOSQUE
function Estructuras:DibujarEstructura()
    love.graphics.draw(
        self.sprite, 
        self.cuerpo:getX(), 
        self.cuerpo:getY(), 
        0, 
        self.escala_x, 
        self.escala_y, 
        self.sprite:getWidth()/2, 
        self.sprite:getHeight()/2
    )
end

---- FUNCION PARA CREAR EL BOSQUE ENCANTADO
function CrearEscenario()
    -- ÁRBOLES GIGANTES (paredes laterales)
    arbol_izquierdo = Estructuras:Nuevo(
        6, 
        144/2, 
        "img/ArbolTronco.png",  -- Tronco con musgo
        tag_arbol_izq, 
        0.75, 
        1
    )
    
    arbol_derecho = Estructuras:Nuevo(
        154,
        144/2,
        "img/ArbolTronco.png",
        tag_arbol_der,
        0.75,
        1
    )
    
    -- SUELO DEL BOSQUE (tierra con hierba)
    suelo_bosque = Estructuras:Nuevo(
        160/2, 
        140, 
        "img/SueloBosque.png",  -- Tierra con raíces y hierba
        tag_suelo, 
        1, 
        1
    )
    
    -- PLATAFORMAS: RAMAS FLOTANTES (distribuidas estratégicamente)
    rama_central = Estructuras:Nuevo(
        ventana.ancho/2, 
        ventana.alto/2, 
        "img/RamaFlotante.png",  -- Rama con hojas
        tag_rama, 
        0.30,  -- Más ancha para mejor jugabilidad
        0.50
    )
    
    rama_superior_izq = Estructuras:Nuevo(
        35, 
        35, 
        "img/RamaFlotante.png",
        tag_rama,
        0.25,
        0.50
    )
    
    rama_superior_der = Estructuras:Nuevo(
        125, 
        35, 
        "img/RamaFlotante.png",
        tag_rama,
        0.25,
        0.50
    )
    
    rama_inferior_izq = Estructuras:Nuevo(
        35, 
        105, 
        "img/RamaFlotante.png",
        tag_rama,
        0.25,
        0.50
    )
    
    rama_inferior_der = Estructuras:Nuevo(
        125, 
        105, 
        "img/RamaFlotante.png",
        tag_rama,
        0.25,
        0.50
    )
    
    -- HONGOS GIGANTES (plataformas decorativas adicionales)
    hongo_izq = Estructuras:Nuevo(
        70, 
        70, 
        "img/HongoGigante.png",  -- Hongo con puntos
        tag_hongo,
        0.20,
        0.40
    )
    
    hongo_der = Estructuras:Nuevo(
        90, 
        70, 
        "img/HongoGigante.png",
        tag_hongo,
        0.20,
        0.40
    )
end

-- FUNCION PARA DIBUJAR TODO EL ESCENARIO
function DibujarEscenario()
    -- Dibujar árboles (paredes)
    arbol_izquierdo:DibujarEstructura()
    arbol_derecho:DibujarEstructura()
    
    -- Dibujar suelo
    suelo_bosque:DibujarEstructura()
    
    -- Dibujar ramas flotantes
    rama_central:DibujarEstructura()
    rama_superior_izq:DibujarEstructura()
    rama_superior_der:DibujarEstructura()
    rama_inferior_izq:DibujarEstructura()
    rama_inferior_der:DibujarEstructura()
    
    -- Dibujar hongos gigantes
    hongo_izq:DibujarEstructura()
    hongo_der:DibujarEstructura()
end