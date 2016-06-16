local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start()

local platform, topborder
local enemies = {}
local ball
local popAudio
local upTimeTimer
local mainTimer
local mainTime = 0
local tapCount = 0
local tapText
local counter = 0
local upTime
finalCount = 0
highScore = 0
highTime = 0

-- -----------------------------------------------------------------------------
-- Scene functions
-- -----------------------------------------------------------------------------
local function resetCount()
    tapText.text = 0
    tapCount = 0
end

local function upTimeCounter()
    counter = counter + 1
    upTime.text = counter
end

local function spawnEnemy(params)
    local mySize = 20
    local enemy = display.newRect(-30, _centerY, 20, 20)
    -- print('enemy spawned')
    enemy:setFillColor(0.4, 0.4, 0.4)
    enemy.anchorX = 0.5
    enemy.anchorY = 0.5
    enemy.rotation = params.rotation or 45
    enemy.x = params.x or -30
    enemy.maxY = (_height - 50)
    enemy.minY = 30
    enemy.y = params.y or math.random(enemy.minY, enemy.maxY)
    enemy.initY = enemy.y
    enemy.width = params.width or mySize
    enemy.height = params.height or mySize
    enemy.minSpeed = params.minSpeed or 1
    enemy.maxSpeed = params.maxSpeed or 3
    enemy.speed = math.random(enemy.minSpeed, enemy.maxSpeed)
    enemy.minAmp = params.minAmp or 5
    enemy.maxAmp = params.maxAmp or 50
    enemy.amp = math.random(enemy.minAmp, enemy.maxAmp)
    enemy.minAngle = params.minAngle or 1
    enemy.maxAngle = params.maxAngle or 360
    enemy.angle = math.random(enemy.minAngle, enemy.maxAngle)
    enemy.myName = "enemy"
    physics.addBody(enemy, "static", { radius = mySize })
    return enemy
end

local function moveEnemyToRight(self, event)
    if (self.x >= (_width + 50)) then
        print('reset to right')
        self.x = -50
        self.y = math.random(self.minY, self.maxY)
        self.initY = self.y
        self.angle = math.random(self.minAngle, self.maxAngle)
        self.speed = math.random(self.minSpeed, self.maxSpeed)
        self.amp = math.random(self.minAmp, self.maxAmp)
    else
        self.x = self.x + self.speed
        self.angle = self.angle + .1
        self.y = self.initY + math.sin(self.angle) * self.amp
    end
end

local function moveEnemyToLeft(self, event)

    if (self.x <= -50) then
        print('reset to left')
        self.x = (_width + 50)
        self.y = math.random(self.minY, self.maxY)
        self.initY = self.y
        self.angle = math.random(self.minAngle, self.maxAngle)
        self.speed = math.random(self.minSpeed, self.maxSpeed)
        self.amp = math.random(self.minAmp, self.maxAmp)
    else
        self.x = self.x - self.speed
        self.angle = self.angle + .1
        self.y = self.initY + math.sin(self.angle) * self.amp
    end
end

local function movePlatform(self, event)
    self.angle = self.angle + .1
    self.y = self.initY + math.sin(self.angle) * 40
end

local function mainCounter()
    mainTime = mainTime + 1
    if (mainTime == 10) then
        enemies[1] = spawnEnemy({ y = _centerY })
        enemies[1].enterFrame = moveEnemyToRight
        Runtime:addEventListener("enterFrame", enemies[1])
    end

    if (mainTime == 20) then
        enemies[2] = spawnEnemy({})
        enemies[2].enterFrame = moveEnemyToLeft
        Runtime:addEventListener("enterFrame", enemies[2])
    end

    if (mainTime == 30) then
        enemies[3] = spawnEnemy({})
        enemies[3].enterFrame = moveEnemyToLeft
        Runtime:addEventListener("enterFrame", enemies[3])
    end

    if (mainTime == 40) then
        enemies[4] = spawnEnemy({})
        enemies[4].enterFrame = moveEnemyToRight
        Runtime:addEventListener("enterFrame", enemies[4])
    end

    if (mainTime == 50) then
        enemies[5] = spawnEnemy({})
        enemies[5].enterFrame = moveEnemyToRight
        Runtime:addEventListener("enterFrame", enemies[5])
    end

    if (mainTime == 45) then
        platform.enterFrame = movePlatform
        Runtime:addEventListener("enterFrame", platform)
    end
