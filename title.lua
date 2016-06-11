local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------
-- Code outside of the scene functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------

local titleText
local button

bgAudio = audio.loadSound("04.mp3")
bgAudioChannel = audio.play(bgAudio, { channel = 1, loops = -1 })
audio.setVolume(0.60, { channel = 1 })


local function loadNextScene()
    composer.gotoScene("game", { effect = "fade", time = 1000 })
end

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
        text = "Tap the ball to keep it in the air. Don't let it touch anything.",
        x = _centerX,
        y = _centerY,
        width = (_width - 80),
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    }

    local nextButton = {
        text = "start",
        x = _centerX,
        y = (_height - 10),
        font = native.systemFont,
        fontSize = 20
    }

    titleText = display.newText(mainTitle)
    titleText:setFillColor(0.5)

    directionsText = display.newText(directions)
    directionsText:setFillColor(0.5)

    sceneGroup:insert(titleText)
    sceneGroup:insert(directionsText)

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
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
    end
end


-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
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
