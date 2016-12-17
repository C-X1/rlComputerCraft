print("Welcome to installer/Updater")
 
print("Checking for existing rlTurtle API")
print("\n")
if(fs.exists("rlTurtle")) then
    fs.delete("rlTurtle")
    print("deleted...\n\n")
end
 
if(fs.exists("rlOccSense")) then
    fs.delete("rlOccSense")
    print("deleted...\n\n")
end
 
print("Downloading new rlTurtle API...")
shell.run("pastebin get jc7qbrB3 rlTurtle")
 
print("Downloading new rlOccSense API...")
shell.run("pastebin get X84zRFWN rlOccSense")
 
--print("Cleaning myself up...\n")
--me=shell.getRunningProgram()
--fs.delete(me)
print("Done!")