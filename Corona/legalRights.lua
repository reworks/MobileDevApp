-----------------------------------------------------------------------------------------
--
-- displayScene.lua
--
-- This is the scene in which the Act links are display.
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local displayLegalRights = require( "displayLR" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar ) 
local titleString = "Relevant Acts"

-- Modules
-------------------------------------------------------------------------------

local widget = require( "widget" )
local json = require "json"

-- Constants
-------------------------------------------------------------------------------

-- create a constant for the left spacing of the row content
local LEFT_PADDING = 10
local halfW = display.contentCenterX
local halfH = display.contentCenterY
local width = display.actualContentWidth


-- Forward declares
-------------------------------------------------------------------------------
local list

-- Views
-------------------------------------------------------------------------------

--Create a group to hold our widgets & images
local view = display.newGroup()

-- Create toolbar to go at the top of the screen
local titleBar = display.newRect( view, halfW, 0, width, 32 )
titleBar.fill = { type = 'gradient', color1 = { .74, .8, .86, 1 }, color2 = { .35, .45, .6, 1 } }
titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

-- create embossed text to go on toolbar
local titleText = display.newText( view, titleString, halfW, titleBar.y, native.systemFontBold, 18 )

 --[[
-- Preview group
-------------------------------------------------------------------------------
local preview = display.newGroup()
preview:translate( halfW + width, halfH )
local w,h = 240,160

local before = display.newImageRect( preview, "images/LDA-ACT.jpg", w, h )



local after = display.newRect( preview, 0, 0, w, h )

after.fill =
{
	type = "composite",
	paint1 = { type="image", filename="images/LDA-ACT.jpg" },
	paint2 = { type="image", filename="images/Image2.jpg" }
}

before.anchorY = 1 -- image on top
after.anchorY = 0 -- image on bottom

local onBackRelease = function()
	--Transition in the list, transition out the item selected text and the back button
	--The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
	transition.to( list, { x = width * 0.5 + display.screenOriginX, time = 400, transition = easing.outExpo } )
	transition.to( preview, { x = width + preview.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	titleText.text = titleString
end

-- Back button
	print ("At the back button code now...")
local backButton = widget.newButton
{
	x = 0,
	y = after.contentHeight + 20,
	width = 298,
	height = 56,
	label = "Back", 
	labelYOffset = - 1,
	onRelease = onBackRelease
}
preview:insert( backButton )

-- preview is child of main view
view:insert( preview )
]]
-- UI
-------------------------------------------------------------------------------

-- Handle row rendering
local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	
	-- Precalculate y position. NOTE: row's height will change as we add children
	local y = row.contentHeight * 0.5

	local rowTitle = display.newText( row, row.id, 0, 0, native.systemFontBold, 12 )
	local rowArrow = display.newImage( row, "images/rowArrow.png", false )

	-- Left-align title
	rowTitle.anchorX = 0
	rowTitle.x = LEFT_PADDING
	rowTitle.y = y
	rowTitle:setFillColor( 0 )
	
	-- Right-align the arrow
	rowArrow.anchorX = 1
	rowArrow.x = row.contentWidth - LEFT_PADDING
	rowArrow.y = y
end

-- Hande row touch events
local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then
		print( "Pressed row id " .. row.index )
	elseif "release" == phase then
		-- Set preview effect
		print ("Released Row id " .. row.id)
		--after.fill.effect = row.id
		
		--Transition out the list, transition in the item selected text and the back button
		
		print ("off to the selected legal rights act display...")		
		displayLegalRights:newUI( { theme="darkgrey", title="Click the button to display the Legal Rights Info.", fileName="legalrights/LegalRightsNSW.txt"} )
		
		display.getCurrentStage():insert( displayLegalRights.backGroup )
		local sceneGroup = display.newGroup()
		display.getCurrentStage():insert( displayLegalRights.frontGroup )

	end
end

-- Create a tableView
list = widget.newTableView
{
	top = titleBar.contentHeight + display.screenOriginY,
	left = display.screenOriginX,
	width = width, 
	height = display.actualContentHeight - titleBar.contentHeight,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
}

-- list is child of main view
view:insert( list )


-- Load effect list
-------------------------------------------------------------------------------

-- Read Legal Rights Acts (effects) from json
local f = io.open( system.pathForFile( "legalrights/legalRights.json" ) )
local data = f:read( "*a" )
local effects = json.decode( data )

for i = 1, #effects do
	list:insertRow{
		id = effects[i], -- use name of effect as id
		height = 72,
		category = "trash"
	}
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene