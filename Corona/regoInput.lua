local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.
local globals = require("globals")

local regoInputScene = composer.newScene()

local function timerListener()
    composer.gotoScene("regoVerify")
end

local function buttonEventInputListener(event)
   -- _G.phoneNumber = phoneInput.text
   -- _G.userName = usernameInput.text
    timer.performWithDelay(50, timerListener)
end

-- This is the listener for the registration input for name.
local function usernameTextListener(event)
	if event.phase == "began" then
		-- Nothing right now.
 
    elseif event.phase == "ended" or event.phase == "submitted" then
       _G.userName = event.target.text
 
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        --print( event.startPosition )
       -- print( event.text )
    end
end

-- Event listener for textinput for phone number.
local function phoneTextListener(event)
	if event.phase == "began" then
        -- Nothing right now.
 
    elseif event.phase == "ended" or event.phase == "submitted" then
       _G.phoneNumber = event.target.text
 
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        --print( event.startPosition )
       -- print( event.text )
    end
end

function regoInputScene:create( event )
    local sceneGroup = self.view

    local bg = display.newImage("input.png", true)
    sceneGroup:insert(bg)

    bg.x = display.contentCenterX
    bg.y = display.contentCenterY
end
 
 function regoInputScene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        local usernameInput = native.newTextField(display.contentCenterX, display.contentCenterY + 50, 217, 56)
        local phoneInput = native.newTextField(display.contentCenterX, display.contentCenterY + 100, 217, 56)
        sceneGroup:insert(usernameInput)
        sceneGroup:insert(phoneInput)

        usernameInput.align = "center"
        usernameInput.font = native.newFont(native.systemFont, 16)
        usernameInput.hasBackground = false
        usernameInput.inputType = "no-emoji" --Default keyboard that filters out emojis.
        usernameInput.text = "UN..."
        usernameInput:resizeHeightToFitFont()
        usernameInput:addEventListener("userInput", usernameTextListener)

        phoneInput.align = "center"
        phoneInput.font = native.newFont(native.systemFont, 16)
        phoneInput.hasBackground = false
        phoneInput.inputType = "phone"
        phoneInput.text = "#..."
        phoneInput:resizeHeightToFitFont()
        phoneInput:addEventListener("userInput", phoneTextListener)

        local newRegoButton = widget.newButton(
        {
            x = display.contentCenterX,
            y = display.contentCenterY + 247,
            shape = "rect",
            fillColor = 
            {   
                default = 
                {
                    0.0, 0.0, 0.0, 0.1
                },
                over = 
                {
                    0.0, 0.0, 1.0, 0.3
                }
            },
            width = 315,
            height = 51,
            isEnabled = true,
            onEvent = buttonEventInputListener
        })
        sceneGroup:insert(newRegoButton)

    end
end
 
function regoInputScene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        -- hide ui here?
    end
end
 
function regoInputScene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
regoInputScene:addEventListener( "create", regoInputScene )
regoInputScene:addEventListener( "show", regoInputScene )
regoInputScene:addEventListener( "hide", regoInputScene )
regoInputScene:addEventListener( "destroy", regoInputScene )
 
return regoInputScene