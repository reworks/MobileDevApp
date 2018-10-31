-- 
-- Abstract: CompositeViewer sample app
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
--
-- v2.1		2/19/2014	Added filter name in title on preview screen
------------------------------------------------------------

local composer = require( "composer" )

--composer.setVariable ("fileToDisplay" ,"complaints/ComplaintGovtSource.txt")
--composer.setVariable ("listToDisplay" , "complaints/complaints.json")
--composer.setVariable ("mainTitle", "Complaints")
--composer.setVariable ("displayTitle", "Click the button to toggle the Complaints Info.")

composer.setVariable ("fileToDisplay" , "legalrights/LegalRightsNSW.txt")
composer.setVariable ("listToDisplay" , "legalrights/legalRights.json")
composer.setVariable ("mainTitle", "Relevant Acts")
composer.setVariable ("displayTitle", "Click the button to toggle the Legal Rights Info.")

composer.gotoScene( "displayScene" )
