-- Resolucion
ANCHO_VENTANA = 200
ALTO_VENTANA = 205
ESCALA = 4
jugador = {
    y = 0,
    x = 0,
    sprite= nil
}
x = 0
y = 0
jugador.sprite = love.graphics.newImage("imagen/jugador1.jpg")
enemigo_x = 100
enemigo_y = 100
enemigo= love.graphics.newImage("imagen/enem_1.png")

function love.load()
    love.window.setMode(ANCHO_VENTANA * ESCALA, ALTO_VENTANA * ESCALA)
    love.graphics.setDefaultFilter("nearest","nearest")
    lienzo = love.graphics.newCanvas(ANCHO_VENTANA, ALTO_VENTANA)
end

function love.draw()
    love.graphics.setCanvas(lienzo)
        love.graphics.draw(jugador.sprite,jugador.x,jugador.y)
        love.graphics.draw(enemigo,enemigo_x,enemigo_y)
    love.graphics.setCanvas()

    love.graphics.draw(lienzo, 0, 0, 0, ESCALA, ESCALA)
end