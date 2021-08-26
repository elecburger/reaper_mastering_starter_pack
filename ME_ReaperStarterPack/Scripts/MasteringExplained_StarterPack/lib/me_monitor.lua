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

local mon = {}

mon.fxname = "AB Level Matching Control (TBProAudio) - ME Starter Pack mod"
mon.reffxname = "REF AB Level Matching Control (TBProAudio) - ME Starter Pack mod"

mon.param = {
	SourceSelect = 1,
	Autogain = 17,
	StereoMode = 25,
}

function mon.Set_monitor_param(param, value)
	if not param or not value then
		return false
	end

	local fxid = reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), mon.fxname, true, 0)

	if fxid < 0 then
		return false
	end

	reaper.TrackFX_SetParam(reaper.GetMasterTrack(0), fxid + 0x1000000, param, value)
	return true
end

function mon.Set_monitor_refparam(param, value)
	if not param or not value then
		return false
	end

	local reffxid = reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), mon.reffxname, true, 0)

	if reffxid < 0 then
		return false
	end

	reaper.TrackFX_SetParam(reaper.GetMasterTrack(0), reffxid + 0x1000000, param, value)
	return true
end

function mon.Get_monitor_param(param)
	if not param then
		return nil
	end

	local fxid = reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), mon.fxname, true, 0)

	if fxid < 0 then
		return nil
	end

	local value, _, _ = reaper.TrackFX_GetParam(reaper.GetMasterTrack(0), fxid + 0x1000000, param)
	return value
end

function mon.Get_monitor_refparam(param)
	if not param then
		return nil
	end

	local reffxid = reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), mon.reffxname, true, 0)

	if reffxid < 0 then
		return nil
	end

	local value, _, _ = reaper.TrackFX_GetParam(reaper.GetMasterTrack(0), reffxid + 0x1000000, param)
	return value
end

function mon.Update_command_states()
	local sourceselect = mon.Get_monitor_param(mon.param.SourceSelect)
	local refsource = mon.Get_monitor_refparam(mon.param.SourceSelect)

	local stereomode = mon.Get_monitor_param(mon.param.StereoMode)

	local master = 0
	local original = 0
	local reference = 0

	if refsource == 0 then
		reference = 1
	else
		if sourceselect == 0 then
			original = 1
		end
		if sourceselect == 1 then
			master = 1
		end
	end

	local autogain = 1
	if mon.Get_monitor_param(mon.param.Autogain) == 2 then
		autogain = 0
	end

	local stereo, mono, side, flip, left, right = 0, 0, 0, 0, 0, 0

	if stereomode == 0 then
		stereo = 1
	end
	if stereomode == 1 then
		mono = 1
	end
	if stereomode == 2 then
		side = 1
	end
	if stereomode == 3 then
		flip = 1
	end
	if stereomode == 4 then
		left = 1
	end
	if stereomode == 5 then
		right = 1
	end

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_MASTER")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), master)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_ORIGINAL")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), original)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_REFERENCE")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), reference)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_STEREO")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), stereo)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_SUM")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), mono)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_DIFF")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), side)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_FLIP")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), flip)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_LEFT")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), left)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_RIGHT")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), right)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))

	cmdid = reaper.NamedCommandLookup("_ME_STARTERPACK_MONITOR_AUTOGAIN")
	if cmdid and cmdid ~= "" then
		reaper.SetToggleCommandState(0, tonumber(cmdid), autogain)
	end
	reaper.RefreshToolbar2(0, tonumber(cmdid))
end

return mon
