
local DataStoreService = game:GetService('DataStoreService')
local user_data_store = DataStoreService:GetDataStore('DataService_DataStore')

local cache = {}

local module = {}

module.ERROR_CODES = {
	[0] = 'NO ERROR',
	[1] = 'DATA IS NILL. RETURNED DEFAULT DATA.',
	[2] = 'DATA IS NOT A TABLE.',
	[3] = 'FAILED "TRY" LOAD DATA. RETRY.',
	[4] = "NEW DATA = CACHED DATA. DIDN'T SAVE.",
	[5] = "DATA DOESN'T EXISTS IN CACHE.",
	[6] = "NEW DATA IS NIL. DIDN'T SAVE."
}

module.GetStore = function(user_id, default_data, ...)
	if typeof(user_id) == 'string' then
		user_id = game.Players:GetUserIdFromNameAsync(user_id)
	end
	user_id = tostring(user_id)
	local load_mode = ...
	if load_mode == nil then
		load_mode = 'NORMAL'
	end
	if load_mode == 'NORMAL' then
		local user_data = user_data_store:GetAsync(user_id)
		cache[tostring(user_id)] = user_data
		
		local returnData = {
			ERROR_CODE = 0,
			data = user_data
		}
		
		if user_data == nil then
			returnData.data = default_data
			returnData.ERROR_CODE = 1
			return returnData
		elseif typeof(user_data) == 'table' then
			return returnData
		elseif typeof(user_data) ~= 'table' then
			returnData.ERROR_CODE = 2
			return default_data
		end
	elseif load_mode == 'TRY' then
		local user_data = nil
		local returnData = {
			tries = 0,
			data = user_data,
		}
		local function loadData()
			user_data = user_data_store:GetAsync(user_id)
			
			returnData = {
				tries = returnData.tries + 1,
				data = user_data,
			}
			
			if user_data ~= nil and typeof(user_data) == 'table' then
				return returnData
			else
				print(module.ERROR_CODES[3])
				loadData()
			end
		end
		loadData()
		return returnData
	elseif load_mode == 'FORCE' then
		local user_data = user_data_store:GetAsync(user_id)
		cache[tostring(user_id)] = user_data

		local returnData = {
			data = user_data
		}

		return returnData
	end
	
end

module.SetStore = function(user_id, new_data, ...)
	if typeof(user_id) == 'string' then
		user_id = game.Players:GetUserIdFromNameAsync(user_id)
	end
	user_id = tostring(user_id)
	local save_mode = ...
	if save_mode == nil then
		save_mode = 'NORMAL'
	end
	if save_mode == 'NORMAL' then
		if new_data == nil then
			return 6
		end
		if typeof(new_data) ~= 'table' then
			return 2
		end
		if new_data ~= cache[user_id] then
			user_data_store:SetAsync(user_id, new_data)
			return 0
		else
			return 4
		end
	elseif save_mode == 'FORCE' then
		user_data_store:SetAsync(user_id, new_data)
		return 0
	end
end

module.EraseStore = function(user_id)
	if typeof(user_id) == 'string' then
		user_id = game.Players:GetUserIdFromNameAsync(user_id)
	end
	user_id = tostring(user_id)
	user_data_store:RemoveAsync(user_id)
end

module.GetCachedStore = function(user_id)
	if typeof(user_id) == 'string' then
		user_id = game.Players:GetUserIdFromNameAsync(user_id)
	end
	user_id = tostring(user_id)
	if cache[user_id] ~= nil then
		return cache[user_id]
	else
		return 5
	end
end

module.ViewStore = function(user_id, default_data, func, ...)
	func(module.GetStore(user_id, default_data, ...))
	while wait(15) do
		func(module.GetStore(user_id, default_data, ...))
	end
end

return module
