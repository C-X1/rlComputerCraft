os.loadAPI("ocs/apis/sensor")

local knownComponents=
{
  unknown=-1,
  nothing=0,
  floppy=1,
  missile=2
}

local knownComponentsStrings=
{
  nothing="empty",
  floppy="item.ccdisk",
  missile="icbm.missile"
}


local data=
{
  slot1=0,
  slot2=0
}

local main_states=
{
  err=-1,
  waitForChest=0,
  getFromChest=1,
  loadMissile=2,
  insertDisk=3,
  waitReturnState=4,
  
  launch=5,
  manualLaunch=6,
}

local s=main_states




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



local function identKnownComponents(rawName)
  id=knownComponents.unknown

  print(rawName)

  if string.find(rawName,knownComponentsStrings.missile,1,true)==1 then
    return knownComponents.missile
  elseif rawName == knownComponentsStrings.floppy then
    return knownComponents.floppy
  elseif rawName == "empty" then
    return knownComponents.nothing
  else
    return knownComponents.unknown 
  end  
  
  return id
end

local function updateSlotState()
    local slot1=getInventorySlot("left","0,-1,0",1)
    local slot2=getInventorySlot("left","0,-1,0",2)

    if(slot1~=nil)then
      data.slot1=identKnownComponents(slot1.RawName)
    else
      data.slot1=knownComponents.nothing
    end
    
    if(slot2~=nil)then
      data.slot2=identKnownComponents(slot2.RawName)
    else
      data.slot2=knownComponents.nothing
    end
end
 

local function main()
  while  true  do
    updateSlotState()
    
    
    if(state==s.waitForChest)then
      if(data.slot1 == knownComponents.missile and data.slot2 == knownComponents.floppy)
      then
          state=s.getFromChest
      end
    elseif(state==s.getFromChest)then
       turtle.select(1)
       turtle.suckDown()
       turtle.select(2)
       turtle.suckDown()
       state=s.loadMissile
    elseif(state==s.loadMissile)then
       turtle.select(1)
       turtle.dropUp()
    elseif(state==s.insertDisk)then
       turtle.select(2)
       turtle.drop()
       state=s.waitState
    elseif(state==s.waitReturnState)then
       if(fs.exists("disk"))then       
          if(fs.exits("disk/err"))then
            rs.setOutput("top",true)
            state=s.err
          elseif(fs.exits("disk/ready"))then
            fs.delete("disk/ready")
            local f=fs.open("disk/launch","w")
            f.write("")
            f.close()
            state=s.launch
          elseif(fs.exits("disk/manualRdy"))then
            fs.delete("disk/manualRdy")
            state=s.manualLaunch
          end
       
       end   
    else
    
    end
    os.sleep(0.1)
  end
end
main()
