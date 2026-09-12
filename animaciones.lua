-- Libreria Animaciones con Quads

--INICIALIZACION
function CrearAnimacion(imagen, limite, ancho, alto, velocidad, esVertical, columna, fila)
    local animacion = {}

    animacion.spritesheet = love.graphics.newImage(imagen)
    animacion.indice = 1
    animacion.velocidad = velocidad
    animacion.quads = {}
    animacion.activado = true

    if esVertical then
        for i = 0, limite, 1 do
            table.insert(animacion.quads, love.graphics.newQuad(columna, fila * i, ancho, alto, animacion.spritesheet))
        end
    else
        for i = 0, limite, 1 do 
            if limite == 0 then
                table.insert(animacion.quads, love.graphics.newQuad( columna , fila , ancho, alto, animacion.spritesheet))
            else table.insert(animacion.quads, love.graphics.newQuad( columna * i , fila , ancho, alto, animacion.spritesheet))
         end
        end
    end

    return animacion
end

--ACTUALIZACION
function ActualizarAnimacion(animacion, dt, unaVez)
    if animacion.activado then
        animacion.indice = animacion.indice + (animacion.velocidad * dt)
        if animacion.indice >= #animacion.quads + 1 then
            animacion.indice = 1
            if unaVez then
                animacion.activado = false
            end
        end
    end
end

--RENDERIZAR
function DibujarAnimacion(animacion, x, y, origen_x, origen_y)
    if animacion.activado then
        local i = math.floor(animacion.indice)
        love.graphics.draw(animacion.spritesheet,animacion.quads[i], x, y, 0,1,1, origen_x, origen_y )
    end 
end