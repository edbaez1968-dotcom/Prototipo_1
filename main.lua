-- Resolucion
ANCHO_VENTANA = 160
ALTO_VENTANA = 144
ESCALA = 4

x = 0
y = 0
img = love.graphics.newImage("imagen/jugador1.jpg")

function love.load()
    love.window.setMode(ANCHO_VENTANA * ESCALA, ALTO_VENTANA * ESCALA)
end

function love.draw()
    love.graphics.draw(img,x,y,0, 1)
end