os.loadAPI("rlOccSense")
while true do
  i=rlOccSense.getInventoryPercentFull("top",1,-1,2)
  pulseState=false
  on=i<30
 
  term.clear()
  print(i)
 
  if(i==nil) then
    print("Error chest not found!")  
    rs.setOutput("right", false)
    exit(1)
  end
 
 
  if(on==true)then
    pulsestate=not pulsestate
    rs.setOutput("right", pulsestate)    
    print("ON")  
  else
    print("OFF")  
  end
  os.sleep(1)
end