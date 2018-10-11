local library = require "plugin.library"

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


-- Hide the device status bar.
display.setStatusBar(display.HiddenStatusBar)

-- Display the background image.
local background = display.newImage("paper_bkg.png", true)
background.x = display.contentCenterX
background.y = display.contentCenterY