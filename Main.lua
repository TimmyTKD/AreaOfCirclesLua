-- This code was originally made in Javascript, so I need to use an Array library for the code to work properly
-- To setup the library, create a new Module Script called "Array" and copy the code from the following link to it: https://raw.githubusercontent.com/HuotChu/ArrayForLua/master/Array.lua

local Array = require(game.ReplicatedStorage.Array) -- Path to the "Array" Module Script
local PI = math.pi;


--------------------------------------------------------
--  Drawing Settings (for visualization / debugging)  --
--------------------------------------------------------

local drawCircles = false
local drawingHeight = 25

local drawingIndex = 0

--------------------------------------------



local circles = {
	{pos = Vector2.new(2, 0), radius = 2},
	
	{pos = Vector2.new(0, 0), radius = 1},
	{pos = Vector2.new(4, 0), radius = 1},
	
	{pos = Vector2.new(2, 2), radius = 1},
	{pos = Vector2.new(2, -2), radius = 1},
}




--[[----------------------------------------[[--

			      Functions

--]]----------------------------------------]]--





function drawBackground(width, height)
	local part = Instance.new("Part")
	part.Size = Vector3.new(width, height, 0.1)
	part.Anchored = true
	part.Parent = workspace
	part.CanCollide = false
	part.BrickColor = BrickColor.White()
	part.Position = Vector3.new(0, drawingHeight, -0.03)
end

function drawCircle(x, y, r, color, transparency)
	if (not color) then
		color = BrickColor.Black()
	end

	if (not transparency) then
		transparency = 0.5
	end

	drawingIndex += 0.01

	for i = 1, 360, 1 do
		local deg = math.rad(i)
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.1, 0.1, 0.1)
		part.Anchored = true
		part.Parent = workspace
		part.CanCollide = false
		part.BrickColor = color
		part.Transparency = transparency

		part.Position = Vector3.new(x + math.cos(deg) * r, drawingHeight + y + math.sin(deg) * r, drawingIndex)
	end
end

function drawLine(pointA, pointB, color)
	local x1 = pointA.x
	local y1 = drawingHeight + pointA.y
	local x2 = pointB.x
	local y2 = drawingHeight + pointB.y

	local dist = math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))

	if (not color) then
		color = BrickColor.DarkGray()
	end

	local line = Instance.new("Part")
	line.Name = "Line"
	line.Anchored = true
	line.Parent = workspace
	line.CanCollide = false
	line.Color = color

	line.Size = Vector3.new(dist, 0.3, 0.1)
	line.Position = Vector3.new((x1 + x2) / 2, (y1 + y2) / 2, 0.05 + drawingIndex)
	line.Rotation = Vector3.new(0, 0, math.atan2(y2 - y1, x2 - x1) * (180 / math.pi))
end

function drawShape(points)
	local r = math.random(50, 180)
	local b = math.random(50, 180)
	local g = math.random(50, 180)

	drawingIndex += 0.01

	local color = Color3.new(r, g, b)
	for i = 1, points:Length(), 1 do
		local pointA = points[i]
		local pointB = points[arrayMod(i + 1, points:Length())]

		drawLine(pointA, pointB, color)
	end
end



function arrayMod(index, length) 
	local newIndex = (index % (length + 1))
	if (index > length) then
		newIndex += 1
	end
	return newIndex
end

function inter(A,B)
	local X1 = A.x
	local Y1 = A.y
	local R1 = A.r

	local X2 = B.x
	local Y2 = B.y
	local R2 = B.r

	local Pi = PI;
	local d, alpha, beta, a1, a2;
	local ans;

	d = math.sqrt((X2 - X1) * (X2 - X1) + (Y2 - Y1) * (Y2 - Y1));

	if (d > R1 + R2) then
		ans = 0;

	elseif (d <= (R1 - R2) and R1 >= R2) then
		ans = Pi * R2 * R2;

	elseif (d <= (R2 - R1) and R2 >= R1) then
		ans = Pi * R1 * R1;

	else
		alpha = math.acos((R1 * R1 + d * d - R2 * R2) / (2 * R1 * d)) * 2;
		beta = math.acos((R2 * R2 + d * d - R1 * R1) / (2 * R2 * d)) * 2;
		a1 = 0.5 * beta * R2 * R2 - 0.5 * R2 * R2 * math.sin(beta);
		a2 = 0.5 * alpha * R1 * R1 - 0.5 * R1 * R1 * math.sin(alpha);
		ans = a1 + a2;
	end

	return ans;
