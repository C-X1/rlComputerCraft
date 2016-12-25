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
  
  print("Enter Station Name:")
  local stationName=read()
  
  sf=fs.open("StationName","w")
  sf.write(stationName)
  sf.close()
  
  shell.run("label set ".. stationName .. "_main_turtle")
  
  
  
  print("Downloading files from GIT...")
  for file, link in pairs(file_links) do
    print("Downloading file " .. file)  	
  	rq=http.get(link)
  	
  
  	
  	if(rq==nil)then
  	 print("Could not download file " .. file .. ", aborting..")
  	 return 0
  	end
  	
  	data=rq.readAll()
  	
  	if(fs.exists(file))then
  	 fs.delete(file)
  	end
  	
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
    print(i)
    turtle.select(i)
    if(i==1)then --place disk drive
       turtle.place()
    elseif(i==2)then -- insert disk
       turtle.drop()
       os.sleep(1)
       
       if(fs.exists("disk/startup"))then
          fs.delete("disk/startup")
       end
       
       if(fs.exists("disk/loader_turtle"))then
          fs.delete("disk/loader_turtle")
       end
       
       if(fs.exists("disk/launcher_controller"))then
          fs.delete("disk/launcher_controller")
       end

       if(fs.exists("disk/StationName"))then
          fs.delete("disk/StationName")
       end
       
       
       
       fs.move("pc_turtle_install","disk/startup") 
       fs.move("loader_turtle","disk/loader_turtle") 
       fs.move("launcher_controller","disk/launcher_controller") 
       fs.copy("StationName","disk/StationName")
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
  
  if(fs.exists("startup"))then
    fs.delete("startup")
  end
  fs.move("main_turtle","startup")
  --remove disk from drive
  turtle.suck()
  turtle.dropDown()
  peripheral.call("top","turnOn")
  shell.run("startup") 
  
       
  
end
main()