Estructuras = {}
Estructuras.__index = Estructuras

local tag1 = "Pared"
local tag2 = "Piso"
local tag3 = "Plataforma"

function Estructuras:Nuevo(x, y, ruta, tag, escalax, escalay)

    local plataforma = setmetatable({}, Estructuras)

    plataforma.sprite = love.graphics.newImage(ruta)
    plataforma.cuerpo = love.physics.newBody(world, x, y)
    plataforma.escala_x = escalax
    plataforma.escala_y = escalay
    plataforma.forma = love.physics.newRectangleShape(plataforma.sprite:getWidth()*plataforma.escala_x, plataforma.sprite:getHeight()*plataforma.escala_y)
    plataforma.acople = love.physics.newFixture(plataforma.cuerpo, plataforma.forma)
    plataforma.acople:setUserData(tag)

    plataforma.acople:setFriction (0) -- Evita que el jugador pueda agarrarse a las estructuras

    return plataforma

end

---- FUNCION PARA CREAR PARTES DEL ESCENARIO

function Estructuras:DibujarPlataforma()
    --love.graphics.polygon("fill", self.cuerpo:getWorldPoints(self.forma:getPoints()))
    love.graphics.draw(self.sprite, self.cuerpo:getX(), self.cuerpo:getY(), 0, self.escala_x, self.escala_y, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

---- FUNCIONES PARA CARGAR y DIBUJAR EL ESCENARIO RESPECTIVAMENTE

function CrearEscenario()
    columnaizquieda = Estructuras:Nuevo(6, 144/2, "img/Wall.png", tag1, 0.75, 1)
    columnaderecha = Estructuras: Nuevo(154,144/2,"img/Wall.png", tag1, 0.75, 1)

    piso = Estructuras:Nuevo(160/2, 140, "img/Floor.png", tag2, 1, 1)

    --plataformas sin sprites
    centro = Estructuras:Nuevo(ventana.ancho/2, ventana.alto/2, "img/Floor.png", tag3, 0.25, 0.50)

    superior_izq = Estructuras:Nuevo(40, 40, "img/Floor.png", tag3, 0.20, 0.50)
    superior_der = Estructuras:Nuevo(120, 40, "img/Floor.png", tag3, 0.20, 0.50)
    inferior_izq = Estructuras:Nuevo(40, 110, "img/Floor.png", tag3, 0.20, 0.50)
    inferior_der = Estructuras:Nuevo(120, 110, "img/Floor.png", tag3, 0.20, 0.50)
end

--NOTA: El cuerpo FISICO se origina desde el centro, mientras que los SPRITES desde la esquina superior izq
function DibujarEscenario()
    columnaizquieda:DibujarPlataforma()
    columnaderecha:DibujarPlataforma()

    piso:DibujarPlataforma()

    --plataformas sin sprite
    love.graphics.setColor(0,1,0)
    centro:DibujarPlataforma()

    superior_izq:DibujarPlataforma()
    superior_der:DibujarPlataforma()
    inferior_izq:DibujarPlataforma()
    inferior_der:DibujarPlataforma()
    love.graphics.setColor(1,1,1)
end