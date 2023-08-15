-- encoders and keys

local enc = function (n, delta)
  -- set variables needed by each page/example
  if n == 1 then

  elseif n == 2 then 

  elseif n == 3 then 

  end
end

local key = function (n,z)
  if (n == 1 and z == 0)  then 

  elseif (n == 2 and z == 0)  then 

  elseif (n == 3 and z == 0)  then 

  end
end

return{
  enc=enc,
  key=key
}
