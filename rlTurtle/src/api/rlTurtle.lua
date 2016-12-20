local inited=false


---
--
--    X(0)
--    |
--    |
-- (3)_____Z(1=
--    (2)
--
dir=
{
  Xp=0,
  Zp=1,
  Xn=2,
  Zn=3,
}

mv=
{
  front=0,
  back=1,
  up=2,
  down=3,
  tLeft=4,
  tRight=5
}


rsOut=
{
  front=0,
  up=1,
  down=2,
  left=3,
  right=4, 
}

manip=
{
  front=0,
  up=1,
  down=2
} 
    
placeState=
{
  placed=0,
  slot_empty=1,
  blocked_block=2,
  blocked_mob=3,
  position_unsupported=4
}

intoEnder=
{
  success=0,
  couldNotPlace=1,
  notAvailable=2,
  enderFull=3,
}

fromEnder=
{
  success=0,
  couldNotPlace=1,
  notAvailable=2,
  enderEmpty=3,
  inventFull=4,
}
  

data=
{
  __settings__=
  {
     EnderChestID=241,
     DimensionalAnchorID=1001
  },
  
  dir=dir.Xp,
  
  position=
  {
    x=1,
    y=0,
    z=0,
    isRelative=true,
    dir=0
  },

  enderChest=
  {
    {
     slotNum=16,
     placed=-1,
    }
  },
  dimensionalAnchors=
  {
    slotNum=15,
    {
      available=false,
      placed=false,
      x=0,
      y=0,
      z=0
    },
    {
      available=false,
      placed=false,
      x=0,
      y=0,
      z=0
    }
  }
}

function save(table,name)
  local file = fs.open(name,"w")
  file.write(textutils.serialize(table))
  file.close()
end

function load(name)
  local file = fs.open(name,"r")
  local data = file.readAll()
  file.close()
  return textutils.unserialize(data)
end

function out(where, tf)
    if(where==rsOut.front)then
      redstone.setOutput("front", tf)
    elseif(where==rsOut.up)then
      redstone.setOutput("up", tf)   
    elseif(where==rsOut.down)then
      redstone.setOutput("down", tf)    
    elseif(where==rsOut.left)then
      redstone.setOutput("left", tf)    
    elseif(where==rsOut.right)then
      redstone.setOutput("right", tf)    
    end
end

function freeSpace(rangeStart,rangeEnd)
   free=0
   for s=rangeStart,rangeEnd do
     turtle.select(s)
     count=turtle.getItemCount(s) 

     if(count==0)then
        free=free+1
     end
   end 
   return free
end

function move(how)
  result=false
  
  if(mv.front==how)then
    result=turtle.forward()
  elseif(mv.back==how)then
    result=turtle.back()
  elseif(mv.up==how)then
    result=turtle.up()    
  elseif(mv.down==how)then
    result=turtle.down()
  elseif(mv.tLeft==how)then
    result=turtle.turnLeft()
  elseif(mv.tRight==how)then
    result=turtle.turnRight()
  end
  
  
  if(result) then
    if(mv.front==how)then
      if(data.dir==dir.Xp)then
        data.position.x=data.position.x+1
      elseif(data.dir==dir.Xn)then
        data.position.x=data.position.x-1
      elseif(data.dir==dir.Zp)then
        data.position.z=data.position.z+1
      elseif(data.dir==dir.Zn)then
        data.position.z=data.position.z-1
      end
    elseif(mv.back==how)then
      if(data.dir==dir.Xp)then
        data.position.x=data.position.x-1
      elseif(data.dir==dir.Xn)then
        data.position.x=data.position.x+1
      elseif(data.dir==dir.Zp)then
        data.position.z=data.position.z-1
      elseif(data.dir==dir.Zn)then
        data.position.z=data.position.z+1
      end
    elseif(mv.up==how)then
      data.position.y=data.position.y+1
    elseif(mv.down==how)then
      data.position.y=data.position.y-1
    elseif(mv.tLeft==how)then
      if(data.dir==dir.Xp)then
          data.dir=dir.Zp
      elseif(data.dir==dir.Zp)then
          data.dir=dir.Xn
      elseif(data.dir==dir.Xn)then
          data.dir=dir.Zn
      elseif(data.dir==dir.Zn)then
          data.dir=dir.Xp
      end    
  
    elseif(mv.tRight==how)then
      if(data.dir==dir.Xp)then
          data.dir=dir.Zn
      elseif(data.dir==dir.Zp)then
          data.dir=dir.Xp
      elseif(data.dir==dir.Xn)then
          data.dir=dir.Zp
      elseif(data.dir==dir.Zn)then
          data.dir=dir.Xn
      end    
    end
  end  

  return result
end


function getBlockIOFunctions(position)
  io={
      place=turtle.place,
      detect=turtle.detect,
      dig=turtle.dig,
      attack=turtle.attack,
      inspect=turtle.inspect,
      compare=turtle.compare,
      drop=turtle.drop,
      suck=turtle.suck,
  }
 
  if(position==manip.front) then
      io.place=turtle.place
      io.detect=turtle.detect
      io.dig=turtle.dig
      io.attack=turtle.attack
      io.inspect=turtle.inspect
      io.compare=turtle.compare
      io.drop=turtle.drop
      io.suck=turtle.suck
     
  elseif(position==manip.down) then
      io.place=turtle.placeDown
      io.detect=turtle.detectDown
      io.dig=turtle.digDown
      io.attack=turtle.attackDown
      io.inspect=turtle.inspectDown
      io.compare=turtle.compareDown
      io.drop=turtle.dropDown
      io.suck=turtle.suckDown
      
  elseif(position==manip.up) then
      io.place=turtle.placeUp
      io.detect=turtle.detectUp
      io.dig=turtle.digUp
      io.attack=turtle.attackUp
      io.inspect=turtle.inspectUp
      io.compare=turtle.compareUp
      io.drop=turtle.dropUp
      io.suck=turtle.suckUp
  else
      return nil
  end
  
  return io
end
  
---
--Places a selected block to a chosen position
--@param position A value of PLACE_BLOCK_POS_<FRONT,UP,DOWN>
--@param slot will place one item of slotNumber to position
--@param dig if it finds a block it will try to remove it
--@param hostile if a number greater 0 and there is no block 
--but it is not possible to place something there is a mob or player
--it will try to attack as many times and then abort, if still not possible
--if smaller zero it will try endlessly
--@return a value of PLACE_BLOCK_* depending on the result
--
function  PlaceBlock(position,dig,hostile,slot)


  
  if ( position == nil ) then
      position=manip.front
  end
  io=getBlockIOFunctions(position)
    
  if(io==nil) then
    return placeState.position_unsupported
  end
    
  if( (slot~=nil) ) then
    turtle.select(slot)
  end
  
  if ( turtle.getItemCount(slot) == 0 ) then
    return placeState.slot_empty
  end
  
  if( (dig==nil) )then
    dig=false
  end

  if( (hostile==nil) ) then
    hostile=false
  end
  
  --check if there is a block
  if(io.detect()) then
    --shall we dig?
    if(dig==false) then
      return placeState.blocked_block
    end
  
    --so lets dig
    if(io.dig())then
      while(io.dig())do
        os.sleep( 1 ) -- wait if we have sand,gravel etc...
      end
    else
      return placeState.placed
    end
  end
  --so lets try placing it ...
  if(io.place()) then
    return placeState.placed  
  else  
    i=0
    res=io.place()
    if(hostile)then
      while(not res and 
          (hostile<0 
           or i<hostile) ) 
      do
          io.attack()
          res=io.place()
          i=i+1
      end
      if(res==true) then
        return placeState.placed
      else
        return placeState.blocked_mob
      end
      
    else
      return placeState.blocked_mob
    end
    
  end

end




function InventoryFromToEnderChest(takeOut,
                                rangeStart,
                                rangeEnd,
                                enderChestNum,
                                dig,
                                hostile
                                )

   result=-1 
   
   
   if(enderChestNum==nil)then
      enderChestNum=1
   end
  
   if(attackMobs==nil)then
      attackMobs=false
   end
   
   if(dig==nil)then
      dig=false
   end
   
   if(data.enderChest[enderChestNum]==nil) then
      return intoEnder.notAvailable
   end
  
   position=-1
   ioposition=0
   for p=0,5  do
   
      if(p>2)then
        turtle.turnLeft()
        ioposition=manip.front
      else
        ioposition=p
      end
   
        position=p
      if(
      PlaceBlock(ioposition, dig, hostile, data.enderChest[enderChestNum].slotNum)   
              ==placeState.placed
      ) 
      then
        break
      end
      
      if(position==5)then
        result= intoEnder.couldNotPlace
      end
      
   end
   
   
   io=getBlockIOFunctions(ioposition)
   
   if (not takeOut) then-->toEnderChest
   
       if(result~=intoEnder.couldNotPlace) then
       
         for s=rangeStart,rangeEnd do
           
           turtle.select(s)
           
           count=turtle.getItemCount(s) 
           
           result=intoEnder.success
           if(count>0)then
             if(not io.drop())then
                result=intoEnder.enderFull
                break
             end   
           end
         end
       end
         
     else--fromEnderChest
         result=fromEnder.enderEmpty
         for s=rangeStart,rangeEnd do
           freeSlot=false
           turtle.select(s)
           count=turtle.getItemCount(s) 
           if(count==0)then
             freeSlot=true
             if(not io.suck())then
                   break    
             else
                result=fromEnder.success
             end
           end
         end
         
         if(freeSlot==false)then
          result=fromEnder.inventFull
         end
    end
   

   turtle.select(data.enderChest[enderChestNum].slotNum)  
   io.dig()
   
   
   
   --go back to position
   if(position>2)then
      if(position==3) then
        turtle.turnRight()
      elseif(position==4) then
        turtle.turnLeft()
        turtle.turnLeft()
      elseif(position==5) then
        turtle.turnLeft()      
      end   
   end
   
   return result
   
end

function printCoordinates()
  print("X "..
        data.position.x .. "Y "  .. 
        data.position.y .. "Z "  .. 
        data.position.z .. "DIR " ..
        data.dir
        )
        
  print()
end   


function countDown(eventstop,sec,min,hou)
  local seconds=sec
  local myTimer = os.startTimer(1)
  

  
  while true do
    event, id, text = os.pullEvent()

    if event == "timer" then
      myTimer = os.startTimer(1)
      seconds=seconds-1
      h=math.floor(seconds/3600)
      m=math.floor((seconds-(h*3600))/60)
      s=math.floor((seconds-(h*3600)-(m*60)))
      term.clear()
      
      fm=""
      fs=""
      
      if(m<10)then
        fm="0"
      end
      
      if(s<10)then
        fs="0"
      end
      
      print(h .. ":" .. fm .. m .. ":" .. fs .. s)      
    
      if(seconds==0)then 
        break 
      end
    else
      if(eventstop)then
        break
      end
      
    end
  
  end
end
