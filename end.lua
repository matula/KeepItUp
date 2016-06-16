local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local fontFile = "Futura-Medium.ttf"

-- -----------------------------------------------------------------------------
-- Code outside of the scene functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------

local function loadNextScene()
    print('back to game')
    composer.gotoScene("game", { effect = "fade", time = 800 })
end

local function onShareButtonReleased(event)
    local serviceName = event.target.id
    local isAvailable = native.canShowPopup("social", serviceName)

    -- If it is possible to show the popup
    if isAvailable then
        local listener = {}
        function listener:popup(event)
            print("name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")")
        end

        -- Show the popup
        native.showPopup("social",
            {
                service = serviceName, -- The service key is ignored on Android.
                message = "I scored " .. finalCount .. " on Keep It Up! Beat that!!!",
                listener = listener,
                url =
                {
                    "http://www.matu.la/keep-it-up/",
                }
            })
    else
        -- Popup isn't available.. Show error message
        native.showAlert("Cannot send " .. serviceName .. " message.", "Please setup your " .. serviceName .. " account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" })
    end
end

-- -----------------------------------------------------------------------------
-- Scene functions
-- -----------------------------------------------------------------------------

-- create()
function scene:create(event)
    print('start create end scene')
    local sceneGroup = self.view
    print('start create end scene group')

    local mainTitle = {
        text = "Keep It Up",
        x = _centerX,
        y = (_centerY - 100),
        font = fontFile,
        fontSize = 56
    }

    local directions = {
        text = "Your Final Count: " .. finalCount,
        x = _centerX,
        y = _centerY,
        width = (_width - 80),
        font = fontFile,
        fontSize = 20,
        align = "center"
    }

    local highScoreOpt = {
        text = "Your High Score: " .. highScore,
        x = _centerX,
        y = _centerY + 30,
        width = (_width - 80),
        font = fontFile,
        fontSize = 20,
        align = "center"
    }

    local highTimeOpt = {
        text = "Max Air Time: " .. highTime,
        x = _centerX,
        y = _centerY + 60,
        width = (_width - 80),
        font = fontFile,
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
    print(' end scene texts')

    local button = widget.newButton({
        label = "restart",
        onRelease = loadNextScene,
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

    local shareButton = widget.newButton {
        id = "share",
        width = 140,
        height = 36,
        label = "share your score",
        onRelease = onShareButtonReleased,
        shape = "roundedRect",
        cornerRadius = 5,
        labelColor = { default = { 1, 1, 1 }, over = { 0.7, 0.7, 0.7 } },
        fillColor = { default = { 0.2, 0.2, 0.9, .6 }, over = { .2, 0.2, 0.9, .9 } },
        font = fontFile,
        fontSize = 16
    }
    shareButton.x = _centerX
    shareButton.y = (_height - 100)

    print('end scene widget')

    sceneGroup:insert(titleText)
    sceneGroup:insert(directionsText)
    sceneGroup:insert(highScoreText)
    sceneGroup:insert(highTimeText)
    sceneGroup:insert(button)
    sceneGroup:insert(shareButton)

    print('end scene added group')
end


-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase
    print('end scene SHOW')
    if (phase == "will") then
        print('end scene show WILL')
        directionsText.text = "Your Final Count: " .. finalCount
        highScoreText.text = "Your High Score: " .. highScore
        highTimeText.text = "Max Air Time: " .. highTime
    elseif (phase == "did") then
        print('end scene show DID')
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
