
local widget = require("widget") -- Used to import UI Widgets.
local composer = require("composer") -- Used to import composer library

local scene = composer.newScene()

-- Displays the app screen that handles registration input.
local function displayHome()
	local inputBG = display.newImage("home.png", true)
	inputBG.x = display.contentCenterX	
	inputBG.y = display.contentCenterY
	inputBG.height= 600
	inputBG.width= 330

	local function Security ( event )
		local mytext = display.newText("you touched security monitoring", 150, 200, Arial, 20)
		mytext:setFillColor(1, 0, 0)
		print (mytext)
	end
	local function Legal ( event )
		local mytext = display.newText("you touched legal rights", 150, 220, Arial, 20)
		mytext:setFillColor(9, 0, 5)
		print (mytext)
	end
	local function Complain_bt ( event )
		local mytext = display.newText("you touched complain ", 150, 240, Arial, 20)
		mytext:setFillColor(3, 3, 0)
		print (mytext)
	end

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
	end

function scene:create( event )
	local sceneGroup = self.view
end


-- App start function. Sets up app.
local function main()
	displayHome()

	
end

-- Run the app
main()