--ENDER ICBM COMMAND CREATOR
function save(table,name)
  local file = fs.open(name,"w")
  file.write(textutils.serialize(table))
  file.close()
end


targetData=
{
  manual=false,
  frequ=0,
  x=0,
  y=0,
  z=0,
}

function getInteger(label)
    term.clear()
    while true do
       
       print(label .. ":")
       i = read()
       i=tonumber(i)
       if(i ~= nil) then
            return i
       else
            term.clear()
            print("Enter a number!")
       end
       
    end
end

function getYesNo(text)
    while true do
        print(text)
        a=read()
        if(a=="y")then
            return true
        elseif(a=="n") then
            return false
        else
            term.clear()
            print("Enter y or n!")
        end
    end  
end

function getOption()

end

local function main()

  while true do
    --check for disk
    --check for missile
  
    turtle.suckUp()
  
    --check for disk
    --check for missile
  
    turtle.select(1)
    turtle.dropUp() 
  
    x=getInteger("X")
    z=getInteger("Z")
    y=getInteger("Det. Height:")
    
    print("Coordinates are:")
      
    ok=getYesNo(x .. " " .. z .. " (" .. y .. ") Correct?")
    if(ok==true)then
        
      targetData.x=x
      targetData.y=y
      targetData.z=z
      
      
      print("Writing disk and sending it")
      
      if(fs.exists("disk"))then
        save(targetData,"disk/target")
        -- check for missile
        -- check slot  
        turtle.suckUp()
      	turtle.dropDown()
      	turtle.select(1)
      	turtel.dropDown()
        
      else
        print("No Disk found in drive!")
      end
      

    
    end

  end

end

main()
