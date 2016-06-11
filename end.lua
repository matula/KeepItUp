local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------
-- Code outside of the scene functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------


local function loadNextScene()
    composer.gotoScene("game", { effect = "fade", time = 1000 })
end

-- -----------------------------------------------------------------------------
-- Scene functions
-- -----------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view
    local mainTitle = {
        text = "Keep It Up",
        x = _centerX,
        y = (_centerY - 100),
        font = native.systemFont,
        fontSize = 50
    }

    local directions = {
        text = "Your Final Count: " .. finalCount,
        x = _centerX,
        y = _centerY,
        width = (_width - 80),
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    }

    local highScoreOpt = {
        text = "Your High Score: " .. highScore,
        x = _centerX,
        y = _centerY + 30,
        width = (_width - 80),
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    }

    local highTimeOpt = {
        text = "Max Time Air Time: " .. highTime,
        x = _centerX,
        y = _centerY + 60,
        width = (_width - 80),
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    }

    titleText = display.newText(mainTitle)
    titleText:setFillColor(0.5)

    directionsText = display.newText(directions)
    directionsText:setFillColor(0.5)

    highScoreText = display.newText(highScoreOpt)
    highScoreText:setFillColor(0.5)

    highTimeText = display.newText(highTimeOpt)
    highTimeText:setFillColor(0.5)

    sceneGroup:insert(titleText)
    sceneGroup:insert(directionsText)
    sceneGroup:insert(highScoreText)
    sceneGroup:insert(highTimeText)

    local nextButton = {
        text = "restart",
        x = _centerX,
        y = (_height - 10),
        font = native.systemFont,
        fontSize = 20
    }

    button = display.newText(nextButton)
    button:setFillColor(0.6, 0, 0)
    button:addEventListener("tap", loadNextScene)
    sceneGroup:insert(button)
end


-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        directionsText.text = "Your Final Count: " .. finalCount
        highScoreText.text = "Your High Score: " .. highScore
        highTimeText.text = "Max Time Air Time: " .. highTime
    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
    end
end


-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        finalCount = 0
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