end

function clamp(value, min, max)
	if (value > max) then
		value = max;
	end

	if (value < min) then
		value = min;
	end

	return value;
end

function sliceArray(arr, chunkSize)
	local res = Array({});

	for i = 1, arr:Length(), chunkSize do
		local chunk = arr:Slice(i, i + chunkSize);
		res:Push(chunk);
	end

	return res;
end

function calcArea(coords)
	local area = 0;

	for i = 1, coords:Length(), 1 do
		local x1 = coords[i].x;
		local y1 = coords[i].y;

		local x2 = coords[arrayMod((i + 1), coords:Length())].x;
		local y2 = coords[arrayMod((i + 1), coords:Length())].y;

		area += x1 * y2 - x2 * y1
	end

	return area / 2;
end

function sameShapes(A, B)
	if (A:Length() ~= B:Length()) then
		return false;
	end

	local same = true;

	for i = 1, A:Length(), 1 do
		if (A[i].x == B[i].x and A[i].y == B[i].y and A[i].r == B[i].r) then
			continue;
		else
			same = false;
			break;
		end
	end

	return same;
end

function interP(c1, c2)
	local result = Array({
		intersect_count = 0,
		intersect_occurs = true,
		one_is_in_other = false,
		are_equal = false,
		p1 = Array({ x = nil, y = nil }),
		p2 = Array({ x = nil, y = nil })
	});

	local dx = c2.x - c1.x;
	local dy = c2.y - c1.y;

	local dist = math.sqrt(math.pow(dy, 2) + math.pow(dx, 2));

	if (dist > c1.r + c2.r) then
		result.intersect_occurs = false;
	end

	if (dist < math.abs(c1.r - c2.r)) then
		result.intersect_occurs = false;
		result.one_is_in_other = true;
	end

	if (c1.x == c2.x and c1.y == c2.y and c1.r == c2.r) then
		result.are_equal = true;
		result.are_equal = true;
	end

	if (result.intersect_occurs) then
		local centroid = (c1.r * c1.r - c2.r * c2.r + dist * dist) / (2 * dist);

		local x2 = c1.x + (dx * centroid) / dist;
		local y2 = c1.y + (dy * centroid) / dist;

		local h = math.sqrt(c1.r * c1.r - centroid * centroid);

		local rx = -dy * (h / dist);
		local ry = dx * (h / dist);

		result.p1.x = (x2 + rx);
		result.p1.y = (y2 + ry);

		result.p2.x = (x2 - rx);
		result.p2.y = (y2 - ry);

		if (result.are_equal) then
			result.intersect_count = nil;
		elseif (result.p1.x == result.p2.x and result.p1.y == result.p2.y) then
			result.intersect_count = 1;
		else
			result.intersect_count = 2;
		end
	end

	return result;
end

function sortPoints(points)
	local centerP = points:Reduce(function (acc, p)
		acc.x += p.x / points:Length();
		acc.y += p.y / points:Length();
		return acc;
	end, Array({ x = 0, y = 0 }));

	local angles = points:Map(function (p)
		return Array({ x = p.x, y = p.y, angle = math.atan2(p.y - centerP.y, p.x - centerP.x) * 180 / PI });
	end);

	local sorted = angles:Sort(function (a, b) return a.angle < b.angle end);

	local final = Array({});

	for i = 1, sorted:Length(), 1 do
		final:Push(Array({x = sorted[i].x, y = sorted[i].y}));
	end

	return final;
end

function sortCircles(points)
	local centerP = points:Reduce(function (acc, p)
		acc.x += p.x / points:Length();
		acc.y += p.y / points:Length();
		acc.r = p.r;
		return acc;
	end, Array({ x = 0, y = 0, r = 0 }));

	local angles = points:Map(function (p)
		return Array({ x = p.x, y = p.y, r = p.r, angle = math.atan2(p.y - centerP.y, p.x - centerP.x) * 180 / PI });
	end);

	local sorted = angles:Sort(function (a, b) return a.angle < b.angle end);

	local final = Array({});

	for i = 1, sorted:Length(), 1 do
		final:Push(Array({x = sorted[i].x, y = sorted[i].y, r = sorted[i].r}));
	end

	return final;
end

function roundNumber(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end






--[[----------------------------------------[[--

			      Main Code

--]]----------------------------------------]]--






if (drawCircles) then
	drawBackground(150, 150)
end


local circlesF = Array({})

for i = 1, #circles, 1 do
	if (circlesF:Filter(function(e) return e.x == circles[i].pos.X and e.y == circles[i].pos.Y and e.r == circles[i].radius end):Length() == 0) then
		circlesF:Push(Array({x = circles[i].pos.X, y = circles[i].pos.Y, r = circles[i].radius}))
	end
end

circlesF = sortCircles(circlesF);

local specialCircles = Array({});

local pointsC = Array({});
local pointsI = Array({});

for i = 1, circlesF:Length(), 1 do
	local circ = circlesF[i];

	local connected = false;

	local intersects = Array({});

	pointsC:Push(Array({x = circ.x, y = circ.y, i = Array({}), r = circ.r}));

	local occluded = false;

	for j = 1, circlesF:Length(), 1 do
		if (not(circ.x == circlesF[j].x and circ.y == circlesF[j].y and circ.r == circlesF[j].r)) then
			local circ2 = circlesF[j];
			local interPoints = interP(circ, circ2);
			local interA = inter(circ, circ2);


			if (interA == PI * math.pow(circ.r, 2)) then
				occluded = true;
				pointsC:Splice(pointsC:IndexOf(pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1]), 1);
				break;
			end

			if (interA == PI * math.pow(circ2.r, 2)) then
				continue;
			end

			if (interPoints.intersect_occurs) then
				connected = true;
				intersects:Push(circ2);
			end

			if (interPoints.intersect_count == 0) then
				continue;
			end


			local inside1 = false;
			for k = 1, circlesF:Length(), 1 do
				if (k ~= i and k ~= j) then
					local circ3 = circlesF[k];

					local d = math.sqrt(math.pow(circ3.x - interPoints.p1.x, 2) + math.pow(circ3.y - interPoints.p1.y, 2));

					if (d < circ3.r) then
						inside1 = true;
						break;
					end
				end
			end

			if (not inside1 and pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1]) then
				pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1].i:Push(Array({x = interPoints.p1.x, y = interPoints.p1.y, r = circ.r, c2 = circ2}));

				if (pointsI:Filter(function(e) return e.x == interPoints.p1.x and e.y == interPoints.p1.y end):Length() == 0) then
					pointsI:Push(Array({x = interPoints.p1.x, y = interPoints.p1.y, c1 = i < j and circ or circ2, c2 = i < j and circ2 or circ}));
				end
			end

			local inside2 = false;

			for k = 1, circlesF:Length(), 1 do
				if (k ~= i and k ~= j) then
					local circ3 = circlesF[k];

					local d = math.sqrt(math.pow(circ3.x - interPoints.p2.x, 2) + math.pow(circ3.y - interPoints.p2.y, 2));

					if (d < circ3.r) then
						inside2 = true;
						break;
					end
				end
			end

			if (not inside2) then
				pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1].i:Push(Array({x = interPoints.p2.x, y = interPoints.p2.y, r = circ.r, c2 = circ2}));

				if (pointsI:Filter(function(e) return e.x == interPoints.p2.x and e.y == interPoints.p2.y end):Length() == 0) then
					pointsI:Push(Array({x = interPoints.p2.x, y = interPoints.p2.y, c1 = i < j and circ or circ2, c2 = i < j and circ2 or circ}));
				end
			end
		end
	end

	if (occluded) then
		continue;
	end

	if (connected and pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1] and pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1].i:Length() == 0) then
		pointsC:Splice(pointsC:IndexOf(pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1]), 1);
		continue;
	end

	if (intersects:Length() > 2 and pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1]) then
		specialCircles:Push(Array({x = circ.x, y = circ.y, r = circ.r, i = pointsC:Filter(function(e) return e.x == circ.x and e.y == circ.y end)[1].i, i2 = intersects}));
	end

	if (drawCircles) then
		drawCircle(circ.x, circ.y, circ.r)
	end
end

local newSpecialCircs = Array({});

specialCircles:Sort(function (a,b) return a.r == b.r and a.i2:Length() > b.i2:Length() or a.r < b.r end);

