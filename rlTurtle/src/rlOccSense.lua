os.loadAPI("ocs/apis/sensor")

function SensChestfilterByPos(sensor_location,x,y,z)

  local s = sensor.wrap(sensor_location)

  for chestHR, data in pairs(s.getTargets()) do

    isDefChest=true
    
    for dataName, dataValue in pairs(data) do

        if(dataName=="Position")then
            for posDataName, posDataValue in pairs(dataValue) do
                
                if(posDataName=='X')then
                    if(posDataValue~=x)then
                      isDefChest=false
                    end
                end
                if(posDataName=='Y')then
                    if(posDataValue~=y)then
                      isDefChest=false
                    end
                end
                if(posDataName=='Z')then
                    if(posDataValue~=z)then
                      isDefChest=false
                    end
                end
                
                if(isDefChest==false)then
                  break
                end
            end
        end
        

    end
  
    if (isDefChest) then                
      return data
    end

  end
  print("Chest not found!")
  return nil
end

function SensChestGetInventoryPercentFull(sensor_location,x,y,z)
  
  D=SensChestfilterByPos(sensor_location,x,y,z)
  
  if(D==nil) then
    return nil
  end
  
  
  for dataName, dataValue in pairs(D) do
    if(dataName=="InventoryPercentFull")then
      return dataValue
    end
  end
end
