function ifNil( cond , fallback )
    if cond==nil then return fallback else return cond end
end

ArcProgressBar = {}
ArcProgressBar.__index = ArcProgressBar
function ArcProgressBar.new(document, rootElementId)
    local self = setmetatable({rootId = rootElementId, percent = 0, markers = { inner = 0, outer = 0 }, elements = { root = nil, inner = nil, label = nil, innerMarker = nil, outerMarker = nil}}, ArcProgressBar)
    self.elements.root = document:GetElementById(self.rootId)
    self.elements.inner = self.elements.root:QuerySelector(".arc-progress-bar--inner")
    self.elements.label = self.elements.root:QuerySelector(".arc-progress-bar--label")
    self.elements.innerMarker = self.elements.root:QuerySelector(".arc-progress-bar--indicator-inner")
    self.elements.outerMarker = self.elements.root:QuerySelector(".arc-progress-bar--indicator-outer")
    return self
end

function ArcProgressBar:SetProgress(pctValue)
    self.percent = pctValue
    self:Update()
    return self
end

function ArcProgressBar:SetInnerMarkerProgress(pctValue)
    self.markers.inner = pctValue
    self:Update()
    return self
end

function ArcProgressBar:SetOuterMarkerProgress(pctValue)
    self.markers.outer = pctValue
    self:Update()
    return self
end

function ArcProgressBar:Update()
    -- Use text colour and background colour for progress bar background and bar colours
    local barColor = self.elements.inner.style.color
    local barBackgroundColor = self.elements.inner.style.background

    -- Configured for horseshoe mask (-131deg start, 73% stop position = 100% progress, factor: 0.73)
    local progressGradientStopPct = math.floor(self.percent * 0.73) -- 0%-73% = 0-100%
    self.elements.inner.style.decorator = "conic-gradient(from -131deg, " .. ifNil(barColor,"#9cdf16") .. " " .. ifNil(progressGradientStopPct,"0") .. "%, " .. ifNil(barBackgroundColor,"rgb(71,71,71)") .. " 0 0)"
    self.elements.label.inner_rml = tonumber(self.percent) .. "%"

    -- Outer & Inner Markers Z rotation: 45deg = 0%, 315deg = 100%
    local progressMarker1Deg = math.floor(self.markers.inner * 2.7) + 45
    self.elements.innerMarker.style.transform = "translate(-50%, -50%) rotateZ(" .. progressMarker1Deg .. "deg)"

    local progressMarker2Deg = math.floor(self.markers.outer * 2.7) + 45
    self.elements.outerMarker.style.transform = "rotateZ(" .. progressMarker2Deg .. "deg)"
end

return { ArcProgressBar = ArcProgressBar }