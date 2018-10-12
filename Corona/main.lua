local library = require "plugin.library"
-- Mobile Development Assignment 2 - "Monitoring App"

local widget = require("widget") -- Used to import UI Widgets.

local username -- Name of the user of the app.
local phoneNumber -- Phone number of the user.

-- This is the listener for the registration input for name.
local function usernameTextListener(event)
	if event.phase == "began" then
		-- Nothing right now.
 
    elseif event.phase == "ended" or event.phase == "submitted" then
       -- username = event.target.text
 
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        --print( event.startPosition )
       -- print( event.text )
    end
end

-- Event listener for textinput for phone number.
local function phoneTextListener(event)
	if ( event.phase == "began" ) then
		-- User is now editing phone number.
    end
end

-- Event listener for textinput for verification code.
local function verifyTextListener(event)
	if ( event.phase == "began" ) then
		-- User is now entering verification code.
    end
end

-- This function checks for an existing registration, and if it does not find it, prompts user to register.
-- Returns 0 if failed, otherwise returns phone number that is registered.
local function checkForRego()
	local file, error = io.open(system.pathForFile("reg.txt", system.DocumentsDirectory))

	if not file then
		return 0
	else
		local number = file:read(10)
		io.close(file)
		return number
	end
end

-- temp, for debugging
local function temp(verify)
	print(verify)
end

-- Sets user name and phone number then verifies that the user is who they say they are.
local function verifyRego(usernameInput, phoneInput)
	username = usernameInput.text
	phoneNumber = phoneInput.text

	-- temp, for debugging
	print(username)
	print(phoneNumber)

	local verify = math.random(10000, 99999) -- Generate a random verification code between 5 digits long.
	local message = "Hello, " .. username .. " please input this verification code: " .. verify

	if string.len(phoneNumber) == 10 then
		local sms =
		{
		   to = { phoneNumber },
		   body = message
		}
		native.showPopup("sms", sms)
	else
		print("ERROR: Phone number to short! Must be 10 digits long.")
	end

	-- then we need to check the verification code
	-- then if its correct send to main screen, otherwise tell user wrong verification code.
	local verifyBG = display.newImage("verify.png", true)
	verifyBG.x = display.contentCenterX
	verifyBG.y = display.contentCenterY

	local verifyInput = native.newTextField(display.contentCenterX, display.contentCenterY + 50, 270, 56)
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
		onRelease = temp(verifyInput.text)
	})

end

-- Displays the app screen that handles registration input.
local function displayRegoInput()
	local inputBG = display.newImage("input.png", true)
	inputBG.x = display.contentCenterX
	inputBG.y = display.contentCenterY

	local usernameInput = native.newTextField(display.contentCenterX, display.contentCenterY + 50, 217, 56)
	local phoneInput = native.newTextField(display.contentCenterX, display.contentCenterY + 100, 217, 56)

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

	local confirmReg = widget.newButton(
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
		onRelease = verifyRego(usernameInput, phoneInput)
	})
end

-- Start up screen if user is not registered, prompting them to register.
local function displayRego()
	local regoBG = display.newImage("register.png", true)
	regoBG.x = display.contentCenterX
	regoBG.y = display.contentCenterY

	local regButton = widget.newButton(
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
		onRelease = displayRegoInput
	})
end

-- Function manages the display of the main menu.
local function displayMenu()
end

-- App start function. Sets up app.
local function main()
	display.setStatusBar(display.HiddenStatusBar)
	math.randomseed(os.time())

	phoneNumber = checkForRego()

	if phoneNumber == 0 then
		displayRego()
	else
		displayMenu()
	end
end

-- Run the app
main()