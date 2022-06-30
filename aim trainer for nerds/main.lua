--[[ 

made by AceCade for fun & to learn love2d
this is my very first project, so don't hesitate to let me know if you have any suggestions!
please credit me if you share this

discord: AceCade#5223
email: contact@acecade.xyz
github: https://github.com/AceCade/Lua/blob/main/aim%20trainer%20for%20nerds/main.lua

]]

function love.load() -- runs on startup

    version = 0.2

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
    highscore = 0
    startTime = os.time()
    accuracy = {
        hit = 0,
        miss = 0
    }
    started = false

    message = ""
    waiting = false
    waitingtimer = 0

    local info = love.filesystem.getInfo("data.txt")

    function createDir()
        if love.filesystem.getInfo("aim_trainer_for_nerds") == nil then
            local success, response = love.filesystem.createDirectory("aim_trainer_for_nerds")
            if not success then message = "failed to create save file", response waiting = true return else love.filesystem.setIdentity("aim_trainer_for_nerds") end
        end
        if love.filesystem.getInfo("data.txt") == nil then
            love.filesystem.newFile("data.txt")
        end
        message = "created save file"
        waiting = true
    end

    if info ~= nil then
        local content = love.filesystem.read("data.txt")
        if content ~= nil then
            highscore = tonumber(content)
            message = "loaded game save"
            waiting = true
        else
            createDir()
        end
    else
        createDir()
    end
end

function love.update(dt) -- runs every frame
    if waiting then waitingtimer = waitingtimer + dt end
    if waitingtimer > 5 then
        waiting = false
        message = ""
    end
end

function love.draw() -- draws graphics

    love.graphics.setBackgroundColor(0.15,0.15,0.15)

    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.setFont(largeFont)
    love.graphics.print(score, love.graphics.getWidth()/2-(string.len(score)*20), 0)

    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.setFont(normalFont)
    love.graphics.print(highscore, love.graphics.getWidth()/2-(string.len(highscore)*5), 90)

    local acc = math.ceil((accuracy.hit / accuracy.miss) * 100)
    if acc > 100 then acc = 100 end
    love.graphics.print(acc, love.graphics.getWidth()-string.len(tostring(acc))*35, 10)

    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.setFont(smallFont)
    love.graphics.print("PRESS ENTER TO EXIT FULLSCREEN\nPRESS ESC TO QUIT", 5, 2)

    love.graphics.print(message, love.graphics.getWidth()/2-(string.len(message)*5), love.graphics.getHeight()-50)

    love.graphics.setColor(0.8,0,0)
    love.graphics.circle("fill", target.x, target.y, target.radius)

end

function love.mousepressed(x, y, button)
    if button == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            if started == false then started = true moveTarget() return end
            score = score + 1
            if score > highscore then highscore = score end
            accuracy.hit = accuracy.hit + 1
            moveTarget()
            local success, response = love.filesystem.write("data.txt",highscore)
            if not success then message = "failed to save", response end
            waiting = true
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

--[[
function love.focus(focus)
    if not focus then -- quits program when user clicks away from window
        love.event.quit()
    end
end
]]

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
