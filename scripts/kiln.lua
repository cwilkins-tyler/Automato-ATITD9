-- kiln.lua
-- Updated by Rhaom - v1.0 added September 13, 2019

dofile("common.inc");
dofile("settings.inc");

kilnList = {"True Kiln", "Vault Kiln", "Reinforced Kiln"};
arrangeWindows = true;

-- Tweakable delay values
refresh_time = 250 -- Time to wait for windows to update

askText = "Kilns.lua - Updated for T9 by Rhaom\n\nPin up windows manually or use the Arrange Windows option to pin/arrange windows.";

function doit()
	askForWindow(askText);
	config();
		if(arrangeWindows) then
			arrangeInGrid(nil, nil, nil, nil,nil, 10, 25);
		end
	sleepWithStatus(1200, "Preparing to Start ...\n\nHands off the mouse!"); 
	unpinOnExit(start);
end

function config()
  scale = 0.8;
  local z = 0;
  local is_done = nil;
  while not is_done do
	local y = 7;

  checkBreak("disallow pause");

	lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
		"Global Settings\n-------------------------------------------");
	y = y + 35;

	passCount = readSetting("passCount",tonumber(passCount));
    lsPrint(15, y, z, scale, scale, 0xffffffff, "Passes :");
    is_done, passCount = lsEditBox("passes", 110, y-2, z, 50, 30, scale, scale,
                                   0x000000ff, passCount);
    if not tonumber(passCount) then
      is_done = false;
      lsPrint(10, y+30, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passCount = 1;
    end
    writeSetting("passCount",tonumber(passCount));
  y = y + 32;

	lsPrint(15, y, 0, scale, scale, 0xffffffff, "Kiln Type:");
	kiln = lsDropdown("kiln", 110, y-2, 0, 150, kiln, kilnList);
	y = y + 32;

	arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
	arrangeWindows = CheckBox(15, y, z+10, 0xFFFFFFff, "Arrange windows (Grid format)", arrangeWindows, 0.65, 0.65);
	writeSetting("arrangeWindows",arrangeWindows);
	y = y + 28;

	lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
		"Product Settings\n-------------------------------------------");
	y = y + 35;

	if kiln == 1 then
		kilnName = "True Kiln"
	elseif kiln == 2 then
		kilnName = "Vault Kiln"
	elseif kiln == 3 then
		kilnName = "Reinforced Kiln"
	end

	if kilnName == "True Kiln" or kilnName == "Reinforced Kiln" then
		if not clayMortars and not firebricks and not jugs and not clayPot then
			clayBricks = readSetting("clayBricks",clayBricks);
			clayBricks = CheckBox(15, y, z+10, 0xFFFFFFff, "Load the Kiln with Wet Clay Bricks", clayBricks, 0.65, 0.65);
			writeSetting("clayBricks",clayBricks);
			y = y + 22;
		end

		if not clayBricks and not firebricks and not jugs and not clayPot then
			clayMortars = readSetting("clayMortars",clayMortars);
			clayMortars = CheckBox(15, y, z+10, 0xFFFFFFff, "Load the Kiln with Wet Clay Mortars", clayMortars, 0.65, 0.65);
			writeSetting("clayMortars",clayMortars);
			y = y + 22;
		end

		if not clayBricks and not clayMortars and not jugs and not clayPot then
			firebricks = readSetting("firebricks",firebricks);
			firebricks = CheckBox(15, y, z+10, 0xFFFFFFff, "Load the Kiln with Wet Firebricks", firebricks, 0.65, 0.65);
			writeSetting("firebricks",firebricks);
			y = y + 22;
		end

		if not clayBricks and not clayMortars and not firebricks and not clayPot then
			jugs = readSetting("jugs",jugs);
			jugs = CheckBox(15, y, z+10, 0xFFFFFFff, "Load the Kiln with Wet Jugs", jugs, 0.65, 0.65);
			writeSetting("jugs",jugs);
			y = y + 22;
		end

		if not clayBricks and not clayMortars and not firebricks and not jugs then
			clayPot = readSetting("clayPot",clayPot);
			clayPot = CheckBox(15, y, z+10, 0xFFFFFFff, "Load the Kiln with Wet Clay Pots", clayPot, 0.65, 0.65);
			writeSetting("clayPot",clayPot);
			y = y + 22;
		end
	end

	if kilnName == "Vault Kiln" then
		if not clayDome and not pipeSegment then
			cistern = readSetting("cistern",cistern);
			cistern = CheckBox(15, y, z+10, 0xFFFFFFff, "Load a Cistern (Wet) into the Kiln", cistern, 0.65, 0.65);
			writeSetting("cistern",cistern);
			y = y + 22;
		end

		if not cistern and not pipeSegment then
			clayDome = readSetting("clayDome",clayDome);
			clayDome = CheckBox(15, y, z+10, 0xFFFFFFff, "Load a Wet Clay Dome into the Kiln", clayDome, 0.65, 0.65);
			writeSetting("clayDome",clayDome);
			y = y + 22;
		end

		if not cistern and not clayDome then
			pipeSegment = readSetting("pipeSegment",pipeSegment);
			pipeSegment = CheckBox(15, y, z+10, 0xFFFFFFff, "Load a Pipe Segment (Wet) into the Kiln", pipeSegment, 0.65, 0.65);
			writeSetting("pipeSegment",pipeSegment);
			y = y + 22;
		end
	end

  if clayBricks then
    product = "Clay Bricks";
  elseif clayMortars then
    product = "Clay Mortars";
  elseif firebricks then
    product = "Firebricks";
  elseif jugs then
    product = "Jugs";
  elseif clayPot then
    product = "Clay Pot";
  elseif cistern then
    product = "Cistern";
  elseif clayDome then
	product = "Clay Dome";
  elseif pipeSegment then
	product = "Pipe Segment";
  end

	if clayBricks or clayMortars or firebricks or jugs or clayPot then
	  if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Begin") then
		is_done = 1;
	  end
	end

	if cistern or clayDome or pipeSegment then
	  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
		is_done = 1;
	  end
	end

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
	  "End script") then
	  error "Clicked End Script button";
	end
    lsDoFrame();
    lsSleep(shortWait);
  end
