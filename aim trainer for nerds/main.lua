--[[ 

made by AceCade for fun & to learn love2d
this is my very first project, so don't hesitate to let me know if you have any suggestions!
please credit me if you share this

discord: AceCade#5223
email: contact@acecade.xyz
github: https://github.com/AceCade/Lua/blob/main/aim%20trainer%20for%20nerds/main.lua

]]

function love.load() -- runs on startup

    version = 0.1

    love.window.setTitle("aim trainer for nerds v"..version)
    love.window.setFullscreen(true)

    smallFont = love.graphics.newFont("assets/font.otf", 20)
    normalFont = love.graphics.newFont("assets/font.otf", 40)
    largeFont = love.graphics.newFont("assets/font.otf", 100)

    target = {
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        radius = 50
    }
    score = 0
    startTime = 0
    accuracy = {
        hit = 0,
        miss = 0
    }
    started = false
end

function love.update(dt) -- runs every frame

end

function love.draw() -- draws graphics

    love.graphics.setBackgroundColor(0.15,0.15,0.15)

    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.setFont(largeFont)
    love.graphics.print(score, love.graphics.getWidth()/2-50, 0)

    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.setFont(smallFont)
    love.graphics.print("PRESS ENTER TO EXIT FULLSCREEN\nPRESS ESC TO QUIT", 5, 2)

    love.graphics.setColor(0.8,0,0)
    love.graphics.circle("fill", target.x, target.y, target.radius)

end

function love.mousepressed(x, y, button)
    if button == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            if started == false then started = true moveTarget() return end
            score = score + 1
            accuracy.hit = accuracy.hit + 1
            moveTarget()
        elseif started then
            accuracy.miss = accuracy.miss + 1
        end
    end
end

function moveTarget()
    target.x = math.random(target.radius, love.graphics.getWidth()-target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight()-target.radius)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function love.focus(focus)
    if not focus then -- quits program when user clicks away from window
        love.event.quit()
    end
end

function love.keypressed(key) 
    if key == "escape" then -- quits program when user presses ESC key
        love.event.quit()
    end
    if key == "return" then -- toggles fullscreen when ENTER key is pressed
        if love.window.getFullscreen() then
            love.window.setFullscreen(false)
            love.window.maximize()
        else
            love.window.setFullscreen(true)
        end
    end
end
