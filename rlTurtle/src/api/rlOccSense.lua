os.loadAPI("ocs/apis/sensor")


function filterInRange(sensor_location, xmin, ymin, zmin, xmax, ymax, zmax)
  local s = sensor.wrap(sensor_location)
  local targets={}
  local tgt=0
  for target, data in pairs(s.getTargets()) do
    for dataName, dataValue in pairs(data) do
        local isTarget=0
        if(dataName=="Position")then
            for posDataName, posDataValue in pairs(dataValue) do
                if(posDataName=='X')then
                    if(posDataValue>=xmin or posDataValue<=xmax)then
                      isTarget=isTarget+1
                    end
                end
                if(posDataName=='Y')then
                    if(posDataValue>=ymin or posDataValue<=ymax)then
                      isTarget=isTarget+1
                    end
                end
                if(posDataName=='Z')then
                    if(posDataValue>=zmin or posDataValue<=zmax)then
                      isTarget=isTarget+1
                    end
                end
            end
        end
        if(isTarget==3)then
            targets[target]=s.getTargetDetails(target)
        end
    end
  end
  return targets
end

function filterByPos(sensor_location,x,y,z)

  local s = sensor.wrap(sensor_location)

  for target, data in pairs(s.getTargets()) do
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
      return s.getTargetDetails(target)
    end

  end
  print("Target not found!")
  return nil
end


function  getSensorValue(sensor_location,value,x,y,z)
  
  D=filterByPos(sensor_location,x,y,z)
  
  if(D==nil) then
    return nil
  end
  
  
  for dataName, dataValue in pairs(D) do
    if(dataName==value)then
      return dataValue
    end
  end
end


function  getInventoryPercentFull(sensor_location,x,y,z)
  
  D=filterByPos(sensor_location,x,y,z)
  
  if(D==nil) then
    return nil
  end
  
  
  for dataName, dataValue in pairs(D) do
    if(dataName=="InventoryPercentFull")then
      return dataValue
    end
  end
end

function printInRange(sensor_location)
  local s = sensor.wrap(sensor_location)

  for target, data in pairs(s.getTargets()) do

    isDefChest=true
    for dataName, dataValue in pairs(data) do
        if(dataName=="RawName")then
          print(dataValue .. ":  " .. target) 
        end
    end
  end
end


