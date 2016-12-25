local function main()
    
  if(turtle ~= nil)then
    print("installing turtle software")
    fs.copy("disk/loader_turtle", "startup")
  else
    print("installing controller software")
    fs.copy("disk/launcher_controller", "startup")
  end
  
end
main()