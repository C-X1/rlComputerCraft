




local file_links=
{
   ["main_turtle"]="https://raw.githubusercontent.com/C-X1/rlComputerCraft/master/rlTurtle/src/programs/icbm_enderlaunch/el_icbm_mainturtle.lua"
  ,["loader_turtle"]= "https://raw.githubusercontent.com/C-X1/rlComputerCraft/master/rlTurtle/src/programs/icbm_enderlaunch/el_icbm_silo_insert.lua"
  ,["launcher_controller"]="https://raw.githubusercontent.com/C-X1/rlComputerCraft/master/rlTurtle/src/programs/icbm_enderlaunch/el_icbm_controller.lua"  
  ,["pc_turtle_install"]="https://raw.githubusercontent.com/C-X1/rlComputerCraft/master/rlTurtle/src/programs/icbm_enderlaunch/el_icbm_sw_install.lua"
}
local function main()

  print("Need encoded ender chest with items in this order:")
  print("- Disk Drive , - Floppy Disk")
  print("- Turtle (plain Turtle)")
  print("- any solid building block")
  print("- Computer")
  print("- Launch Controller T1, T2 or T3")
  print("- Support frame (with the same tier)")
  print("- Launcher (with the same tier)")
  print("- Sensor Card Inventory")
  print("* Sensor,ProximityCard,Lava Bucket(opt)")
  print("Press enter to continue ...")
  local anyKey=read()
  
  print("Downloading files from GIT...")
  for file, link in pairs(file_links) do
    print("Downloading file " .. file)  	
  	rq=http.get(link)
  	
  	if(rq==nil)then
  	 print("Could not download file " .. file .. ", aborting..")
  	 return 0
  	end
  	
  	data=rq.readAll()
  	
  	--print(data)
  	f=fs.open(file,"w")
    f.write(data)
    f.close()
  end  --place DiskDrive
  
  
  turtle.up()
  
  --place ender chest
  turtle.select(1)
  turtle.placeDown()
  
  --get all items
  for i=1, 12 do	
    turtle.select(i)
    turtle.suckDown()
  end
  
  --  
  for i=1, 11 do  
    turtle.select(i)
    if(i==1)then --place disk drive
       turtle.place()
    elseif(i==2)then -- insert disk
       turtle.drop()
       os.sleep(1)
       fs.copy("pc_turtle_install","disk/startup") 
       -- @todo write startup file for turtle and pc
       
    elseif(i==3)then -- place turtle  
       turtle.up()
       turtle.placeDown()
       peripheral.call("bottom","turnOn")
    elseif(i==4)then -- place block for support
       turtle.turnLeft()
       turtle.turnLeft()
       turtle.place()
       turtle.turnLeft()
       turtle.turnLeft()
    elseif(i==5)then -- place pc
       turtle.place()
       peripheral.call("front","turnOn")
    elseif(i==6)then --place Launcher Control Panel
       turtle.up()
       turtle.place()
    elseif(i==7)then --place support
       turtle.turnLeft()
       turtle.turnLeft() 
       turtle.place()
       turtle.turnLeft()
       turtle.turnLeft()        
    elseif(i==8)then --place launcher
       turtle.down()
       turtle.placeUp()
       turtle.digDown()
       turtle.down()
       turtle.down()
       turtle.placeUp()
    elseif(i==9)then --insert inventory sensor card
       turtle.transferTo(16)
    elseif(i==10)then --place sensor
       turtle.turnLeft()
       turtle.turnLeft()
       turtle.place()
    elseif(i==11)then -- insert proximity sensor card
       os.sleep(1)
       turtle.drop()
       turtle.turnLeft()
       turtle.turnLeft()
    end
  end
  
  
  
end
main()