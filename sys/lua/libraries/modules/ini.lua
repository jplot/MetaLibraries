meta = CreateMeta("Ini")

function ini.Open(file)
	local Table = meta
	
	Table.File = file.Read(file) or ""
	
	return Table
end

function meta:GetValue(block, key)
	local results = self:Parse()
	
	for k, v in pairs(results) do
		if (k == block) then
			for k2, v2 in pairs(v) do
				if (k2 == key) then return v2 end
			end
		end
	end
	
	return ""
end

-- Get Block.
function meta:GetBlock(block)
	local results = self:Parse()
	
	for k, v in pairs(results) do
		if (k == block) then return v end
	end
	
	return {}
end

function meta:Parse()
	if self.Results then return self.Results end
	self.Results = {}
	
	local current = ""
	local exploded = string.explode("\n", self.File)
	
	for k, v in pairs(exploded) do
		if (string.sub(v, 1, 1) != "#") then
			local line = string.trim(v)
			
			if (line != "") then
				if (string.sub(Line, 1, 1) == "[") then
					local _end = string.find(line, "%]")
					
					if (_end) then
						local block = string.sub(line, 2, _end - 1)
						
						self.Results[block] = self.Results[block] or {}
						current = block
					end
				else
					self.Results[current] = self.Results[current] or {}
					
					if (current != "") then
						line = string.explode("=", Line)
						
						if (table.Count(line) == 2) then
							local key = string.trim(line[1])
							local value = string.trim(line[2])
							
							self.Results[current][key] = value
						elseif (table.Count(line) == 1) then
							local value = string.trim(line[1])
							
							self.Results[current][#self.Results[current] + 1] = value
						end
					end
				end
			end
		end
	end
	
	return self.Results
end