-- Mobile Development Assignment 2 - "Monitoring App"

local composer = require("composer") -- Used to move through scenes.

-- This function checks for an existing registration, and if it does not find it, prompts user to register.
-- Returns 0 if failed, otherwise returns phone number that is registered.
local function checkForRego()
	local file, error = io.open(system.pathForFile("reg.txt", system.DocumentsDirectory), "r")

	-- if the number is 10 long then return it after closing file.
	if not file then
		return 0
	else
		local number = file:read(10)
		io.close(file)
		return number
	end
end

-- App start function. Sets up app.
local function main()
	-- Ensures UI is recycled when a scene is changed, to prevent it showing up in other scenes.
	composer.recycleOnSceneChange = true
	display.setStatusBar(display.HiddenStatusBar) -- Keeps status bar hidden, ensuring app is fullscreen and nothing gets covered up.
	math.randomseed(os.time()) -- makes sure our verification code is properly randomized.

	local num = checkForRego() -- See above function

	-- If the number is 0 then there is no phone number existing so we have to goto the rego scene, other wise, i.e. on a subsequent launch, we go to the home menu.
	if num == 0 then
		composer.gotoScene("rego")
	else
		_G.phoneNumber = num
		composer.gotoScene("home")
	end
end

-- Run the app
main()