for i10 = 1, specialCircles:Length(), 1 do
	local circ = specialCircles[i10];
	local stop = false;

	for c1 = 1, circ.i2:Length(), 1 do
		local circ2 = pointsC:Filter(function(e) return e.x == circ.i2[c1].x and e.y == circ.i2[c1].y end)[1];

		if (not circ2) then
			continue;
		end


		local found = false;
		for circP = 1, circ.i2:Length(), 1 do
			local circ3 = circ.i2[circP];

			if (not circ3) then
				continue;
			end

			if (not (circ.i2:Filter(function(e) return interP(circ2, e).intersect_occurs and not(e.x == circ2.x and e.y == circ2.y) and not(e.x == circ3.x and e.y == circ3.y) end):Length() > 0 or circ.i2:Filter(function(e) return interP(circ3, e).intersect_occurs and not(e.x == circ2.x and e.y == circ2.y) and not(e.x == circ3.x and e.y == circ3.y) end):Length() > 0)) then
				continue;
			end

			if (interP(circ2, circ3).intersect_occurs and not(circ3.x == circ2.x and circ3.y == circ2.y)) then
				found = true;
				break;
			end
		end

		if (not found) then
			stop = true;
			break;
		end
	end

	for cir = 1, newSpecialCircs:Length(), 1 do
		local circ2 = newSpecialCircs[cir];

		if (not circ2) then
			continue;
		end

		if (circ2.i2:Filter(function(e) return e.x == circ.x and e.y == circ.y end):Length() > 0) then
			stop = true;
			break;
		end
	end

	if (stop) then
		continue;
	end

	newSpecialCircs:Push(circ);

	if (drawCircles) then
		drawCircle(circ.x, circ.y, circ.r + 0.01, BrickColor.Blue(), 0)
	end
end

specialCircles = newSpecialCircs;

circlesF = sortCircles(circlesF);

for i = 1, specialCircles:Length(), 1 do
	local circ = specialCircles[i];

	for c = 1, pointsC:Length(), 1 do
		local circ2 = pointsC[c];

		if (circ2.i:Length() == 2 and not(circ.x == circ2.x and circ.y == circ2.y) and circ.i2:Filter(function(e) return e.x == circ2.x and e.y == circ2.y end):Length() == 0) then
			if (circ2.i:Filter(function(e) return circ.i2:Filter(function(f) return f.x == e.c2.x and f.y == e.c2.y end):Length() > 0 end):Length() == 2) then
				circ.i2:Push(circ2);
			end
		end
	end
end

local total = 0;

local shapes = Array({});
local shapePoints = Array({});

