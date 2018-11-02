-- Start up screen if user is not registered, prompting them to register.

local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to create the scene.

local monitorScene = composer.newScene()

local offCameraText = nil
local onCameraText = nil
local offMicText = nil
local onMicText = nil

local function backBtnListener(event)
	composer.gotoScene("home")
end

local function CameraBtnListener(event)
	if offCameraText ~= nil then 
    	offCameraText:removeSelf()
    	offCameraText = nil
    end
	
	if offMicText ~= nil then 
    	offMicText:removeSelf()
    	offMicText = nil
    end

    if onCameraText ~= nil then 
    	onCameraText:removeSelf()
    	onCameraText = nil
    end

    if onMicText ~= nil then 
    	onMicText:removeSelf()
    	onMicText = nil
    end	

    local cameraInUse = androidUtils.checkCamera()
	if cameraInUse == 1 then
		onCameraText = display.newText("Camera is in use!", display.contentCenterX, display.contentCenterY + 60, native.systemFont, 18)
	else
		offCameraText = display.newText("Camera is not in use.", display.contentCenterX, display.contentCenterY + 60, native.systemFont, 18)
	end
end

local function micBtnListener(event)
	if offCameraText ~= nil then 
    	offCameraText:removeSelf()
    	offCameraText = nil
    end
	
	if offMicText ~= nil then 
    	offMicText:removeSelf()
    	offMicText = nil
    end

    if onCameraText ~= nil then 
    	onCameraText:removeSelf()
    	onCameraText = nil
    end

    if onMicText ~= nil then 
    	onMicText:removeSelf()
    	onMicText = nil
    end
	
    local micInUse = androidUtils.checkMic()
	if micInUse == 1 then
		onMicText = display.newText("Mic is in use!", display.contentCenterX, display.contentCenterY + 60, native.systemFont, 18)
	else
		offMicText = display.newText("Mic is not in use.", display.contentCenterX, display.contentCenterY + 60, native.systemFont, 18)
	end
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
    	local checkCamera = widget.newButton(
		{
			x = display.contentCenterX - 3,
			y = display.contentCenterY - 75,
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
			height = 58,
			isEnabled = true,
			onEvent = CameraBtnListener
		})
		sceneGroup:insert(checkCamera)

       local checkMic = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 5,
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
			height = 53,
			isEnabled = true,
			onEvent = micBtnListener
		})
		sceneGroup:insert(checkMic)

		local backBtn = widget.newButton(
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 127,
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
			height = 53,
			isEnabled = true,
			onEvent = backBtnListener
		})
		sceneGroup:insert(backBtn)
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

    if offCameraText ~= nil then 
    	offCameraText:removeSelf()
    end
	
	if offMicText ~= nil then 
    	offMicText:removeSelf()
    end

    if onCameraText ~= nil then 
    	onCameraText:removeSelf()
    end

    if onMicText ~= nil then 
    	onMicText:removeSelf()
    end	
end
 
monitorScene:addEventListener( "create", monitorScene )
monitorScene:addEventListener( "show", monitorScene )
monitorScene:addEventListener( "hide", monitorScene )
monitorScene:addEventListener( "destroy", monitorScene )
 
return monitorScene