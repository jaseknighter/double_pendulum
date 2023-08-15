---double pendulum
-- <version> @<author> and @jaseknighter
-- lines: llllllll.co/t/<lines thread id>
--
-- double pendulum code based on code from Daniel Shiffman's The Nature of Code (https://natureofcode.com/book/chapter-2-forces/).

s=require("sequins")
lattice=require("lattice")

encoders_and_keys = include "double_pendulum/lib/encoders_and_keys"
swing = include("double_pendulum/lib/swing")

engine.name = "PolyPerc"

-------------------------------------------
-- global variables
-------------------------------------------
updating_controls = false
OUTPUT_DEFAULT = 4
SCREEN_FRAMERATE = 1/15
menu_status = false

alt_key_active = false
screen_level_graphics = 15
num_pages = 1

initializing = true



------------------------------
-- init
------------------------------
function init()

  -- set sensitivity of the encoders
    
  sw1 = swing:new(40)
  sw2 = swing:new(80,2.1*(math.pi)/2)
  init_lattice()
  lat:start()

  set_redraw_timer()
  
  engine.amp(1)
  engine.release(1)
  initializing = false
end

--------------------------
-- encoders and keys
--------------------------
function enc(n, delta)
  encoders_and_keys.enc(n, delta)
end

function key(n,z)
  encoders_and_keys.key(n, z)
end

--------------------------
-- redraw 
--------------------------
function set_redraw_timer()
  redrawtimer = metro.init(function() 
    local menu_status = norns.menu.status()
    if menu_status == false and initializing == false then
      screen.aa(0)
      screen.clear()
      screen.level(screen_level_graphics)
      sw1.display()
      sw2.display()
      screen.update()

    end
  end, SCREEN_FRAMERATE, -1)
  redrawtimer:start()  
end


--------------------------
-- functions 
--------------------------
-- overlap checker
-- check if any
-- point overlaps the given circle
-- and rectangle
-- from: https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/#
 
-- Function to check if any point
-- overlaps the given circle
-- and rectangle
function checkOverlap(R, Xc, Yc, X1, Y1, X2, Y2)

   
    -- Find the nearest point on the
    -- rectangle to the center of
    -- the circle
    local Xn = math.max(X1, math.min(Xc, X2))
    local Yn = math.max(Y1, math.min(Yc, Y2))
       
    -- Find the distance between the
    -- nearest point and the center
    -- of the circle
    -- Distance between 2 points,
    -- (x1, y1) & (x2, y2) in
    -- 2D Euclidean space is
    -- ((x1-x2)**2 + (y1-y2)**2)**0.5
    local Dx = Xn - Xc
    local Dy = Yn - Yc
    return (Dx * Dx + Dy * Dy) <= R * R
end

--[[     
-- Driver Code
local R = 1
local Xc = 0, Yc = 0
local X1 = 1, Y1 = -1
local X2 = 3, Y2 = 1
   
if(checkOverlap(R, Xc, Yc,
                   X1, Y1,
                   X2, Y2))
then
    document.write("True" + "\n")
else

    document.write("False")
end
]]
--[[
engine.amp(1);engine.release(1)
engine.hz(midi_to_hz(40))
]]

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

-- setup lattice and sequins

-- mseq=s{40,42,44}
mseq=s{s{40,30,70},s{42,46,73},s{52,78,58}}
rseq=s{1/16}
function init_lattice()
  lat = lattice:new{
    auto = true,
    meter = 4,
    ppqn = 96
  }

  -- setup a pattern to sequence softcut's filter frequency and rq
  lat_pat1 = lat:new_sprocket{
    action = function(t) 
      sw1.update()
      sw2.update()
      local mel = mseq()
      local rhy = rseq()
      -- engine.hz(midi_to_hz(mel))
      -- lat_pat1:set_division(rhy)
    end,
    division = 1/64,
    enabled = true
  }
  
  -- setup a pattern to sequence softcut's filter frequency and rq
  lat_pat2 = lat:new_sprocket{
    action = function(t) 
      
      if #sw1.theta1_tb > 0 then
        local t2min = math.min(table.unpack(sw1.theta2_tb))
        local t2max = math.max(table.unpack(sw1.theta2_tb))
        local cut = util.linlin(t2min,t2max,100,10000,sw1.theta2)
        local pw = util.linlin(t2min,t2max,0.1,0.5,sw1.theta2)

        -- print(sw1.my_circle1.x-40, sw1.my_circle2.x-84,cut_val)
        local circle_distance = (sw1.my_circle1.x-40) + (sw1.my_circle2.x - 40)
        local cut = util.linlin(-50,50,100,10000,circle_distance)
        local pw = util.linlin(-50,50,0.1,0.5,circle_distance)
        -- print(cut,pw)
        -- local cut = util.linlin(t2min,t2max,100,10000,sw1.theta2)
        -- local pw = util.linlin(t2min,t2max,0.1,0.5,sw1.theta2)
        engine.cutoff(cut)
        engine.pw(pw)
      end
    end,
    division = 1/128,
    enabled = true
  }
end


function cleanup ()
  -- add cleanup code
end

