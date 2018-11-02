local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.
local globals = require("globals")

local regoInputScene = composer.newScene()

local function timerListener()
	-- makes sure the phone number is valid.
    if string.len(_G.phoneNumber) >= 10 then
        composer.gotoScene("regoVerify")
    else
        local errorText = display.newText("Invalid phone number!", display.contentCenterX, display.contentCenterY - 210, native.systemFont, 18)
        errorText:setFillColor(1, 0, 0)
    end
end

local function buttonEventInputListener(event)
   -- _G.phoneNumber = phoneInput.text
   -- _G.userName = usernameInput.text
    timer.performWithDelay(50, timerListener)
end

-- This is the listener for the registration input for name.
local function usernameTextListener(event)
	if event.phase == "began" then
 
    elseif event.phase == "ended" or event.phase == "submitted" then
    	-- sets username for use during rego
       _G.userName = event.target.text
 
    elseif ( event.phase == "editing" ) then

    end
end

-- Event listener for textinput for phone number.
local function phoneTextListener(event)
	if event.phase == "began" then
 	-- sets phone number for use.
    elseif event.phase == "ended" or event.phase == "submitted" then
       _G.phoneNumber = event.target.text
 
    elseif ( event.phase == "editing" ) then
    end
end

function regoInputScene:create( event )
    local sceneGroup = self.view

    -- create background image
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
        -- set up text input fields for username and phone number
        local usernameInput = native.newTextField(display.contentCenterX + 50, display.contentCenterY + 5, 217, 56)
        local phoneInput = native.newTextField(display.contentCenterX + 50, display.contentCenterY + 90, 217, 56)
        sceneGroup:insert(usernameInput)
        sceneGroup:insert(phoneInput)

        usernameInput.align = "center"
        usernameInput.font = native.newFont(native.systemFont, 18)
        usernameInput.hasBackground = false
        usernameInput.inputType = "no-emoji" --Default keyboard that filters out emojis.
        usernameInput.text = ""
        usernameInput:resizeHeightToFitFont()
        usernameInput:addEventListener("userInput", usernameTextListener)

        phoneInput.align = "center"
        phoneInput.font = native.newFont(native.systemFont, 18)
        phoneInput.hasBackground = false
        phoneInput.inputType = "phone"
        phoneInput.text = ""
        phoneInput:resizeHeightToFitFont()
        phoneInput:addEventListener("userInput", phoneTextListener)

        -- proceed to verification code.
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
    end
end
 
function regoInputScene:destroy( event ) 
    local sceneGroup = self.view
end
 
regoInputScene:addEventListener( "create", regoInputScene )
regoInputScene:addEventListener( "show", regoInputScene )
regoInputScene:addEventListener( "hide", regoInputScene )
regoInputScene:addEventListener( "destroy", regoInputScene )
 
return regoInputScene