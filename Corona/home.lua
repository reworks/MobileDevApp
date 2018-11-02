-- home.lua - Main Menu of App after registering.

local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to import composer library

local homeScene = composer.newScene()

local function Security ( event )
	composer.gotoScene("monitorScene")
end
local function Legal ( event )
	-- Since legalRights utilizes the same scene, by changing a few variables we can recycle the same code to display the complaints or legal rights!
	composer.setVariable ("fileToDisplay" , "legalrights/LegalRightsWA.txt")
	composer.setVariable ("listToDisplay" , "legalrights/legalRights.json")
	composer.setVariable ("mainTitle", "Relevant Acts")
	composer.setVariable ("displayTitle", "Click the button to toggle the Legal Rights Info.")

	composer.gotoScene("legalRights")
end
local function Complain_bt ( event )
	-- Since legalRights utilizes the same scene, by changing a few variables we can recycle the same code to display the complaints or legal rights!
	composer.setVariable ("fileToDisplay" ,"complaints/ComplaintGovtSource.txt")
	composer.setVariable ("listToDisplay" , "complaints/complaints.json")
	composer.setVariable ("mainTitle", "Complaints")
	composer.setVariable ("displayTitle", "Click the button to toggle the Complaints Info.")

	composer.gotoScene("legalRights")
end

function homeScene:create( event )
    local sceneGroup = self.view

    -- Pretty simple, ensures background is centered when its displayed on the phone.
    local inputBG = display.newImage("home.png", true)
	inputBG.x = display.contentCenterX	
	inputBG.y = display.contentCenterY
	inputBG.height= 600
	inputBG.width= 330

	sceneGroup:insert(inputBG)
end
 
function homeScene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
-- These buttons define each of the main menu buttons to press. All stanard corona widgets.

    	local Sec_Mon = widget.newButton(
	{
		x = 70,
		y = 90,
		shape = "rect",
		fillColor = 
		{	
			default = 
			{
				1, 0.2, 0.5, 0.01
			},
			over = 
			{
				1, 0.2, 0.5, 0.2
			}
		},
		width = 130,
		height = 170,
		isEnabled = true,
		

		
	})
	local Leg_Rt = widget.newButton(
	{
		x = 240,
		y = 260,
		shape = "rect",
		fillColor = 
		{	
			default = 
			{
				1, 0.2, 0.5, 0.01
			},
			over = 
			{
				1, 0.2, 0.5, 0.2
			}
		},
		width = 130,
		height = 170,
		isEnabled = true,

		
	})
	local Complain = widget.newButton(
	{
		x = 95,
		y = 460,
		shape = "rect",
		fillColor = 
		{	
			default = 
			{
				1, 0.2, 0.5, 0.01
			},
			over = 
			{
				1, 0.2, 0.5, 0.2
			}
		},
		width = 150,
		height = 150,
		isEnabled = true,

		
	})
	Sec_Mon:addEventListener("touch", Security)
	Leg_Rt:addEventListener("touch", Legal)
	Complain:addEventListener("touch", Complain_bt)

	sceneGroup:insert(Sec_Mon)
	sceneGroup:insert(Leg_Rt)
	sceneGroup:insert(Complain)
    end
end
 
function homeScene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
    end
end
 
function homeScene:destroy( event )
    local sceneGroup = self.view
end
 
homeScene:addEventListener( "create", homeScene )
homeScene:addEventListener( "show", homeScene )
homeScene:addEventListener( "hide", homeScene )
homeScene:addEventListener( "destroy", homeScene )
 
return homeScene