end

function start()
	for i=1, passCount do
		refreshWindows();
		checkRepair();
		srReadScreen();
		kilnRegions = findAllText("This is ", nil, REGION)

		for i = 1, #kilnRegions do
			checkBreak()
			local loadWood = waitForText("Wood", nil, nil, kilnRegions[i])
			sleepWithStatus(500, "Loading wood into the kiln\n\nButton at: " .. loadWood[0] .. ", " .. loadWood[1]);
			clickText(loadWood)
			lsSleep(refresh_time)
			local loadProduct = waitForText(product, nil, nil, kilnRegions[i])
			sleepWithStatus(500, "Loading the kiln with Wet " .. product .. "\n\nButton at: " .. loadProduct[0] .. ", " .. loadProduct[1]);
			clickText(loadProduct)
			lsSleep(refresh_time)
			local fireKiln = waitForText("Fire", nil, nil, kilnRegions[i])
			sleepWithStatus(500, "Firing the kiln\n\nButton at: " .. fireKiln[0] .. ", " .. fireKiln[1]);
			clickText(fireKiln)
			lsSleep(refresh_time)
		end

		closePopUp();
		checkFiring();
		refreshWindows();

		clickAllText("Take...");
		lsSleep(500);
		clickAllText("Everything");
	end
	lsPlaySound("Complete.wav");
end

function refreshWindows()
    srReadScreen();
    this = findAllText("This");
    for i = 1, #this do
        clickText(this[i]);
    end
    lsSleep(500);
end

function checkRepair()
	lsSleep(500);
	closePopUp();
	srReadScreen();
	clickAllText("Repair");
	lsSleep(500);
end

function checkFiring()
		while 1 do
			refreshWindows();
			srReadScreen();
			firing = findAllText("Firing")
				if #firing == 0 then
					break; --We break this while statement because Making is not detect, hence we're done with this round
				end
			sleepWithStatus(999, "Waiting for " .. product .. " to finish", nil, 0.7);
		end
end

function closePopUp()
  while 1 do
    srReadScreen()
    local ok = srFindImage("OK.png")
    if ok then
      statusScreen("Found and Closing Popups ...", nil, 0.7);
      srClickMouseNoMove(ok[0]+5,ok[1],1);
      lsSleep(100);
    else
      break;
    end
  end
end
