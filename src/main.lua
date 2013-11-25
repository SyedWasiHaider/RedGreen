--Sim Says written in Lua and Corona SDK
--by Syed Wasi Haider
--October 23, 2013

--Hides the status bar at the top of the display
display.setStatusBar( display.HiddenStatusBar )


-- background color
background = display.newRect(0,0,display.contentWidth,display.contentHeight)
math.randomseed(os.time())


--Initialization of variables and loading sounds
local gameover
local text
local counter = 6
local gandalf
local endtext
local textArr = { "Here goes!", "Think of the children!", "Run you fools!", "Run already!", "No seriously, go!", "Go back to the line or wall"}
local text = display.newText("", display.contentWidth/2, display.contentHeight/2, native.systemFont, 60)
local first = audio.loadSound("cool.wav")
local beep = audio.loadSound("beep.wav", {duration = 1 })
local tick = audio.loadSound("tick.wav")
local win = audio.loadSound("success.mp3")

--Starting test
local textSS = display.newText("",display.contentWidth/2.5, display.contentHeight/2, native.systemFont, 80)

--Init color to neutral (represented here as 0)
local whichColor = 0


-- Changes the color of background by generating a random 1 or 2

function changeColor()


	whichColor = math.random(1,2)

	--Changes the color for the appropriate case
	--and transitions to changeColor after a randomly
	--generated time period


	--Next possible enhancement would be account for the
	--the distance so the time isn't too long or short.
	if (whichColor == 1) then
		background:setFillColor(30,230,40)
		local timeR=math.random(600,2000)
		audio.play(tick, {duration = timeR, loops=-1})
		textSS.text= "GO! Move!"
		reference = transition.to(background, { time = timeR , onComplete=changeColor} )
	end

	if (whichColor == 2) then
		background:setFillColor(200,53,30)
		local timeR=math.random(1000,4000)
		textSS.text="STOP!"
		audio.play(first,  {duration = timeR, loops=-1 })
		reference = transition.to(background, { time = timeR, onComplete=changeColor } )
	end





end




-- shows the initial counter at the beginning of the game
local function showCounter()
	counter = counter - 1;



	if (gandalf == nil) then
		gandalf = display.newText(textArr[counter], display.contentWidth/4, display.contentHeight/1.3, native.systemFont, 30)
	end
	if (text ~= nil) then
		text:removeSelf()
		text = nil
	end
	print(tostring(counter))
	if (counter > 0) then

		audio.play(beep)
		text = display.newText(tostring(counter), display.contentWidth/2, display.contentHeight/2, native.systemFont, 60)
		transition.to(text, {delay = 1000, onComplete = showCounter})

		gandalf.text = textArr[counter+1]
	end

	if (counter == 0) then

		gandalf:removeSelf()
		gandalf = nil
		changeColor()
		Runtime:addEventListener("touch", gameover)


	end

end




--initial setup 
local function setup(event)


	counter = 6
	showCounter()

	background:setFillColor(200,53,30)
	background:setFillColor(200,53,30)
	startButt:removeEventListener("touch", startButt)
	startButt:removeSelf()
	startButt = nil
	return true

end



--restarts the game and does some clean up along the way.
local function restart()

	textSS.text = ""
	counter = 6
	if (endtext ~= nil) then
		endtext:removeSelf()
		endText = nil
	end
	textSS = display.newText("",display.contentWidth/2.5, display.contentHeight/2, native.systemFont, 80)
	text = display.newText("", display.contentWidth/2, display.contentHeight/2, native.systemFont, 30)
	startButt = display.newImage("start.png")
	startButt.y = display.contentHeight/2
	startButt.height = display.contentHeight
	startButt.touch = setup
	startButt:addEventListener("touch", startButt)

end


-- Shows a gameover text
function gameover(event)

	if (event.phase == "began") then
		endtext = display.newText("You got me!", display.contentWidth/5, 0, native.systemFont, 60)
		textSS:removeSelf()
		audio.play(win)
		transition.to (endtext, {delay = 500, time = 1500, y = 160, onComplete = restart})
		Runtime:removeEventListener("touch", gameover)

		transition.cancel(reference)

	end

end

-- Starts game
restart()