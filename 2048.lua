tiles = {}
tiles[0] = Image.load("empty.png", VRAM)
tiles[1] = Image.load("2.png", VRAM)
tiles[2] = Image.load("4.png", VRAM)
tiles[3] = Image.load("8.png", VRAM)
tiles[4] = Image.load("16.png", VRAM)
tiles[5] = Image.load("32.png", VRAM)
tiles[6] = Image.load("64.png", VRAM)
tiles[7] = Image.load("128.png", VRAM)
tiles[8] = Image.load("256.png", VRAM)
tiles[9] = Image.load("512.png", VRAM)
tiles[10] = Image.load("1024.png", VRAM)
tiles[11] = Image.load("2048.png", VRAM)
tiles[12] = Image.load("4096.png", VRAM)
tiles[13] = Image.load("8192.png", VRAM)
tiles[14] = Image.load("16384.png", VRAM)
tiles[15] = Image.load("32768.png", VRAM)
tiles[16] = Image.load("65536.png", VRAM)
tiles[17] = Image.load("131072.png", VRAM)
bg = Image.load("bg.png", VRAM)
--The places the tiles can be in (15 in total for 4x4 grid)
field = {
0,0,0,0,
0,0,0,0,
0,0,0,0,
0,0,0,0}
merged_fields = {}
angle=0
function reset_moved_slots()
	for i=0,15 do
		merged_fields[i]=0
	end
end

function move_by_touch(sx,sy,ex,ey)
	dist=math.sqrt((ex-sx)^2+(ey-sy)^2)
	if (dist > 20) then
		angle = math.atan2(ex-sx,ey-sy)*180/math.pi
		if angle < 45 and angle > -45 then move_tiles(3)
		elseif angle < -45 and angle > -135 then move_tiles(0)
		elseif angle > 45 and angle < 135 then move_tiles(1)
		else move_tiles(2) end
	end
end

function spawn_tile()
	done=false
	attempts=0
	while not done do
		rand=math.random(0,15)
		if (field[rand] == 0) then
			if (math.random(0,10) == 5) then
				field[rand]=2
			else
				field[rand]=1
			end
			done=true
		end
		attempts=attempts+1
		if (attempts > 100) then
			for i=0,15 do
				if field[i] == 0 then
					field[i] = 1
					done=1
					break
				end
			end
			done=1
		end
	end
end

function move_tiles(dir)
	if dir == 0 then
		for k=0, 3, 1 do
			for j=4, 1, -1 do
				for i=2, j, 1 do
					if (field[i+4*k] == field[i-1+4*k] and field[i+4*k] ~= 0 and merged_fields[i+4*k] == 0 and merged_fields[i-1+4*k]) then
						field[i+4*k] = field[i+4*k]+1
						merged_fields[i+4*k]=1
						field[i-1+4*k] = 0
						moved=1
					end 
					if field[i-1+4*k] == 0 and field[i+4*k] > 0 then
						field[i-1+4*k] = field[i+4*k]
						merged_fields[i-1+4*k] = merged_fields[i+4*k]
						field[i+4*k] = 0
						merged_fields[i+4*k]=0
						moved=1
					end
				end
			end
		end
	elseif dir == 1 then
		for k=0, 3, 1 do
			for j=1, 3, 1 do
				for i=3, j, -1 do
					if (field[i+4*k] == field[i+1+4*k] and field[i+4*k] ~= 0 and merged_fields[i+4*k] == 0 and merged_fields[i+1+4*k]) then
						field[i+4*k] = field[i+4*k]+1
						merged_fields[i+4*k] = 1
						field[i+1+4*k] = 0
						moved=1
					end 
					if field[i+1+4*k] == 0 and field[i+4*k]  > 0 then
						field[i+1+4*k] = field[i+4*k]
						merged_fields[i+1+4*k] = merged_fields[i+4*k] 
						field[i+4*k] = 0
						merged_fields[i+4*k] = 0
						moved=1
					end
				end
			end
		end	
	elseif dir == 2 then
		for k=0, 3, 1 do
			for j=4, 2, -1 do
				for i=2, j,1 do
					iq=i*4;
					ie=i-1;
					iw=ie*4;
					if (field[iq-k] == field[iw-k] and field[iq-k] ~= 0 and merged_fields[iw-k] == 0 and merged_fields[iq-k] == 0) then
						field[iw-k] = field[iw-k]+1
						merged_fields[iw-k] = 1
						field[iq-k] = 0
						moved=1
					end
					if (field[iw-k] == 0 and field[iq-k]  > 0) then
						field[iw-k] = field[iq-k]
						merged_fields[iw-k] = merged_fields[iq-k]
						field[iq-k] = 0
						merged_fields[iq-k] = 0
						moved=1
					end
				end
			end
		end
	else
		for k=0, 3, 1 do
			for j=1, 3, 1 do
				for i=3,j,-1 do
					iq=i*4;
					ie=i+1;
					iw=ie*4;
					if (field[iq-k] == field[iw-k] and field[iq-k] ~= 0 and merged_fields[iw-k] == 0 and merged_fields[iq-k] == 0) then
						field[iw-k] = field[iq-k]+1;
						field[iq-k] = 0;
						moved=1
					end
					if (field[iw-k] == 0 and field[iq-k]  > 0) then
						field[iw-k] = field[iq-k];
						merged_fields[iw-k] = merged_fields[iq-k];
						field[iq-k] = 0;
						merged_fields[iq-k] = 0;
						moved=1
					end
				end
			end
		end
	end
	reset_moved_slots()
	if moved then spawn_tile() end
end
xoff=45
yoff=14
spawn_tile()
spawn_tile()
start_tx=0
start_ty=0
end_tx=0
end_ty=0

while not Keys.newPress.Start do
	Controls.read()
	if (Keys.newPress.Left) then
		move_tiles(0)
	elseif (Keys.newPress.Right) then
		move_tiles(1)
	elseif (Keys.newPress.Up) then
		move_tiles(2)
	elseif (Keys.newPress.Down) then
		move_tiles(3)
	end
	if Stylus.newPress then
		start_tx=Stylus.X
		start_ty=Stylus.Y
	end
	if Stylus.released then
		end_tx=Stylus.X
		end_ty=Stylus.Y
		move_by_touch(start_tx, start_ty, end_tx, end_ty)
	end
	screen.blit(SCREEN_DOWN, 0, 0, bg)
	for i=0, 3 do
		for j=0, 3 do
			screen.blit(SCREEN_DOWN, i*43+xoff, j*43+yoff, tiles[field[i+j*4+1]])
		end
	end
	screen.print(SCREEN_UP, 0, 184, "FPS: "..NB_FPS)
	screen.print(SCREEN_UP, 0, 0, "angle: " .. angle)
	
    render()
end
for i=0,15 do
	Image.destroy(tiles[i])
	tiles[i] = nil
	merged_fields[i] = nil
	field[i] = nil
	sx=nil
	sy=nil
	ex=nil
	ey=nil
	dist=nil
	angle=nil
end