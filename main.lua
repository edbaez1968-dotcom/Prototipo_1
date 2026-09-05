-- Resolucion
ANCHO_VENTANA = 200
ALTO_VENTANA = 205
ESCALA = 4

x = 0
y = 0
img = love.graphics.newImage("imagen/jugador1.jpg")

function love.load()
    love.window.setMode(ANCHO_VENTANA * ESCALA, ALTO_VENTANA * ESCALA)
    lienzo = love.graphics.newCanvas(ANCHO_VENTANA, ALTO_VENTANA)
end

function love.draw()
    love.graphics.setCanvas(lienzo)
        love.graphics.draw(img,x,y)
    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ESCALA, ESCALA)
end