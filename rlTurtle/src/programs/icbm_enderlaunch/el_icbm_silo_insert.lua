--SILO INSERT
local function main()
  peripheral.call("bottom","turnOn")
  while true do
    if(rs.getInput("bottom"))then
      print("unload silo")
      turtle.suckUp()
    else
      print("load silo")
      turtle.dropUp()  
    end
    os.sleep(0.1)
    term.clear()
  end
end
main()