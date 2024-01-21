
function love.load()

	size=60
    prob=0.1

	Rule={[0]=0,[1]=0,[2]=1,[3]=1,[4]=1,[5]=0,[6]=0,[7]=0,[8]=0}
	Cells = ARRAY2D(size,size)
	Cells = Init(Cells,prob)

end

function love.draw()

	love.graphics.setColor(255,255,255)

	for i,v in ipairs(Cells) do
		for j,w in ipairs(v) do
			x=i/size *800
			y=j/size *600

			if w==1 then
				love.graphics.setColor(255,255,255)
			elseif w==0 then
				love.graphics.setColor(0,0,0)
			end
			love.graphics.rectangle("fill",x,y,800/size,600/size)
		end
	end

end

function love.keypressed(key)

	if key=="escape" then
		love.event.push('quit')
	end
	if key=="return" then
		Cells = Init(Cells,prob)
	end

	if key=="kp+" then
		local oldCells=Cells
		size=math.floor(size*1.5)
		print(size)
		NewCells = ARRAY2D(size,size)
		for i,v in ipairs(oldCells) do
			for j,w in ipairs(v) do
				NewCells[i][j]=w
			end
		end
		Cells=NewCells

	elseif key=="kp-" then
		local oldCells=Cells
		size=math.floor(size/1.5)
		print(size)
		NewCells = ARRAY2D(size,size)
		for i,v in ipairs(NewCells) do
			for j,w in ipairs(v) do
				NewCells[i][j]=oldCells[i][j]
			end
		end
		Cells=NewCells
	end


	if 	key =="0" or
		key =="1" or
		key =="2" or
		key =="3" or
		key =="4" or
		key =="5" or
		key =="6" or
		key =="7" or
		key =="8" then

		Rule[tonumber(key)]= 1-Rule[tonumber(key)]
		for i,v in ipairs(Rule) do print(i,v) end
		print("-")
	end

end



function love.quit()
	print("The End")
	return false
end


function love.update(dt)

	love.timer.sleep(0.1)

	if not(love.keyboard.isDown("space")) then
		UpdateCells(Cells,Rule)
	else
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		local r = love.mouse.isDown(1)
		local l = love.mouse.isDown(2)
		local m = love.mouse.isDown(3)
		local typ=0
		local i = x/800 * size
		local j = y/600 * size
		i = math.floor(i)
		j = math.floor(j)

		if l or r or m then typ=1
		end

		Cells[i][j] =typ
		Cells[i-1][j] =typ
		Cells[i+1][j] =typ
		Cells[i][j-1] =typ
		Cells[i][j+1] =typ
	end

end


-----------------------------------------------


function ARRAY2D(w,h)
  local Cells = {w=w,h=h}
  local mt ={}

  mt.__index= function (table, key)
					local r
					if key < 1 then r= table[#table]
					else r= table[1]	end
					return r
				end
  setmetatable(Cells,mt)
  for y=1,h do
    Cells[y] = {}
	setmetatable(Cells[y],mt)
    for x=1,w do
      Cells[y][x]=0
    end
  end

  return Cells
end


function Init(t,p)
	local w,h = t["w"],t["h"]
	for i = 1,h do
		for j =1,w do
			v = math.random()
			if v<p then t[i][j]=1 end
		end
	end
	return t
end


function UpdateCells(t,Rule)
	local width,height = t["w"],t["h"]
	local temp = {w,h}
	local a,b,c,d,e,f,g,h = 0,0,0,0,0,0,0,0
	local Sel1 = {[1]=1}
	local mt ={}
	local s,typ, d1  =0,0,0

	for y=1,height do
		temp[y] = {}
		for x=1,width do
			temp[y][x]={typ=0,s=0}
		end
	end

	mt.__index = function (table,key) return 0 end
	setmetatable(Sel1,mt)

	for i =1,height do
		for j =1,width do
			a=t[i-1][j]
			b=t[i+1][j]
			c=t[i][j-1]
			d=t[i][j+1]
			e=t[i-1][j-1]
			f=t[i+1][j+1]
			g=t[i+1][j-1]
			h=t[i-1][j+1]

			d1=Sel1[a]+	Sel1[b]+ Sel1[c]+ Sel1[d] +
				Sel1[e]+ Sel1[f]+ Sel1[g]+ Sel1[h]

			s=d1
			typ=1

			temp[i][j].typ=typ
			temp[i][j].s=s
		end
	end

	for i =1,height do
		for j =1,width do
			t[i][j]=Rule[temp[i][j].s]*temp[i][j].typ
		end
	end


end


