-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar)
local physics = require('physics')
physics.start()
physics.setDrawMode("hybrid")

local widget = require("widget")

local cX = display.contentCenterX
local cY = display.contentCenterY
local cW = display.actualContentWidth
local cH = display.actualContentHeight

-- Define World Objects

local hill
local circle
local speedbump

hill = display.newRect(cX - 700 , cY + 100, 500, 50)
hill.rotation = 35
hill.alpha = 1

physics.addBody(hill, "static")


circle = display.newCircle(cX - 700, cH*.8, 50)
circle.alpha = 1

physics.addBody(circle, "static", {radius = 50})

speedbump = display.newCircle(cX - 700, cY + cH/2, 50)
speedbump.alpha = 1

physics.addBody(speedbump, "static", {radius = 50})


local roof = display.newRect(cX, cY - cH/2, cW, cH*.05)

local groundRect = display.newRect(cX, cY + cH/2, cW, cH*.05)

local lwall = display.newRect(cX - cW/2, cY, cW*.05, cH)

local rwall = display.newRect(cX + cW/2, cY, cW*.05, cH)

local carBody = display.newRect(cX, cH*.5, 50, 25)
carBody:setFillColor(1,0,0)

local carWheel1 = display.newCircle(carBody.x - 20, carBody.y+15, 10)
carWheel1:setFillColor(0,0,1)

local carWheel2 = display.newCircle(carBody.x + 20, carBody.y+15, 10)
carWheel2:setFillColor(0,0,1)


-- Add physics bodies

physics.addBody(groundRect, "static", {density = 1.6, friction = 0.5})
physics.addBody(lwall, "static", {density = 1.6, friction = 0.5})
physics.addBody(rwall, "static", {density = 1.6, friction = 0.5})
physics.addBody(roof, "static", {density = 1.6, friction = 0.5})
physics.addBody(carBody, "dynamic")
physics.addBody(carWheel1, "dynamic", {radius = 10, friction = 0.3})
physics.addBody(carWheel2, "dynamic", {radius = 10, friction = 0.3})

-- Add Welds

local wheel1Joint = physics.newJoint("wheel", carBody, carWheel1, carWheel1.x, carWheel1.y, 0, -40)
local wheel2Joint = physics.newJoint("wheel", carBody, carWheel2, carWheel2.x, carWheel2.y, 0, -40)

-- Make car draggable

local function dragBody(event)

	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if phase == "began" then
		stage:setFocus(body, event.id)
		body.isFocus = true

		body.tempJoint = physics.newJoint("touch", body, event.x, event.y)

	elseif body.isFocus then
		if phase == "moved" then
			body.tempJoint:setTarget(event.x, event.y)


		elseif phase == "ended" or phase == "canceled" then
			stage:setFocus(body, nil)
			body.isFocus = false
			body.tempJoint:removeSelf()
		end
	end

	return true
end


local function moveLeft(event)

	carBody:setLinearVelocity(-100, 0)

end

local function moveRight(event)

	carBody:setLinearVelocity(100, 0)

end

local function objectAdd(event)

  if event.phase == "began" then

  elseif event.phase == "ended" or event.phase == "canceled" then

    local number = math.random(1,3)

    if number == 1 then

      hill.x = cX - 100
      speedbump.x = cX - 700
      circle.x = cX - 700
      carBody.x = cX
      carBody.y = cH*.5
      carWheel1.x = carBody.x - 20
      carWheel1.y = carBody.y + 15
      carWheel2.x = carBody.x + 20
      carWheel2.y = carBody.y + 15

    elseif number == 2 then

      circle.x = cX
      hill.x = cX - 700
      speedbump.x = cX - 700
      carBody.x = cX
      carBody.y = cH*.5
      carWheel1.x = carBody.x - 20
      carWheel1.y = carBody.y + 15
      carWheel2.x = carBody.x + 20
      carWheel2.y = carBody.y + 15


    elseif number == 3 then

      speedbump.x = cX
      hill.x = cX - 700
      circle.x = cX - 700
      carBody.x = cX
      carBody.y = cH*.5
      carWheel1.x = carBody.x - 20
      carWheel1.y = carBody.y + 15
      carWheel2.x = carBody.x + 20
      carWheel2.y = carBody.y + 15

    end

  end
end

widget.newButton({

  top = cY,
  right = cX,
  label = "objectAdd",
  onEvent = objectAdd

})

widget.newButton({

	x = cX + 100,
	y = cY,
	label = "left",
	onEvent = moveLeft


})

widget.newButton({

	x = cX + 200,
	y = cY,
	label = "right",
	onEvent = moveRight

})


carBody:addEventListener("touch", dragBody)
