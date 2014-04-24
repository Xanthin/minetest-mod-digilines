-- Boilerplate to support localized strings if intllib mod is installed.
local S
if intllib then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local GET_COMMAND = "GET"

local rtc_nodebox =
{
	type = "fixed",
	fixed = {
		{ -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 }, -- bottom slab

		{ -7/16, -7/16, -7/16, 7/16, -5/16,  7/16 },
	}
}

local rtc_selbox =
{
	type = "fixed",
	fixed = {{ -8/16, -8/16, -8/16, 8/16, -3/16, 8/16 }}
}

local on_digiline_receive = function (pos, node, channel, msg)
	local setchan = minetest.get_meta(pos):get_string("channel")
	if channel == setchan and msg == GET_COMMAND then
		local timeofday = minetest.get_timeofday()
		digiline:receptor_send(pos, digiline.rules.default, channel, timeofday)
	end
end

minetest.register_node("digilines_rtc:rtc", {
	description = S("Digiline Real Time Clock (RTC)"),
	drawtype = "nodebox",
	tiles = {"digilines_rtc.png"},

	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=2},
	selection_box = rtc_selbox,
	node_box = rtc_nodebox,
	digiline = 
	{
		receptor = {},
		effector = {
			action = on_digiline_receive
		},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[channel;"..S("Channel")..";${channel}]")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if (fields.channel) then
			minetest.get_meta(pos):set_string("channel", fields.channel)
		end
	end,
})

minetest.register_craft({
	output = "digilines_rtc:rtc",
	recipe = {
		{"homedecor:plastic_sheeting", "digilines:wire_std_00000000", "homedecor:plastic_sheeting"},
		{"homedecor:plastic_sheeting","default:mese_crystal","homedecor:plastic_sheeting"},
		{"homedecor:plastic_sheeting","technic:battery","homedecor:plastic_sheeting"}
	}
})