local first = false;
for i = 1, pointsC:Length(), 1 do
	local point1 = pointsC[i];
	local connectedP = point1.i:Filter(function(e) return e.x ~= nil and e.y ~= nil end);

	local groupedP = sliceArray(connectedP, 2);


	if (connectedP:Length() > 0) then
		for i3 = 1, groupedP:Length(), 1 do
			local point2 = groupedP[i3];

			local specialConnect = false;

			for spec = 1, specialCircles:Length(), 1 do
				local special = specialCircles[spec];

				if (special.i2:Filter(function(e) return e.x == point1.x and e.y == point1.y end):Length() > 0 and (special.i2:Filter(function(e) return e.x == point2[1].c2.x and e.y == point2[1].c2.y end):Length() > 0 or special.i2:Filter(function(e) return e.x == point2[2].c2.x and e.y == point2[2].c2.y end):Length() > 0)) then
					specialConnect = true;
					break;
				end
			end

			if (specialConnect) then
				continue;
			end

			local specialMain = nil;

			for spec = 1, specialCircles:Length(), 1 do
				local special = specialCircles[spec];

				if (special.x == point1.x and special.y == point1.y) then
					specialMain = special;
					break;
				end
			end

			if (specialMain) then
				local shape = Array({});

				shape:Push(specialMain.i[1]);
				shape:Push(specialMain.i[2]);

				for specP = 1, specialMain.i2:Length(), 1 do
					if (specialMain.i2[specP]) then
						local specPoint = pointsC:Filter(function(e) return e.x == specialMain.i2[specP].x and e.y == specialMain.i2[specP].y end)[1];

						if (not specPoint) then
							continue;
						end

						for specP2 = 1, specPoint.i:Length(), 1 do
							local specPointI = specPoint.i[specP2];
							local count = 0;

							if (specialMain.i2:Filter(function(e) return specPointI.c2.x == e.x and specPointI.c2.y == e.y end):Length() > 0) then
								shape:Push(specPointI);
								count += 1
							end

							if (count < 1) then
								shape:Push(specPoint);
							end
						end
					end
				end 

				shape:Sort(function(a, b)
					return a.x == b.x and a.y < b.y or a.x < b.x;
				end);

				local newShape = Array({})
				for point = 1, shape:Length(), 1 do
					if (newShape:Filter(function(e) return e.x == shape[point].x and e.y == shape[point].y end):Length() == 0) then
						newShape:Push(shape[point])
					end
				end

				shape = newShape

				shape:Sort(function(a, b)
					return a.x == b.x and a.y < b.y or a.x < b.x;
				end);

				shape = sortPoints(shape);

				local index = 0;

				for specP = 1, specialMain.i2:Length(), 1 do
					if (specialMain.i2[specP]) then
						local specPoint = pointsC:Filter(function(e) return e.x == specialMain.i2[specP].x and e.y == specialMain.i2[specP].y end)[1];

						local specPointIs = Array({});

						if (not specPoint) then
							continue;
						end

						for specP3 = 1, specPoint.i:Length(), 1 do
							local specPointI = specPoint.i[specP3];

							if (specialMain.i2:Filter(function(e) return specPointI.c2.x == e.x and specPointI.c2.y == e.y end):Length() > 0) then
								specPointIs:Push(specPointI);
							end
						end

						if (specPointIs:Length() == 2 and specPoint.i:Length() == 2) then
							local p1 = shape:IndexOf(shape:Filter(function(e) return e.x == specPointIs[1].x and e.y == specPointIs[1].y end)[1]);
							local p2 = shape:IndexOf(shape:Filter(function(e) return e.x == specPointIs[2].x and e.y == specPointIs[2].y end)[1]);

							index = p2 > p1 and 1 or 2;

							if (p2 <= shape:Length() and p2 > shape:Length() - 3 and p1 < 3) then
								index = 2;
							end

							if (p1 <= shape:Length() and p1 > shape:Length() - 3 and p2 < 3) then
								index = 1;
							end

							shape:Splice(shape:IndexOf(shape:Filter(function(e) return e.x == specPointIs[index].x and e.y == specPointIs[index].y end)[1]), 0, specPoint);
						end
					end
				end

				index = arrayMod((shape:IndexOf(shape:Filter(function(e) return e.x == specialMain.i[1].x and e.y == specialMain.i[1].y end)[1]) + 1), shape:Length()) > arrayMod((shape:IndexOf(shape:Filter(function(e) return e.x == specialMain.i[2].x and e.y == specialMain.i[2].y end)[1]) + 1), shape:Length()) and 2 or 1;

				shape:Splice(shape:IndexOf(shape:Filter(function(e) return e.x == specialMain.i[index].x and e.y == specialMain.i[index].y end)[1]), 0, point1);

				local exists = false;

				for sh = 1, shapes:Length(), 1 do
					if (sameShapes(shapes[sh], shape)) then
						exists = true;
						break;
					end
				end

				if (shape:Length() > 2 and not exists) then
					shapes:Push(shape); 

					for p4 = 1, shape:Length(), 1 do
						shapePoints:Push(shape[p4]);
					end
				end

				continue;
			end

			if (groupedP:Length() > 1 and (pointsC:IndexOf(pointsC:Filter(function(e) return e.x == point2[1].c2.x and e.y == point2[1].c2.y and e.r == point2[1].c2.r end)[1]) > i) or (pointsC:IndexOf(pointsC:Filter(function(e) return e.x == point2[2].c2.x and e.y == point2[2].c2.y and e.r == point2[2].c2.r end)[1]) > i)) then
				
				local shape = Array({});
				shape:Push(point1);

				local sortCenter = (point2[1].c2.x == point2[2].c2.x and point2[1].c2.y == point2[2].c2.y);

				if (sortCenter) then
					if ((math.abs(point1.x - point2[1].c2.x) > math.abs(point2[1].x - point2[1].c2.x) and math.abs(point1.x - point2[1].c2.x) > math.abs(point2[2].x - point2[1].c2.x)) or (math.abs(point1.y - point2[1].c2.y) > math.abs(point2[1].y - point2[1].c2.y) and math.abs(point1.y - point2[1].c2.y) > math.abs(point2[2].y - point2[1].c2.y))) then
						sortCenter = false;
					end
				end
				
				print(sortCenter)
				
				if (not sortCenter) then
					shape:Push(point2[1].c2);
					shape:Push(point2[2].c2);
				end

				shape:Push(point2[1]);
				shape:Push(point2[2]);

				shape:Sort(function(a, b)
					return a.x == b.x and a.y < b.y or a.x < b.x;
				end);

				local newShape = Array({})
				for point = 1, shape:Length(), 1 do
					if (newShape:Filter(function(e) return e.x == shape[point].x and e.y == shape[point].y end):Length() == 0) then
						newShape:Push(shape[point])
					end
				end

				shape = newShape

				shape:Sort(function(a, b)
					return a.x == b.x and a.y < b.y or a.x < b.x;
				end);

				if (sortCenter) then
					shape = sortPoints(shape);

					local p1 = shape:IndexOf(shape:Filter(function(e) return e.x == point2[1].x and e.y == point2[1].y end)[1]);
					local p2 = shape:IndexOf(shape:Filter(function(e) return e.x == point2[2].x and e.y == point2[2].y end)[1]);


					local index = p1 > p2 and 1 or 2;

					if (p1 <= shape:Length() and p1 > shape:Length() - 3 and p2 < 3) then
						index = 1;
					end

					if (p2 <= shape:Length() and p2 > shape:Length() - 3 and p1 < 3) then
						index = 2;
					end

					shape:Splice(shape:IndexOf(shape:Filter(function(e) return e.x == point2[index].x and e.y == point2[index].y end)[1]), 0, point2[1].c2);

					shape:Splice(0, 0, "skip")
				end

				local exists = false;

				for sh = 1, shapes:Length(), 1 do
					if (sameShapes(shapes[sh], shape)) then
						exists = true;
						break;
					end
				end

				if (shape:Length() > 2 and not exists) then
					shapes:Push(shape); 

					for p1 = 1, shape:Length(), 1 do
						shapePoints:Push(shape[p1]);
					end
				end
			end
		end
	end


	local angle = 2 * PI;

	if (connectedP:Length() > 0) then
		for j = 1, groupedP:Length(), 1 do
			if (groupedP[j][1].c2 ~= groupedP[j][2].c2 and groupedP[arrayMod((j + 1), groupedP:Length())][1].c2 ~= groupedP[arrayMod((j + 1), groupedP:Length())][2].c2) then
				local distP = math.sqrt(math.pow(groupedP[j][1].x - groupedP[j][2].x, 2) + math.pow(groupedP[j][1].y - groupedP[j][2].y, 2));
				local sectorAngle = 2 * math.asin(clamp((distP / 2) / point1.r, -1, 1));
				angle = sectorAngle;
				break;
			else
				local distP = math.sqrt(math.pow(groupedP[j][1].x - groupedP[j][2].x, 2) + math.pow(groupedP[j][1].y - groupedP[j][2].y, 2));
				local sectorAngle = 2 * math.asin(clamp((distP / 2) / point1.r, -1, 1));
				angle -= sectorAngle;
			end
		end
	end

	local radius = point1.r;
	total += math.abs(((angle * 180 / PI) / 360) *  PI * math.pow(radius, 2));

