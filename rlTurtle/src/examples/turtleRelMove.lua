os.loadAPI("rlTurtle")
print("TEST")
local T = rlTurtle
local mv=T.mv
local function main()
  T.move(mv.front)
  T.move(mv.front)
  T.move(mv.front)
  T.move(mv.front)
  T.move(mv.front)
  T.move(mv.front)
  while (true) do
    print("----------")
    T.move(mv.tLeft)
        T.printCoordinates()
    T.move(mv.front)
        T.printCoordinates()
    os.sleep(1)
  end

end
main()