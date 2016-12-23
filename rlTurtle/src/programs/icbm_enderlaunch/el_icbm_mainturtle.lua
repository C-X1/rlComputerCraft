os.loadAPI("ocs/apis/sensor")


local main_state=
{
  waitForChest=0,
  getFromChest=1,
  loadMissile=2,
  insertDisk=3,
  waitState=4,
  
  launch=5,
  err=6,
}

local function getInventorySlot(sensor_loc,place,slot)
  local sensor = sensor.wrap(sensor_loc)
  
  if(sensor==nil)then
    return nil
  end
  
  details=sensor.getTargetDetails(place)
  
  if details == nil then
    return nil
  end
  
  if(details.Slots == nil) then
    return nil
  end
  
  return details.Slots[slot]
end

local function updateSlotState()
    slot1=getInventorySlot("left","0,-1,0",1)
    slot2=getInventorySlot("left","0,-1,0",2)
    
    if(slot1~=nil)then
      print(slot1.Name)
    end
    
    if(slot2~=nil)then
      print(slot2.Name)
    end
end
 

local function main()
  while  true  do
      if(state==s.waitForChest)then
      
      elseif(state==s.getFromChest)then
      
      
      else
      
      end
    os.sleep(0.1)
  end
end
main()
