

---------------------------------------------------------------------------------------

local widget = require( "widget" )

local M = {}

local infoShowing = false

function M:newUI( options )

	local backGroup = display.newGroup()			-- Contains the scroll region to display the data
	local frontGroup = display.newGroup()			-- Has the top button (toggle Display) and bottom bar 'Return' button.
	local textGroupContainer = display.newContainer( 308, 290 ) ; frontGroup:insert( textGroupContainer )
	local barContainer = display.newContainer( display.actualContentWidth, 50 )
	local bottomBarContainer = display.newContainer( display.actualContentWidth, 50)
	frontGroup:insert( barContainer )
	frontGroup:insert( bottomBarContainer )
	barContainer.anchorX = 0
	barContainer.anchorY = 0
	bottomBarContainer.anchorX = 0
	bottomBarContainer.anchorY = 30	
	barContainer.anchorChildren = false
	barContainer.x = display.screenOriginX
	barContainer.y = display.screenOriginY
	bottomBarContainer.x = display.screenOriginX
	bottomBarContainer.y = display.screenOriginY
	print ("Arrived in the content display screen. Origin X = " .. display.screenOriginX .. ", Y = " .. display.screenOriginY)
	
	local scrollBounds
	local infoBoxState = "canOpen"
	local transComplete
	local themeName = options.theme or "darkgrey"
	local contentDisplayTitle = options.title or "Content"
	local fileName = options.fileName
	print ("File name : " .. fileName)
	
	-- Read from the LegalRights.txt file
	local LRIText = ""
	local LRIFilePath = system.pathForFile( fileName, system.ResourceDirectory )
	if LRIFilePath then
		local readMeFile = io.open( LRIFilePath )
		local rt = readMeFile:read( "*a" )
		if string.len( rt ) > 0 then LRIText = rt end
		io.close( readMeFile ) ; readMeFile = nil ; rt = nil
	end

	-- Create background image by theme value
	local background = display.newImageRect( backGroup, "images/back-" .. themeName .. ".png", 360, 640 )
	background.x, background.y = display.contentCenterX, display.contentCenterY

	local topBarBack = display.newRect( barContainer, 0, 0, barContainer.contentWidth, barContainer.contentHeight )
	local bottomBarBack = display.newRect( bottomBarContainer, 0, 30, bottomBarContainer.contentWidth, bottomBarContainer.contentHeight )
	bottomBarBack.anchorX = 0
	bottomBarBack.anchorY = 90
	bottomBarBack:setFillColor( 0,0,0,0.6 )
	topBarBack.anchorX = 0
	topBarBack.anchorY = 0
	topBarBack:setFillColor( 0,0,0,0.2 )
