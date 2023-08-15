-- From: https://github.com/micaeloliveira/physics-sandbox/blob/feature/new-styling/assets/javascripts/pendulum.js

local swing = {}
swing.__index = swing

function swing:new(x,theta2)
  local sw = {}
  setmetatable(sw,swing)
  sw.d2_theta1 = 0
  sw.d2_theta2 = 0
  sw.d_theta1 = 0
  sw.d_theta2 = 0
  sw.theta1 = 0.1 -- 0*(math.pi)/2
  sw.theta2 = theta2 or 2.3*(math.pi)/2
  sw.m1 = 7
  sw.m2 = 7
  sw.l1 = 25 --150/6
  sw.l2 = 25 --150/6
  sw.x0 = x or 58.333 --350/6
  sw.y0 = 10 --60/6
  sw.g = 9.8
  sw.time = 0.2

  sw.my_line1 = {}
  sw.my_line1.x0 = sw.x0
  sw.my_line1.y0 = sw.y0
  sw.my_line1.x = 0
  sw.my_line1.y = 0
  
  sw.my_line2 = {}
  sw.my_line2.x0 = 0
  sw.my_line2.y0 = 0
  sw.my_line2.x = 0
  sw.my_line2.y = 0
  
  sw.my_circle1 = {}
  sw.my_circle1.x = sw.x0+sw.l1*math.sin(sw.theta1)
  sw.my_circle1.y = sw.y0+sw.l1*math.cos(sw.theta1)
  sw.my_circle1.mass = sw.m1
  sw.my_circle1.radius = sw.m1*0.5

  sw.my_circle2 = {}
  sw.my_circle2.x = sw.x0+sw.l1*math.sin(sw.theta1)+sw.l2*math.sin(sw.theta2)
  sw.my_circle2.y = sw.y0+sw.l1*math.cos(sw.theta1)+sw.l2*math.cos(sw.theta2)
  sw.my_circle2.mass = sw.m2
  sw.my_circle2.radius = sw.m2*0.5
  
  sw.theta1_tb = {}
  sw.theta2_tb = {}
  -- math.max(table.unpack(sw1.theta1_tb))
  -- math.min(table.unpack(sw1.theta2_tb))
  -- math.min(table.unpack(sw2.theta1_tb))
  -- math.min(table.unpack(sw2.theta2_tb))
  ----
  -- define function to run with each redraw cycle
  ----
  sw.update = function ()
    sw.mu = 1+sw.m1/sw.m2
    sw.d2_theta1 = (sw.g*(math.sin(sw.theta2)*math.cos(sw.theta1-sw.theta2)-sw.mu*math.sin(sw.theta1))-(sw.l2*sw.d_theta2*sw.d_theta2+sw.l1*sw.d_theta1*sw.d_theta1*math.cos(sw.theta1-sw.theta2))*math.sin(sw.theta1-sw.theta2))/(sw.l1*(sw.mu-math.cos(sw.theta1-sw.theta2)*math.cos(sw.theta1-sw.theta2)))
    sw.d2_theta2 = (sw.mu*sw.g*(math.sin(sw.theta1)*math.cos(sw.theta1-sw.theta2)-math.sin(sw.theta2))+(sw.mu*sw.l1*sw.d_theta1*sw.d_theta1+sw.l2*sw.d_theta2*sw.d_theta2*math.cos(sw.theta1-sw.theta2))*math.sin(sw.theta1-sw.theta2))/(sw.l2*(sw.mu-math.cos(sw.theta1-sw.theta2)*math.cos(sw.theta1-sw.theta2)))
    sw.d_theta1 = sw.d_theta1 + sw.d2_theta1*sw.time
    sw.d_theta2 = sw.d_theta2 + sw.d2_theta2*sw.time
    sw.theta1 = sw.theta1 + sw.d_theta1*sw.time
    sw.theta2 = sw.theta2 + sw.d_theta2*sw.time
  
    sw.my_circle1.x = sw.x0+sw.l1*math.sin(sw.theta1)
    sw.my_circle1.y = sw.y0+sw.l1*math.cos(sw.theta1)
    sw.my_circle2.x = sw.x0+sw.l1*math.sin(sw.theta1)+sw.l2*math.sin(sw.theta2)
    sw.my_circle2.y = sw.y0+sw.l1*math.cos(sw.theta1)+sw.l2*math.cos(sw.theta2)
  
    sw.my_line1.x  = sw.my_circle1.x
    sw.my_line1.y  = sw.my_circle1.y
    sw.my_line2.x0 = sw.my_circle1.x
    sw.my_line2.y0 = sw.my_circle1.y
    sw.my_line2.x  = sw.my_circle2.x
    sw.my_line2.y  = sw.my_circle2.y
    table.insert(sw.theta1_tb,sw.d_theta1)
    table.insert(sw.theta2_tb,sw.d_theta2)
  end

sw.display = function()
      local t2min = math.min(table.unpack(sw.theta2_tb))
      local t2max = math.max(table.unpack(sw.theta2_tb))

      -- local lvl = util.linlin(t2min,t2max,3,15,sw.theta2)
      local circle_distance = (sw.my_circle1.x-40) + (sw.my_circle2.x - 40)
      local lvl = util.linlin(-50,50,3,15,circle_distance)

    -- print(lvl,t2min,t2max,3,15,sw.theta2)
    screen.level(math.floor(lvl))

    screen.move(sw.my_line1.x0,sw.my_line1.y0)
    screen.line(sw.my_line1.x,sw.my_line1.y)
    screen.stroke()
    screen.move(sw.my_line2.x0,sw.my_line2.y0)
    screen.line(sw.my_line2.x,sw.my_line2.y)
    screen.stroke()
    screen.circle(sw.my_circle1.x,sw.my_circle1.y,sw.my_circle1.radius)
    screen.circle(sw.my_circle2.x,sw.my_circle2.y,sw.my_circle2.radius)
    screen.fill()
    
    local R = sw.my_circle2.radius
    local Xc = sw.my_line2.x
    local Yc = sw.my_line2.y
    local X1 = 25
    local Y1 = 50
    local X2 = X1+10
    local Y2 = Y1+10
    --draw a recr
    
    screen.move (X1,Y1)
    screen.rect(X1,Y1, 10, 10)
    -- print("checkOverlap",checkOverlap(R, Xc, Yc,X1, Y1,X2, Y2))
    check_strike(R, Xc, Yc,X1, Y1,X2, Y2)
    screen.stroke()
    -- screen.update()
  end
  
  function check_strike(R, Xc, Yc,X1, Y1,X2, Y2)
      local overlap = checkOverlap(R, Xc, Yc,X1, Y1,X2, Y2)
      if overlap then
        local mel = mseq()
        engine.hz(midi_to_hz(mel))  
      end
    end
  -- return {
  --   update = update
  -- }
  
  return sw
end

return swing
