local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

local titleText
local button
local fontFile = "Futura-Medium.ttf"

bgAudio = audio.loadSound("04.mp3")
gAudioChannel = audio.play(bgAudio, { channel = 1, loops = -1 })
audio.setVolume(0.00, { channel = 1 })

local function loadNextScene()
    composer.gotoScene("game", { effect = "fade", time = 800 })
end

-- create()
function scene:create(event)

    local sceneGroup = self.view

    local mainTitle = {
        text = "Keep It Up",
        x = _centerX,
        y = (_centerY - 100),
        font = fontFile,
        fontSize = 56
    }

    local directions = {
        text = "Tap the ball to keep it in the air. Watch out for enemies!",
        x = _centerX,
        y = _centerY,
        width = (_width - 80),
        font = fontFile,
        fontSize = 20,
        align = "center"
    }

    titleText = display.newText(mainTitle)
    titleText:setFillColor(0.5)

    directionsText = display.newText(directions)
    directionsText:setFillColor(0.5)

    sceneGroup:insert(titleText)
    sceneGroup:insert(directionsText)

    local button = widget.newButton({
        label = "start",
        onEvent = loadNextScene,
        shape = "roundedRect",
        width = 140,
        height = 40,
        cornerRadius = 5,
        labelColor = { default = { 1, 1, 1 }, over = { 0.7, 0.7, 0.7 } },
        fillColor = { default = { .8, 0, 0, .6 }, over = { .6, 0, 0, .7 } },
        font = fontFile,
        fontSize = 20
    })

    button.x = _centerX
    button.y = (_height - 40)

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
