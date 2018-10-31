-- Start up screen if user is not registered, prompting them to register.

local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.

local monitorScene = composer.newScene()

local function timerListener()
	composer.gotoScene("homes")
end

local function buttonListener(event)
	timer.performWithDelay(50, timerListener)
end

function monitorScene:create( event )
    local sceneGroup = self.view

    local bg = display.newImage("monitor.png", true)
	sceneGroup:insert(bg)

	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
end
 
function monitorScene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
       local regoButton = widget.newButton(
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
			onEvent = buttonListener
		})
		sceneGroup:insert(regoButton)
    end
end
 
function monitorScene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
    end
end
 
function monitorScene:destroy( event )
    local sceneGroup = self.view
end
 
monitorScene:addEventListener( "create", monitorScene )
monitorScene:addEventListener( "show", monitorScene )
monitorScene:addEventListener( "hide", monitorScene )
monitorScene:addEventListener( "destroy", monitorScene )
 
return monitorScene