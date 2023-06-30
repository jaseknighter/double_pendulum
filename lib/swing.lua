-- From: https://github.com/micaeloliveira/physics-sandbox/blob/feature/new-styling/assets/javascripts/pendulum.js

local d2_theta1 = 0
local d2_theta2 = 0
local d_theta1 = 0
local d_theta2 = 0
local theta1 = 0*(math.pi)/2
local theta2 = 2.3*(math.pi)/2
local m1 = 5
local m2 = 3
local l1 = 150/6
local l2 = 150/6
local x0 = 350/6
local y0 = 60/6
local g = 9.8
local time = 0.2

local my_line1 = {}
my_line1.x0 = x0
my_line1.y0 = y0
my_line1.x = 0
my_line1.y = 0

local my_line2 = {}
my_line2.x0 = 0
my_line2.y0 = 0
my_line2.x = 0
my_line2.y = 0

my_circle1 = {}
my_circle1.x = x0+l1*math.sin(theta1)
my_circle1.y = y0+l1*math.cos(theta1)
my_circle1.mass = m1

local my_circle2 = {}
my_circle2.x = x0+l1*math.sin(theta1)+l2*math.sin(theta2)
my_circle2.y = y0+l1*math.cos(theta1)+l2*math.cos(theta2)
my_circle2.mass = m2

----
-- define function to run with each redraw cycle
----
update = function ()
  local update_fn = function()
    mu = 1+m1/m2
    d2_theta1 = (g*(math.sin(theta2)*math.cos(theta1-theta2)-mu*math.sin(theta1))-(l2*d_theta2*d_theta2+l1*d_theta1*d_theta1*math.cos(theta1-theta2))*math.sin(theta1-theta2))/(l1*(mu-math.cos(theta1-theta2)*math.cos(theta1-theta2)))
    d2_theta2 = (mu*g*(math.sin(theta1)*math.cos(theta1-theta2)-math.sin(theta2))+(mu*l1*d_theta1*d_theta1+l2*d_theta2*d_theta2*math.cos(theta1-theta2))*math.sin(theta1-theta2))/(l2*(mu-math.cos(theta1-theta2)*math.cos(theta1-theta2)))
    d_theta1 = d_theta1 + d2_theta1*time
    d_theta2 = d_theta2 + d2_theta2*time
    theta1 = theta1 + d_theta1*time
    theta2 = theta2 + d_theta2*time
  
    my_circle1.x = x0+l1*math.sin(theta1)
    my_circle1.y = y0+l1*math.cos(theta1)
    my_circle2.x = x0+l1*math.sin(theta1)+l2*math.sin(theta2)
    my_circle2.y = y0+l1*math.cos(theta1)+l2*math.cos(theta2)
  
    my_line1.x  = my_circle1.x
    my_line1.y  = my_circle1.y
    my_line2.x0 = my_circle1.x
    my_line2.y0 = my_circle1.y
    my_line2.x  = my_circle2.x
    my_line2.y  = my_circle2.y
  end
  update_fn()
  
  local display_fn = function()
    -- screen.level(5)
    screen.aa(1)

    screen.clear()
    screen.level(screen_level_graphics)

    screen.move(my_line1.x0,my_line1.y0)
    screen.line(my_line1.x,my_line1.y)
    screen.stroke()
    screen.move(my_line2.x0,my_line2.y0)
    screen.line(my_line2.x,my_line2.y)
    screen.stroke()
    screen.circle(my_circle1.x,my_circle1.y,my_circle1.mass)
    screen.circle(my_circle2.x,my_circle2.y,my_circle2.mass)
    screen.fill()
    
    screen.update()
  end
  display_fn()
end

return {
  update = update
}
