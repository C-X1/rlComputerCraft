os.loadAPI("rlOccSense")
os.loadAPI("rlRedStone")

function checkContentAndBundled(sensor_loc, 
                                     bundle_loc, 
                                     contentLimit,
                                     x,y,z,colour)                            
  local user_loc_string= x..","..","..y..","..z .. ": "
  local i=rlOccSense.getInventoryPercentFull(sensor_loc,x,y,z)
  if(i==nil) then
    return (user_loc_string .. " not found!")
  end
  
  local status=""
  
  
  if(i<contentLimit)then
    rlRedStone.setBundleWire(bundle_loc, colour)
    status=" ON"    
  else
    rlRedStone.clearBundleWire(bundle_loc, colour)
    status=" OFF"  
  end

  return (user_loc_string .." ".. status .. " ".. i)
end

local i=0
local sense_loc="right"
local bundle_loc="back"

while true do
  i=i+1
  
  

  term.clear()
  print("Cycle " .. i .. ": ")
      
  rlRedStone.pulseBundleWire(bundle_loc,colors.white)
  
  print( "Contrete Supply" ..
          checkContentAndBundled(
                                        sense_loc,
                                        bundle_loc,
                                        30,
                                        -1,-1,-4,
                                        colors.green
                                     ) 
        )
        
    print("Compact Concrete Gen" ..
          checkContentAndBundled(
                                        sense_loc,
                                        bundle_loc,
                                        30,
                                        4,-1,-1,
                                        colors.gray
                                     ) 
         )
         
     print( "Reinf Concrete Gen" ..
          checkContentAndBundled(
                                        sense_loc,
                                        bundle_loc,
                                        30,
                                        3,0,-6,
                                        colors.black
                                     ) 
        )
  
  os.sleep(1)
end