end

local pairKeys = Array({});
shapes = shapes:Reverse();

for i = 1, shapes:Length(), 1 do
	local shape = shapes[i];
	local skipSort = shape:Includes("skip");

	if (skipSort) then
		shape:Splice(shape:IndexOf("skip"), 1);
		shapePoints:Splice(shapePoints:IndexOf("skip"), 1)
	end

	if (pointsC:Length() < 3 or shape:Filter(function(e) return specialCircles:Filter(function(f) return f.x == e.x and f.y == e.y end):Length() > 0 end):Length() > 0) then
		if (pointsC:Length() < 3 and not skipSort) then
			shape = sortPoints(shape);
		end

		if (drawCircles) then
			drawShape(shape)
		end

		continue;
	end

	local cPoint = shape:Filter(function(e) return pointsC:Filter(function(f) return f.x == e.x and f.y == e.y end)[1] and pointsC:Filter(function(f) return f.x == e.x and f.y == e.y end)[1].i:Length() == 2 end)[1];

	if (cPoint) then
		local ccPoint = pointsC:Filter(function(e) return e.x == cPoint.x and e.y == cPoint.y end)[1];
		for c = 1, 2, 1 do
			if (shape:Filter(function(e) return roundNumber(e.x, 14) == roundNumber(ccPoint.i[c].x, 14) and roundNumber(e.y, 14) == roundNumber(ccPoint.i[c].y, 14) end):Length() == 0 and shapePoints:Filter(function(e) return roundNumber(e.x, 14) == roundNumber(ccPoint.i[c].x, 14) and roundNumber(e.y, 14) == roundNumber(ccPoint.i[c].y, 14) end):Length() == 0) then

				shape:Push(ccPoint.i[c]);
				shapePoints:Push(ccPoint.i[c]);
			end
		end
	end

	if (not skipSort) then
		shape:Sort(function(a, b)
			return a.x == b.x and a.y < b.y or a.x < b.x;
		end);

		if (cPoint) then
			local ccPoint = pointsC:Filter(function(e) return e.x == cPoint.x and e.y == cPoint.y end)[1];
			local sPoint = shape:Filter(function(e) return e.x == ccPoint.i[1].x and e.y == ccPoint.i[1].y end)[1];
			local sPoint2 = shape:Filter(function(e) return e.x == ccPoint.i[2].x and e.y == ccPoint.i[2].y end)[1];

			if (sPoint and sPoint2) then
				if (math.abs(shape:IndexOf(sPoint) - shape:IndexOf(sPoint2)) == 1) then
					shape:Swap(shape:IndexOf(sPoint2), shape:IndexOf(cPoint))
				end
			end
		end

		local outside = Array({});
		local exclude = sortPoints(shape);

		local started = Array({});

		for pA = 1, shape:Length(), 1 do
			local found = false;
			local skip = false;

			for i1 = 1, shapes:Length(), 1 do
				if (shapes[i1] == shape) then
					continue;
				end

				if (not pairKeys:Includes(math.pow(i,2) + math.pow(i1,2))) then
					pairKeys:Push(math.pow(i,2) + math.pow(i1,2));
					started:Push(i1);
				end

				if (shapes[i1] ~= shape and shapes[i1]:Filter(function(e) return e.x == shape[pA].x and e.y == shape[pA].y end):Length() > 0) then
					found = true;
					break;
				end

				if (started:Includes(i1)) then
					skip = true;
				end
			end

			if (not found) then
				outside:Push(shape[pA]);
				exclude:Splice(exclude:IndexOf(exclude:Filter(function(e) return e.x == shape[pA].x and e.y == shape[pA].y end)[1]), 1);
			end

			if (skip) then
				exclude:Splice(exclude:IndexOf(exclude:Filter(function(e) return e.x == shape[pA].x and e.y == shape[pA].y end)[1]), 1);
			end
		end

		shape = sortPoints(shape);

		local l = outside:Length();

		for pB = 1, l, 1 do
			local index = shape:IndexOf(shape:Filter(function(e) return e.x == outside[pB].x and e.y == outside[pB].y end)[1]);

			exclude:Splice(exclude:IndexOf(exclude:Filter(function(e) return e.x == shape[arrayMod((index + 1), shape:Length())].x and e.y == shape[arrayMod((index + 1), shape:Length())].y end)[1]), 1);
		end

		for pC = 1, exclude:Length(), 1 do
			shape:Splice(shape:IndexOf(shape:Filter(function(e) return e.x == exclude[pC].x and e.y == exclude[pC].y end)[1]), 1);
		end

		shape = sortPoints(shape);
	end

	shapes[i] = shape;

	if (drawCircles) then
		drawShape(shape)
	end
end



for i = 1, shapes:Length(), 1 do
	local shape = shapes[i];

	local pointsSorted = shape;

	if (pointsC:Length() < 3) then
		pointsSorted = sortPoints(shape);
	end

	local n = pointsSorted:Length();
	local j = n;

	local a = 0;
	
	for i2 = 1, n, 1 do
		if (true) then
			a += (pointsSorted[j].x + pointsSorted[i2].x) * (pointsSorted[j].y - pointsSorted[i2].y);
		end
		j = i2;
	end

	total += math.abs(a / 2);
end


local area = total;
print("Total area: " .. area);
