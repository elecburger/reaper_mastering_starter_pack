-- The Mastering Explained Reaper Starter Pack
-- Copyright (C) 2021 Mastering Explained / Stockholm Mastering AB
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local info = debug.getinfo(1, "S")
local full_script_path = info.source
local script_path = full_script_path:sub(2, -5) -- remove "@" and "file extension" from file name
local script_dir = ""
if reaper.GetOS() == "Win64" or reaper.GetOS() == "Win32" then
	script_dir = script_path:match("(.*" .. "\\" .. ")")
else
	script_dir = script_path:match("(.*" .. "/" .. ")")
end
package.path = package.path .. ";" .. script_dir .. "?.lua"

rmsp = {}

function rmsp.SetConfig(key, value)
	return reaper.SetExtState("me_rmsp", key, value, true)
end

function rmsp.GetConfig(key)
	return reaper.GetExtState("me_rmsp", key)
end

function rmsp.IsInList(list, what)
	for _, val in pairs(list) do
		if val == what then
			return true
		end
	end
	return false
end

function string:split(inSplitPattern, outResults)
	if not outResults then
		outResults = {}
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	while theSplitStart do
		table.insert(outResults, string.sub(self, theStart, theSplitStart - 1))
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	end
	table.insert(outResults, string.sub(self, theStart))
	return outResults
end

function rmsp.SetMonitor(val)
	param = string.lower(val)

	local mon = require("lib/me_monitor")

	if param == "original" then
		mon.Set_monitor_param(mon.param.SourceSelect, 0)

		mon.Set_monitor_refparam(mon.param.SourceSelect, 1)
	end
	if param == "master" then
		mon.Set_monitor_param(mon.param.SourceSelect, 1)

		mon.Set_monitor_refparam(mon.param.SourceSelect, 1)
	end
	if param == "reference" then
		mon.Set_monitor_param(mon.param.SourceSelect, 1)

		mon.Set_monitor_refparam(mon.param.SourceSelect, 0)
	end
	if param == "stereo" then
		mon.Set_monitor_param(mon.param.StereoMode, 0)
	end
	if param == "mono" then
		mon.Set_monitor_param(mon.param.StereoMode, 1)
	end
	if param == "side" then
		mon.Set_monitor_param(mon.param.StereoMode, 2)
	end
	if param == "flip" then
		mon.Set_monitor_param(mon.param.StereoMode, 3)
	end
	if param == "left" then
		mon.Set_monitor_param(mon.param.StereoMode, 4)
	end
	if param == "right" then
		mon.Set_monitor_param(mon.param.StereoMode, 5)
	end

	if param == "autogain" then
		local ag = mon.Get_monitor_param(mon.param.Autogain)

		if ag == 2 then
			ag = 3
		else
			ag = 2
		end

		mon.Set_monitor_param(mon.param.Autogain, ag)

		mon.Set_monitor_refparam(mon.param.Autogain, ag)
	end

	mon.Update_command_states()
end

function rmsp.CreateRegionsFromItems()
	selitems = reaper.CountSelectedMediaItems(0)

	if selitems == 0 then
		return
	end

	retval, ret_csv = reaper.GetUserInputs("Regions from items", 2, "Pre-gap (s),Post-gap (s)", "0.2,2")

	if not retval then
		return
	end

	pregap, postgap = ret_csv:match("(.+),(.+)")
	cursor_pos = reaper.GetCursorPositionEx(0)
	time_sel_start, time_sel_end = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

	for n = 0, selitems - 1, 1 do
		local item = reaper.GetSelectedMediaItem(0, n)

		local take = reaper.GetActiveTake(item)
		_, take_name = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)

		take_name = take_name:gsub(".wav$", "")

		item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
		item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

		reaper.AddProjectMarker2(0, true, item_pos - pregap, item_pos + item_length + postgap, take_name or "", 1, 0)
	end

	reaper.SetEditCurPos2(0, cursor_pos, false, false)
	reaper.GetSet_LoopTimeRange2(0, true, false, time_sel_start, time_sel_end, false)
end

function rmsp.Startup()
	require("lib/me_monitor").Update_command_states()

	local current_version = rmsp.GetConfig("version")
	local new_version = rmsp.GetInfoFile("version")

	if current_version == "" then
		rmsp.NewInstall()
		rmsp.SetConfig("version", new_version)
	elseif current_version:gsub("%s", "") ~= new_version:gsub("%s", "") then
		rmsp.Update()
		rmsp.SetConfig("version", new_version)
	end
end

function rmsp.NewInstall()
	rmsp.About()
end

function rmsp.GetInfoFile(file)
	local filepath = script_dir .. file .. ".txt"
	if not reaper.file_exists(filepath) then
		filepath = script_dir .. "lib/" .. file .. ".txt"
		if not reaper.file_exists(filepath) then
			filepath = script_dir .. "MasteringExplained_StarterPack/lib/" .. file .. ".txt"
			if not reaper.file_exists(filepath) then
				return ""
			end
		end
	end

	io.input(filepath)
	local contents = io.read("*all")
	io.close()
	return contents
end

function rmsp.Update()
	local whatsnew = rmsp.GetInfoFile("whatsnew")
	reaper.MB(whatsnew, "Mastering Explained Starter Pack Updated!", 0)
end

function rmsp.About()
	local about = rmsp.GetInfoFile("about")
	local version = rmsp.GetInfoFile("version")
	reaper.MB(about, "Mastering Explained Starter Pack v" .. version:gsub("%s", ""), 0)
end

return rmsp
