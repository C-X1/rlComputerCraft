
local start_state=
{
    init=0,
    no_disk=1,
    disk_load=2,
    waiting_for_launch=3,
    disk_rem=4
}

local diskDrive="disk"
local targetFile="target"
local targetFilePath=diskDrive .. "/" ..targetFile

function load(name)
  local file = fs.open(name,"r")
  local data = file.readAll()
  file.close()
  
  
  local usData = textutils.unserialize(data)
  print(textutils.serialize(usData))
  
  return usData  
end


local s=start_state



state=s.init
function checkDisk()
    if(fs.exists("disk"))then
        if(state==s.no_disk) then
            state=s.disk_load
        end
    else
        if(state~=s.init and state~=s.no_disk) then
            state=s.init
        end
    end
end

function randomNumber(digits,negative)

  if(negative==nil)then
    negative=false
  end
 
  
 
  local upper=9 
  local lower=0
  
 
  upper=9
  
  for d=1, digits-1, 1 do
  	upper=upper*10+9
  end 
  
  
  if(negative==true)then
    lower=-upper
  end
   
  return math.random(lower, upper)
end


local function main()

    peripheral.call("front", "turnOn") 
    while  true  do
        checkDisk()
        if(state==s.init)then
            peripheral.call("top","setFrequency",randomNumber(4))   
            term.clear() 
            term.setCursorPos(1,1)
            print("Waiting for disk.")
            state=s.no_disk
        elseif(state==s.no_disk)then
            --nothing check checkDisk
        elseif(state==s.disk_load)then
            local statusString=""
            local err=false
            if(fs.exists("disk/err"))then
              fs.delete("disk/err")
            end
            
            if(fs.exists("disk/target"))then
              print("Reading target file...")
              local targetData=load("disk/target")
              textutils.serialize(targetData)
              
              if(targetData.manual~=nil)then
                  if(targetData.manual==false) then --automatic
                  
                    if( type(targetData.x)=="number" 
                    and type(targetData.y)=="number" 
                    and type(targetData.z)=="number"
                    )then
                      print("Coordinate Launch...")
                      print("Coordinates are:")
                    
                      print(targetData.x .. " " .. targetData.z .. " (" .. targetData.y .. ")")
                    
                      peripheral.call("top","setTarget",targetData.x,targetData.y,targetData.z)
                    
                      print("Checking system...")
                      if(peripheral.call("top","canLaunch")==true) then   
                        print("Launch coordinates good, system ready...")
                        peripheral.call("top","setFrequency",randomNumber(4))  
                        f=fs.open("disk/ready","w")
                        f.write("rdy") 
                        f.close()
                      else
                        statusString= "Launch not possible - check system or coordinates"
                        err=true
                        print(statusString)
                      end
                      
                    
                    else
                      err=true
                      status="Coordinate data error"
                    end
                  

                  else
                    print("Manual mode reading and setting frequency")
                    if(targetData.frequency==nil) then
                      err=true
                      status="No frequency setting!"
                      
                    else
                    
                        if(type(targetData.frequency)~="number") then
                          err=true
                          statusString="frequecy not a number"
                        else
                          if(type(targetData.frequency)<0)then
                            err=true
                            statusString="frequency smaller zero"
                          end
                        end
                        
                        
                        
                        if(err==false)then
                          f=fs.open("disk/manualRdy","w")
                          f.write("ready for manual launch, frequency: " .. tostring(targetData.frequency))
                          peripheral.call("top","setFrequency",targetData.frequency)   
                          state=s.disk_rem               
                        end
                    end

                  end
                  
                  if(err==false)then                         
                    print("Waiting for launch ...")
                    state=s.waiting_for_launch
                  end
              else
                  
              
                  statusString="Error manual flag not found!"
                  print(statusString)
                  error=true 
                  state=s.disk_rem
              end
                
            else
              print("No target file! Remove disk!")
              status=fs.open("disk/err","w")
              status.write("No target file!")
              status.close()
              state=s.disk_rem
            end 
            
            if(err==true)then
              status=fs.open("disk/err","w")
              status.write(statusString)
              status.close()
              state=s.disk_rem
            end
            
        elseif(state==s.waiting_for_launch)then
            if(fs.exists("disk/launch"))then
                print("Launching!")
                peripheral.call("top", "launch")
                fs.delete("disk/launch")
                f=fs.open("disk/launchExec","w")
                f.write("launch Command Sent!")
                f.close()
                print("Remove Disk!");
                state=s.disk_rem
            end
        elseif(state==s.disk_rem)then
           --nothing check checkDisk
        else
            state=s.init        
        end
        
        os.sleep(0.1)
    end
end
main()