end

local function pushBall(event)
    print('screen tapped')
    print('start pop')
    audio.play(popAudio, { channel = 3, loops = 0 })
    print('end pop')

    if upTimeTimer then
        if (counter > highTime) then
            highTime = counter
        end
        timer.cancel(upTimeTimer)
    end

    counter = 0
    ball:applyLinearImpulse(0, -0.75, ball.x, ball.y)
    print('pre tap count:' .. tapCount)
    tapCount = tapCount + 1
    print('post tap count:'  .. tapCount)
    tapText.text = tapCount
    upTimeTimer = timer.performWithDelay(10, upTimeCounter, 0)
end

local function goToEndScene()
    if (tapCount > 0) then
        Runtime:removeEventListener("tap", pushBall)
        for enemyKey, enemyValue in pairs(enemies) do
            Runtime:removeEventListener("enterFrame", enemies[enemyKey])
            enemies[enemyKey]:removeSelf()
            enemies[enemyKey] = nil
        end

        finalCount = tapCount
        if (finalCount > highScore) then
            highScore = finalCount
        end

        if (mainTime > 0) then
            timer.cancel(mainTimer)
            mainTime = 0
        end

        resetCount()

        composer.gotoScene("end", { effect = "fade", time = 800 })
    end
end


local function onCollision(self, event)
    if (event.phase == "began") then
        if (event.other.myName == "enemy") then
            transition.fadeOut(ball, { time = 500 })
            transition.scaleTo(ball, { xScale = 2, yScale = 2, time = 800 })
            goToEndScene()
        end

        if (event.other.myName == "platform") then
            goToEndScene()
        end

        if not (event.other.myName == "topborder") then
            -- stop the counter
            if upTimeTimer then
                timer.cancel(upTimeTimer)
            end
            -- stop main timer

            counter = 0
            upTime.text = 0
        end
    end
end

-- create()
function scene:create(event)

    local sceneGroup = self.view
    Runtime:removeEventListener("tap", pushBall)

    platform = display.newRect(_centerX, (_height - 30), _width, 10)
    platform:setFillColor(0.3, 0.4, 0.7)
    platform.myName = "platform"
    platform.initY = platform.y
    platform.angle = 30

    topborder = display.newRect(_centerX, -10, (_width + 100), 10)
    topborder:setFillColor(0.9, 0.9, 0.9)
    topborder.myName = "topborder"

    ball = display.newCircle(_centerX, _centerY, 50)
    ball:setFillColor(0.9, 0.2, 0.2)
    ball.alpha = 0.8

    popAudio = audio.loadSound("pop.mp3")

    physics.addBody(platform, "static")
    physics.addBody(topborder, "static", { bounce = 0.0 })

    tapText = display.newText(tapCount, (_width - 24), 40, native.systemFont, 40)
    tapText:setFillColor(0.8)

    upTime = display.newText(counter, 10, 40, native.systemFont, 40)
    upTime.anchorX = 0
    upTime:setFillColor(0.8)

    sceneGroup:insert(platform)
    sceneGroup:insert(topborder)
    sceneGroup:insert(ball)
    sceneGroup:insert(tapText)
    sceneGroup:insert(upTime)
end


-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if ball.setLinearVelocity and type(ball.setLinearVelocity) == "function" then
            physics.removeBody(ball)
        end

        Runtime:removeEventListener("tap", pushBall)

        ball.x = _centerX
        ball.y = _height - 70
        ball.xScale = 1
        ball.yScale = 1
        ball.alpha = 0.8
        physics.addBody(ball, "dynamic", { radius = 50, bounce = 0.5 })
        finalCount = 0
    elseif (phase == "did") then
        if (mainTime == 0) then
            mainTimer = timer.performWithDelay(1000, mainCounter, 0)
        end

        Runtime:addEventListener("tap", pushBall)
        -- ball:addEventListener("tap", pushBall)
        ball.collision = onCollision
        ball:addEventListener("collision", ball)
    end
end


-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase
    Runtime:removeEventListener("tap", pushBall)

    if (phase == "will") then
        ball:removeEventListener("collision", ball)
        Runtime:removeEventListener("enterFrame", platform)

    elseif (phase == "did") then
    end
end


-- destroy()
function scene:destroy(event)

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end


-- -----------------------------------------------------------------------------
-- Scene function listeners
-- -----------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)



-- -----------------------------------------------------------------------------

return scene