--	topBarBack:toBack()
	local topBarOver = display.newRect( barContainer, 0, 0, barContainer.contentWidth, barContainer.contentHeight - 2 )
	local bottomBarOver = display.newRect( bottomBarContainer, 0, 30, bottomBarContainer.contentWidth, bottomBarContainer.contentHeight - 2 )
	topBarOver.anchorX = 0
	topBarOver.anchorY = 0
	topBarOver:setFillColor( { type="gradient", color1={ 0.144 }, color2={ 0.158 } } )
	bottomBarOver:setFillColor( { type="gradient", color1={ 0.244 }, color2={ 0.158 } } )
	textGroupContainer:toBack()
	print ("Action Bar header Image created. Content Width = " .. barContainer.contentWidth .. ", Height = " .. barContainer.contentHeight)
	print ("Bottom Action Bar header Image created. Content Width = " .. bottomBarContainer.contentWidth .. ", Height = " .. bottomBarContainer.contentHeight)
	
	-- Check system for font selection
	local useFont
	print ("Font check being Made...")
	if ( "android" == system.getInfo( "platform" ) or "win32" == system.getInfo( "platform" ) ) then
		useFont = native.systemFont
	else
		useFont = "HelveticaNeue-Light"
	end
	self.appFont = useFont

	-- Place sample app title
	local title = display.newText( barContainer, contentDisplayTitle, barContainer.contentWidth - 28, topBarOver.contentHeight / 2, useFont, 12 )
	title.anchorX = 1

	-- Create shade rectangle
	local screenShade = display.newRect( frontGroup, 0, 0, display.actualContentWidth, display.actualContentHeight )
	screenShade:setFillColor( 0,0,0 ) ; screenShade.alpha = 0
	screenShade.x, screenShade.y = display.contentCenterX, display.contentCenterY
	screenShade.isHitTestable = false ; screenShade:toBack()
	print ("Shaded Rectangle created...")

	-- Create info button (initially invisible)
	local infoButton = display.newImageRect( barContainer, "images/infobutton.png", 25, 25 )
	infoButton.anchorX = 1
	infoButton.x = barContainer.contentWidth - 3
	infoButton.y = topBarOver.contentHeight / 2
	infoButton.isVisible = false
	infoButton.id = "infoButton"
	print ("Invisible Info Button created. Position X = " .. infoButton.x .. ", Y = " .. infoButton.y)
	
	-- Create the Return button

	local returnButton = display.newImageRect( barContainer, "images/rowArrow.png", 25, 25 )
	returnButton.anchorX = 1
	returnButton.x = bottomBarContainer.contentWidth - 150
	returnButton.y = bottomBarOver.contentHeight / 2
	returnButton.isVisible = false
	returnButton.id = "returnButton"
	print ("invisible Return Button created. Position X = " .. returnButton.x .. ", Y = " .. returnButton.y)
	
	-- Create table for initial object positions
	local objPos = { infoBoxOffY=0, infoBoxDestY=0 }

	-- Resize change handler
	local function onResize( event )
		print ("Resize Event handler created...")
		if display.contentHeight >= display.contentWidth then
			background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 0
		else
			background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 90
		end

		bottomBarContainer.x = display.screenOriginX
		bottomBarContainer.y = display.screenOriginY + 550
		bottomBarContainer.width = display.actualContentWidth
		bottomBarBack.width = barContainer.width
		bottomBarOver.width = barContainer.width
		returnButton.x = bottomBarContainer.contentWidth - 150

		barContainer.x = display.screenOriginX
		barContainer.y = display.screenOriginY
		barContainer.width = display.actualContentWidth
		topBarBack.width = barContainer.width
		topBarOver.width = barContainer.width
		title.x = barContainer.contentWidth - 28
		infoButton.x = barContainer.contentWidth - 3
				
		screenShade.x = display.contentCenterX
		screenShade.y = display.contentCenterY
		screenShade.width = display.actualContentWidth
		screenShade.height = display.actualContentHeight
		textGroupContainer.x = display.contentCenterX
		
		-- The info box displays the contents of the text file read in the scrolling region.
		-- If info box is opening or already open, snap it entirely on screen
		objPos["infoBoxOffY"] = display.screenOriginY - 130
		objPos["infoBoxDestY"] = (barContainer.y + barContainer.contentHeight + 130)
		if ( infoBoxState == "opening" or infoBoxState == "canClose" ) then
			transition.cancel( "infoBox" )
			textGroupContainer.xScale, textGroupContainer.yScale = 1,1
			textGroupContainer.y = objPos["infoBoxDestY"]
			if scrollBounds then
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxDestY"]
			end
			transComplete()
		-- If info box is closing or already closed, snap it entirely off screen
		elseif ( infoBoxState == "closing" or infoBoxState == "canOpen" ) then
			transition.cancel( "infoBox" )
			textGroupContainer.y = objPos["infoBoxOffY"]
			if scrollBounds then
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
			end
			transComplete()
		end
	end
	
	Runtime:addEventListener( "resize", onResize )
	
	print ("Event listener created at RunTime...")
	-- If there is LegalRights.txt content, create needed elements
	if LRIText ~= "" then

		-- Create the info box scrollview
		scrollBounds = widget.newScrollView
		{
			x = 160,
			y = objPos["infoBoxDestY"],
			width = 288,
			height = 240,
			horizontalScrollDisabled = true,
			hideBackground = true,
			hideScrollBar = true,
			topPadding = 0,
			bottomPadding = 0
		}
		scrollBounds:setIsLocked( true, "vertical" )
		scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
		frontGroup:insert( scrollBounds )

		local infoBoxBack = display.newRect( 0, 0, 288, 240 )
		if themeName == "whiteorange" then infoBoxBack:setFillColor( 0.88 )
		elseif themeName == "lightgrey" then infoBoxBack:setFillColor( 0.98 )
		else infoBoxBack:setFillColor( 0.78 ) end
		textGroupContainer:insert( infoBoxBack )

		-- Create the info text group
		local infoTextGroup = display.newGroup()
		textGroupContainer:insert( infoTextGroup )

		-- Find and then sub out documentation links
		local docLinks = {}
		for linkTitle, linkURL in string.gmatch( LRIText, "%[([%w\%s\%p\%—]-)%]%(([%w\%p]-)%)" ) do
			docLinks[#docLinks+1] = { linkTitle, linkURL }
		end
		LRIText = string.gsub( LRIText, "%[([%w\%s\%p\%—]-)%]%(([%w\%p]-)%)", "" )

		-- Create the info text and anchoring box
		local infoText = display.newText( infoTextGroup, "", 0, 0, 260, 0, useFont, 12 )
		infoText:setFillColor( 0 )
		local function trimString( s )
			return string.match( s, "^()%s*$" ) and "" or string.match( s, "^%s*(.*%S)" )
		end
		LRIText = trimString( LRIText )
		infoText.text = "\n" .. LRIText
		infoText.anchorX = 0
		infoText.anchorY = 0
		infoText.x = -130

		-- Add documentation links as additional clickable text objects below main text
		if #docLinks > 0 then
			for i = 1,#docLinks do
				local docLink = display.newText( docLinks[i][1], 0, 0, useFont, 12 )
				docLink:setFillColor( 0.9, 0.1, 0.2 )
				docLink.anchorX = 0
				docLink.anchorY = 0
				docLink.x = -130
				docLink.y = infoTextGroup.contentBounds.yMax + 5
				infoTextGroup:insert( docLink )
				if system.canOpenURL( docLinks[i][2] ) then
					docLink:addEventListener( "tap",
						function( event )
							system.openURL( docLinks[i][2] )
							return true
					end )
				end
			end
		end
		local spacer = display.newRect( infoTextGroup, 0, infoTextGroup.contentBounds.yMax, 10, 15 )
		spacer.anchorY = 0 ; spacer.isVisible = false

		local textHeight = 240
		if infoTextGroup.height < 240 then textHeight = infoTextGroup.height end

		local infoTextAnchorBox = display.newRect( infoTextGroup, 0, 0, 288, textHeight )
		infoTextAnchorBox.anchorY = 0
		infoTextAnchorBox.isVisible = false

		-- Set anchor point on info text group
		local anc = infoTextGroup.height/120
		infoTextGroup.anchorChildren = true
		infoTextGroup.anchorY = 1/anc

		-- Initially set info objects to invisible
		
		infoTextGroup.isVisible = false
		textGroupContainer.isVisible = false
		
		transComplete = function()

			if infoBoxState == "opening" then
				scrollBounds:insert( infoTextGroup )
				infoTextGroup.x = 144 ; infoTextGroup.y = 120
				scrollBounds:setIsLocked( false, "vertical" )
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxDestY"]
				infoBoxState = "canClose"
				infoShowing = true
				if self.onInfoEvent then
					self.onInfoEvent( { action="show", phase="did" } )
				end
			elseif infoBoxState == "closing" then
				infoTextGroup.isVisible = false
				textGroupContainer.isVisible = false
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
				screenShade.isHitTestable = false
				infoBoxState = "canOpen"
				infoShowing = false
				if self.onInfoEvent then
					self.onInfoEvent( { action="hide", phase="did" } )
				end
			end
		end

		local function controlInfoBox( event )
	
				
			print ("Display the text file in the infoBox event...")
			if event.phase == "began" then
				if infoBoxState == "canOpen" then
					infoBoxState = "opening"
					infoShowing = true
					
					if self.onInfoEvent then
						self.onInfoEvent( { action="show", phase="will" } )
					end
					
					textGroupContainer.x = display.contentCenterX
					textGroupContainer.y = objPos["infoBoxOffY"]
					textGroupContainer:insert( infoTextGroup )
					infoTextGroup.isVisible = true
					textGroupContainer.isVisible = true
					textGroupContainer.xScale = 0.96 ; textGroupContainer.yScale = 0.96
					screenShade.isHitTestable = true
					transition.cancel( "infoBox" )
					transition.to( screenShade, { time=400, tag="infoBox", alpha=0.75, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=900, tag="infoBox", y=objPos["infoBoxDestY"], transition=easing.outCubic } )
					transition.to( textGroupContainer, { time=400, tag="infoBox", delay=750, xScale=1, yScale=1, transition=easing.outQuad, onComplete=transComplete } )

				elseif infoBoxState == "canClose" then
					infoBoxState = "closing"
					infoShowing = false
					if self.onInfoEvent then
						self.onInfoEvent( { action="hide", phase="will" } )
					end
					
					textGroupContainer:insert( infoTextGroup )
					local scrollX, scrollY = scrollBounds:getContentPosition()
					infoTextGroup.x = 0 ; infoTextGroup.y = scrollY
					scrollBounds:setIsLocked( true, "vertical" )
					transition.cancel( "infoBox" )
					transition.to( screenShade, { time=400, tag="infoBox", alpha=0, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=400, tag="infoBox", xScale=0.96, yScale=0.96, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=700, tag="infoBox", delay=200, y=objPos["infoBoxOffY"], transition=easing.inCubic, onComplete=transComplete } )
				end				
			end
			return true
		end

		-- Return to the previous scene.
		
		local function controlReturnBox( event )
			print ("Return button touched.")
		end
		
		-- Set info and Return button tap listener
		infoButton.isVisible = true
		returnButton.isVisible = false
		print ("Info and Return buttons are Visible...")
		infoButton:addEventListener( "touch", controlInfoBox )
		infoButton.listener = controlInfoBox

		returnButton:addEventListener( "touch", controlReturnBox )
		returnButton.listener = controlReturnBox
		
		screenShade:addEventListener( "touch", controlInfoBox )
	end

	self.infoButton = infoButton
	self.titleBarBottom = topBarOver.y + topBarOver.contentHeight
	backGroup:toBack() ; self.backGroup = backGroup
	frontGroup:toFront() ; self.frontGroup = frontGroup
	onResize()
end

function M:isInfoShowing()
	return infoShowing
end

return M
