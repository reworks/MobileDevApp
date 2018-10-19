local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.
local globals = require("globals")

local regoVerifyScene = composer.newScene()

local verify --orward dec of verification code input variable

local function regoVerifyListener(event)
    if _G.verifyCode == verify then
    	composer.gotoScene("display")
    end
end

-- Event listener for textinput for verification code.
local function verifyTextListener(event)
	if event.phase == "began" then
		-- Nothing right now.
 
    elseif event.phase == "ended" or event.phase == "submitted" then
       _G.verifyCode = event.target.text
 
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        --print( event.startPosition )
       -- print( event.text )
    end
end

function regoVerifyScene:create( event )
    local sceneGroup = self.view

	local verifyBG = display.newImage("verify.png", true)
	sceneGroup:insert(verifyBG)

	verifyBG.x = display.contentCenterX
	verifyBG.y = display.contentCenterY 
end
 
function regoVerifyScene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then

       	verify = math.random(10000, 99999) -- Generate a random verification code between 5 digits long.
		local message = "Hello, " .. _G.userName .. " please input this verification code: " .. verify

		if string.len(_G.phoneNumber) == 10 then
			local sms =
			{
			   to = { _G.phoneNumber },
			   body = message
			}
			native.showPopup("sms", sms)
		else
			print("ERROR: Phone number to short! Must be 10 digits long.")
		end

		local verifyInput = native.newTextField(display.contentCenterX, display.contentCenterY + 50, 270, 56)
		sceneGroup:insert(verifyInput)

		verifyInput.align = "center"
		verifyInput.font = native.newFont(native.systemFont, 16)
		verifyInput.hasBackground = false
		verifyInput.inputType = "number"
		verifyInput.text = "Code..."
		verifyInput:resizeHeightToFitFont()
		verifyInput:addEventListener("userInput", verifyTextListener)

		local verifyButton = widget.newButton(
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
			onEvent = regoVerifyListener
		})

		sceneGroup:insert(verifyButton)
    end
end
 
function regoVerifyScene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        -- hide ui here?
    end
end
 
function regoVerifyScene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
regoVerifyScene:addEventListener( "create", regoVerifyScene )
regoVerifyScene:addEventListener( "show", regoVerifyScene )
regoVerifyScene:addEventListener( "hide", regoVerifyScene )
regoVerifyScene:addEventListener( "destroy", regoVerifyScene )
 
return regoVerifyScene