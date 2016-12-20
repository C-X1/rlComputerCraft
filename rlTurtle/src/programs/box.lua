os.loadAPI("rlTurtle")
local T = rlTurtle
local mv=T.mv



local tArgs = { ... }
hostile=false


boxprog=
{
  floor_fwd=0,
  floor_bwd=1,
  walls=1,
  top_fwd=2,
  top_bwd=3,  
}


local progress=boxprog.floor_fwd




function clearPath()
  T.move(mv.tLeft)
  T.move(mv.tLeft)
  turtle.dig()
  
  if(hostile) then
    turtle.attack()
  end  
  
  T.move(mv.tLeft)
  T.move(mv.tLeft)
end

local function checkInventory()

end



function placeblock()
  while( not T.move(mv.back) ) do
    clearPath()
  end
  
  while(not turtle.place())do
      checkInventory()
      turtle.dig()
      if(hostile)then
       turtle.attack()
      end
  end
  
end

function turn()
  
end


local function main()

  local done = false
  
  print("The arguments are:")
  for _,arg in ipairs(tArgs) do
    print(arg)
  end


  dimX=tonumber(tArgs[1])
  dimZ=tonumber(tArgs[2])
  dimY=tonumber(tArgs[3]) --height
  
  
  if(not dimX or not dimY or not dimY) then
    print("Usage box <X> <Z> <Y> <hostile y>")
    exit()
  end
  
  if(tArgs[4] == "y")then
    hostile=true
  end
  
  
  --turn 
  T.move(mv.tLeft)
  T.move(mv.tLeft)
  
  
  
  
  
  while not done do
  
  
    if(progress==boxprog.floor_fwd)then
      if(data.position.x==dimx)then
        turn()
      else
        placeblock()
      end      
      
    elseif(progress==boxprog.floor_bwd)then
      if(data.position.z==dimz)then
        turn()
      else
        placeblock()
      end   
    
    end
  end

end

main()