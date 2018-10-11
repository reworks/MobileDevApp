local library = require "plugin.library"

-- Android native stuff

-- This event is dispatched to the global Runtime object
-- by `didLoadMain:` in MyCoronaDelegate.mm
local function delegateListener( event )
	native.showAlert(
		"Event dispatched from `didLoadMain:`",
		"of type: " .. tostring( event.name ),
		{ "OK" } )
end
Runtime:addEventListener( "delegate", delegateListener )

-- This event is dispatched to the following Lua function
-- by PluginLibrary::show() in PluginLibrary.mm
local function listener( event )
	print( "Received event from Library plugin (" .. event.name .. "): ", event.message )
end

library.init( listener )

timer.performWithDelay( 1000, function()
	library.show( "corona" )
end )

-- App stuff
local widget = require("widget")

-- App stuff
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

local function displayMenu()
end

local function displayRegoInput()
	display.newText({text = "Hello!", x = display.contentCenterX,
	y = display.contentCenterY, font = native.systemFont, fontSize = 16})
end

local function displayRego()
	local background = display.newImage("register.png", true)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local regButton = widget.newButton(
	{
		x = display.contentCenterX,
		y = display.contentCenterY + 247,
		shape = "rect",
		fillColor = 
		{	
			default = 
			{
				1.0, 0.0, 0.0, 1.0
			},
			over = 
			{
				0.0, 0.0, 1.0, 0.2
			}
		},
		width = 315,
		height = 51,
		isEnabled = true,
		onRelease = displayRegoInput
	})
end

local function main()
	display.setStatusBar( display.HiddenStatusBar )
	
	local number = checkForRego()

	if number == 0 then
		displayRego()
	else
		displayMenu()
	end
end

main()