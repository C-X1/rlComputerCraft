
local start_state=
{
    init=0,
    no_disk=1,
    disk_load=2,
    waiting_for_launch=3,
    disk_rem=4
}

function load(name)
  local file = fs.open(name,"r")
  local data = file.readAll()
  file.close()
  return textutils.unserialize(data)
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


local function main()
    peripheral.call("front", "turnOn") 
    while  true  do
        checkDisk()
        if(state==s.init)then
            term.clear()
            print("Waiting for disk.")
            state=s.no_disk
        elseif(state==s.no_disk)then
            --nothing check checkDisk
        elseif(state==s.disk_load)then
            if(fs.exists("disk/target"))then
              print("Reading target file...")
              targetData=load("disk/target")
              print("Waiting for launch file...")
              state=s.waiting_for_launch
            else
              print("No target file! Remove disk!")
              status=fs.open("disk/ctrlStatus","w")
              status.write("No target file!")
              status.close()
              state=s.disk_rem
            end 
        elseif(state==s.waiting_for_launch)then
            if(fs.exists("disk/launch"))then
                print("Launching!")
                peripheral.call("top", "launch")
                fs.delete("disk/launch")
                f=fs.open("disk/ctrlStatus","w")
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
        
        os.sleep(1)
    end
end
main()
