local function main()
    
  sf=fs.open("disk/StationName","r")
  local stationName=sf.readAll()
  sf.close()
  
    
  if(turtle ~= nil)then
    print("installing turtle software")
    fs.move("disk/loader_turtle", "startup")
    shell.run("label set "..stationName.."_load_turtle")
  
  else
    print("installing controller software")
    fs.move("disk/launcher_controller", "startup")
    shell.run("label set "..stationName.."_controller")
  
  end
  
  shell.run("startup")
end
main()