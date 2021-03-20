# DataService API

## Error codes:
0 = NO ERROR.\
1 = DATA IS NILL. RETURNED DEFAULT DATA.\
2 = DATA IS NOT A TABLE.\
3 = FAILED "TRY" LOAD DATA. RETRY.\
4 = NEW DATA = CACHED DATA. DIDN'T SAVE.\
5 = DATA DOESN'T EXISTS IN CACHE.\
6 = NEW DATA IS NIL. DIDN'T SAVE.

## SetStore(user_id(*or player name*), new_data, save_mode)
SetStore saves data.
The third parameter is 'NORMAL' by default.

* Save mode *NORMAL*\
*NORMAL* save mode will save the data if the new data is NOT\
equal to the cached data, it is not *nil* and it is a table.
Example codes:
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local errorCode = DataService.SetStore(241669560, {testData=123}, "NORMAL")
print(errorCode) -- prints 0
```
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local errorCode = DataService.SetStore(241669560, nil, "NORMAL")
print(errorCode) -- prints 6
```
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local errorCode = DataService.SetStore(241669560, 123, "NORMAL")
print(errorCode) -- prints 2
```

* Save mode *FORCE*\
*FORCE* save mode will save the data every time, even if the data is *nil* or the data is not a table.
Example code:
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local errorCode = DataService.SetStore(241669560, {testData=123}, "FORCE")
print(errorCode) -- prints 0 (FORCE mode always returns 0)
```

## GetStore(user_id(*or player name*), default_data, load_mode)
GetStore loads data.
The third parameter is 'NORMAL' by default.
* Load mode *NORMAL*\
*NORMAL* load mode will return a table with an error code and the data in it.\
It will return data if the data is not *nil* and it is a table, if it is *nil* it will return the *default_data*.
Example code:
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local gotData = DataService.GetStore(241669560, {}, "NORMAL")
print(gotData.data)
print(gotData.ERROR_CODE)
```
* Load mode *TRY*\
*TRY* load mode will return a table with the number of tries and the data in it.\
This mode will keep trying to get the data until it gets something that is not nil and it is a table.
Example code:
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local gotData = DataService.GetStore(241669560, {}, "TRY")
print(gotData.data)
print(gotData.ERROR_CODE)
```
* Load mode *FORCE*\
*FORCE* load mode will return a table with the the data in it. It doesn't give you any error code.\
This mode will return the data even if it is nil or it is not a table.
Example code:
```lua
local DataService = require(game.ReplicatedStorage.DataService)
local gotData = DataService.GetStore(241669560, {}, "FORCE")
print(gotData.data)
print(gotData.ERROR_CODE)
```
## EraseStore(user_id(*or player name*))
EraseStore removes data.

## GetCachedStore(user_id(*or player name*))
GetCachedStore will get the data from the cache.
It will return the data if it is found in the cahce, if it is not found then it will return *nil*

## ViewStore(user_id(*or player name*), default_data, functionToRun, load_mode)
ViewStore is a complicated function. It will get a data every 15 secs.
The fourth parameter is 'NORMAL' by default.
Default data is works the same way as at GetData.
Load modes are the same as at GetData.
The only thing that you need to focus on is the functionToRun.
Example code:
```lua
local DataService = require(game.ReplicatedStorage.DataService)

function DataCheck(gotData) -- this function is going to be called every 15 seconds.
  print(gotData.data)
  print(gotData.ERROR_CODE)
end

DataService.ViewStore(241669560, {}, DataCheck, "NORMAL")

```
