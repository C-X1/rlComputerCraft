os.loadAPI("rlOccSense")
os.loadAPI("rlRedStone")

rlrs=rlRedStone
rlsense=rlOccSense


config=
  {
    sensorSide="top",
    redstoneSide="right",
    redstoneSlaughterColor=colors.red,
    redstoneBreederColor=colors.green,
    animalID="Cow",
    maxAdults=6,
    maxChilds=4,
    area=
    {
      min=
      {
        x=-10,
        y=-10,
        z=-10
      },

      max=
      {
        x=10,
        y=10,
        z=10
      }
    }
  }


function slaughter(state)
  if(state) then
    rlrs.clearBundleWire(config.redstoneSide, config.redstoneSlaughterColor);
  else
    rlrs.setBundleWire(config.redstoneSide, config.redstoneSlaughterColor);
  end
end

function breeder(state)
  if(state) then
    rlrs.clearBundleWire(config.redstoneSide, config.redstoneBreederColor);
  else
    rlrs.setBundleWire(config.redstoneSide, config.redstoneBreederColor);
  end
end


function animal()
  targets=rlsense.filterInRange(config.sensorSide,
    config.area.min.x,
    config.area.min.y,
    config.area.min.z,
    config.area.max.x,
    config.area.max.y,
    config.area.max.z)

  local animals=
    {
      adults=0,
      childs=0
    }

  for target, data in pairs(targets) do
    if(string.find(target,config.animalID))
    then
      for dataName, dataValue in pairs(data) do
        if(dataName=="IsChild")then
          if(dataValue==true)then
            animals.childs=animals.childs+1
          else
            animals.adults=animals.adults+1
          end
        end
      end
    end
  end

  return animals
end




print("Starting SlaughterCon...")
print("Initializing RedNet - disable Feeding and Grinding")
breeder(false)
slaughter(false)


function update()
  local animals = animal()
  local doSlaughter=(animals.adults>config.maxAdults)
  local doBreed=animals.childs<config.maxChilds and (animals.adults >= 2)
  slaughter(doSlaughter)
  breeder(doBreed)

  term.clear()
  term.setCursorPos(1,1)

  print("Slaughtering:")
  print(doSlaughter)
  
  print("Breeding:")
  print(doBreed)
    
  print("Adults:")
  print(animals.adults)
  
  print("Childs:")
  print(animals.childs)
  
end

while(true) do
  update()
  os.sleep(0.5)
end


