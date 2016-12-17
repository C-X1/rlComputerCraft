function deleteIfExists(filename)
  if(fs.exists(filename)) then
      fs.delete(filename)
      
      print("Existing " .. filename .. " deleted.")
  end
end

function processList(list)
  for n1,e in pairs(list) do
  
    
   deleteIfExists(e[1])
   shell.run("pastebin get " .. e[2] .." ".. e[1] .."\n")
  end
end


local fileList=
{
  {"rlTurtle", "jc7qbrB3"}
 ,{"rlOccSense", "X84zRFWN"} 
 ,{"rlRedStone", "bVtMY3Na"} 
}

print("Welcome to RL installer/Updater")
 
processList(fileList)

print("Done!")