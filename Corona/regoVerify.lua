local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.
local globals = require("globals")

local regoVerifyScene = composer.newScene()

local verify --forward dec of verification code input variable

local function regoVerifyListener(event)
	
	-- temp
	print("code:" .. _G.verifyCode)
	print("to check: " .. verify)


	-- if verification code is correct then save file and move on if not print error message...
    if tonumber(_G.verifyCode) == tonumber(verify) then
    	local file, error = io.open(system.pathForFile("reg.txt", system.DocumentsDirectory), "w")

    	file:write(_G.phoneNumber)
    	io.close(file)

    	composer.gotoScene("home")
    else
		local errorText = display.newText("Wrong verification code, " .. _G.userName, display.contentCenterX, display.contentCenterY - 210, native.systemFont, 18)
		errorText:setFillColor(1, 0, 0)
    end
end

-- Event listener for textinput for verification code.
local function verifyTextListener(event)
	if event.phase == "began" then
    elseif event.phase == "ended" or event.phase == "submitted" then
       _G.verifyCode = event.target.text
 
    elseif ( event.phase == "editing" ) then
    end
end

function regoVerifyScene:create( event )
    local sceneGroup = self.view

    -- create background image
	local verifyBG = display.newImage("verify.png", true)
	sceneGroup:insert(verifyBG)

	verifyBG.x = display.contentCenterX
	verifyBG.y = display.contentCenterY 

	-- generate a 5 digit verification code randomly.
    verify = math.random(10000, 99999) -- Generate a random verification code between 5 digits long.
end
 
function regoVerifyScene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then

		local message = "Hello, " .. _G.userName .. " please input this verification code: " .. verify
		-- then send SMS. This should *theoretically* work according to corona docs and forums, etc, but doesn't appear to.
		if string.len(_G.phoneNumber) == 10 then
			androidUtils.SendSMS(tostring(_G.phoneNumber), message)
		else
			print("ERROR: Phone number to short! Must be 10 digits long.")
		end

		-- text input field for verification
		local verifyInput = native.newTextField(display.contentCenterX - 10, display.contentCenterY + 125, 270, 56)
		sceneGroup:insert(verifyInput)

		verifyInput.align = "center"
		verifyInput.font = native.newFont(native.systemFont, 16)
		verifyInput.hasBackground = false
		verifyInput.inputType = "number"
		verifyInput.text = ""
		verifyInput:resizeHeightToFitFont()
		verifyInput:addEventListener("userInput", verifyTextListener)

		-- button to submit verification.
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
    end
end
 
function regoVerifyScene:destroy( event )
    local sceneGroup = self.view
end
 
regoVerifyScene:addEventListener( "create", regoVerifyScene )
regoVerifyScene:addEventListener( "show", regoVerifyScene )
regoVerifyScene:addEventListener( "hide", regoVerifyScene )
regoVerifyScene:addEventListener( "destroy", regoVerifyScene )
 
return regoVerifyScene