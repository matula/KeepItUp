local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics")
physics.start()

local platform
local ball
local popAudio
local upTimeTimer = nil
local tapCount = 0
local tapText
local counter = 0
local upTime
finalCount = 0
highScore = 0

-- -----------------------------------------------------------------------------
-- Scene functions
-- -----------------------------------------------------------------------------
local function resetCount()
    tapText.text = 0
    tapCount = 0
end

local function pushBall()
    audio.play(popAudio,{channel=2, loops=0})

    if upTimeTimer then
      timer.cancel(upTimeTimer)
    end
    counter = 0
    ball:applyLinearImpulse(0,-0.75, ball.x, ball.y)
    tapCount = tapCount + 1
    tapText.text = tapCount
    -- upTimeTimer = timer.performWithDelay(10, upTimeCounter, 0)
end

local function onPlatformCollision (self, event)
  if(event.phase == "began") then
     if(event.other.myName == "platform") then
       if (tapCount > 0) then
           finalCount = tapCount
           if (finalCount > highScore) then
             highScore = finalCount
           end

           resetCount()
            composer.gotoScene("end", {effect = "fade", time=1000})
        end
        -- stop the counter
        if upTimeTimer then
          -- timer.cancel(upTimeTimer)
        end
        -- counter = 0
        -- upTime.text = 0
     end
  end
end

local function upTimeCounter()
  counter = counter + 1
  upTime.text = counter
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    platform = display.newRect(_centerX,(_height - 10),_width,10)

    platform:setFillColor(0.3,0.3,0.6)
    platform.myName = "platform"

    ball = display.newCircle(100, 100, 50)
    ball.x = _centerX
    ball.y = _centerY
    ball:setFillColor(0.9,0.2,0.2)

    ball.alpha = 0.8

    popAudio = audio.loadSound("pop.wav")

    physics.addBody( platform, "static")
    physics.addBody( ball, "dynamic", {radius=50, bounce=0.5} )

    tapText = display.newText( tapCount, (_width - 24), 20, native.systemFont, 40 )
    tapText:setFillColor(0.8)

    upTime = display.newText( counter, 10, 20, native.systemFont, 40 )
    upTime.anchorX = 0
    upTime:setFillColor(1)

    sceneGroup:insert(platform)
    sceneGroup:insert(ball)
    sceneGroup:insert(tapText)
    sceneGroup:insert(upTime)

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        ball.y = _centerY - 20
        finalCount = 0
    elseif ( phase == "did" ) then
      ball:addEventListener("tap", pushBall)
      ball.collision = onPlatformCollision
      ball:addEventListener("collision", ball)
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      ball:removeEventListener("tap", pushBall)
      ball:removeEventListener("collision", ball)
    elseif ( phase == "did" ) then
    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------
-- Scene function listeners
-- -----------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-- -----------------------------------------------------------------------------

return scene
