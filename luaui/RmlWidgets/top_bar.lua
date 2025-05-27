if not RmlUi then
    return
end

local widget = widget ---@type Widget
function widget:GetInfo()
	return {
		name = "RmlUi v2 Top Bar Preview",
		desc = "Shows Resources and wind speed. RmlUi v2 edition",
		author = "mcukstorm",
		date = "2025",
		license = "BSD 3-Clause",
		layer = 0,
		handler = true,
		enabled = true
	}
end

local ArcProgressBar = VFS.Include("luaui/RmlCommon/arc_progress_bar.lua").ArcProgressBar --Pretty much required to use
local SkewBox = VFS.Include("luaui/RmlCommon/skew_box.lua").SkewBox --Makes life easier but not needed
local document --@type RmlUiDoc
local context

function widget:Initialize()
	document = context:LoadDocument("LuaUi/RmlWidgets/assets/top_bar.rml", widget)
	document:Show()

	local BuildPowerProgress = ArcProgressBar.new(document, "buildpower-progressbar")
	BuildPowerProgress
		:SetProgress(70)
		:SetInnerMarkerProgress(20)
		:SetOuterMarkerProgress(60)

	local MetalContainer = SkewBox.new(document, "metal-container")
	MetalContainer
		:SetMode(SkewBox.MODES.WARN)
		:SetLabelText("OVERFLOWING METAL")
		:ShowLabel()

	local EnergyContainer = SkewBox.new(document, "energy-container")
	EnergyContainer
		:SetMode(SkewBox.MODES.CRITICAL)
		:SetLabelText("WASTING ENERGY")
		:SetLabelPosition(SkewBox.LABEL_POSITION.RIGHT)
		:ShowLabel()
end

function widget:Shutdown()
	if document then
		document:Close()
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1, 19) == 'LobbyOverlayActive0' then
		document:Show()
	elseif msg:sub(1, 19) == 'LobbyOverlayActive1' then
		document:Hide()
	end
end


