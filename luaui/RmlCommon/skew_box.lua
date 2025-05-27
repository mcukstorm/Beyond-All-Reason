
SkewBox = { MODES = { NORMAL = "", WARN = "alert-warn", CRITICAL = "alert-critical"}, LABEL_POSITION = { LEFT = "", RIGHT = "skew-drop-label-right" }}
SkewBox.__index = SkewBox
function SkewBox.new(document, rootElementId)
    local self = setmetatable({rootId = rootElementId, mode = SkewBox.MODES.NORMAL, labelText = "", elements = { root = nil, label = nil}}, SkewBox)
    self.elements.root = document:GetElementById(self.rootId)
    self.elements.label = self.elements.root:QuerySelector(".skew-drop-label")

    if not self.elements.label == nil then
        self.labelText = self.elements.label.inner_rml;
    end

    if self.elements.root:IsClassSet(SkewBox.MODES.WARN) then
        self.mode = SkewBox.MODES.WARN
    end

    if self.elements.root:IsClassSet(SkewBox.MODES.CRITICAL) then
        self.mode = SkewBox.MODES.CRITICAL
    end

    return self
end

function SkewBox:SetMode(mode)
    self.mode = mode
    if mode == SkewBox.MODES.NORMAL then
        self.elements.root:SetClass(SkewBox.MODES.WARN, false)
        self.elements.root:SetClass(SkewBox.MODES.CRITICAL, false)

    elseif mode == SkewBox.MODES.WARN then
        self.elements.root:SetClass(SkewBox.MODES.WARN, true)
        self.elements.root:SetClass(SkewBox.MODES.CRITICAL, false)
    
    elseif mode == SkewBox.MODES.CRITICAL then
        self.elements.root:SetClass(SkewBox.MODES.WARN, false)
        self.elements.root:SetClass(SkewBox.MODES.CRITICAL, true)

    end
    return self
end

function SkewBox:CreateLabelIfNotExists()
    if self.elements.label == nil then
        self.elements.label = self.elements.root.owner_document:CreateElement("DIV")
        self.elements.label:SetClass("skew-drop-label", true)
        self.elements.root:AppendChild(self.elements.label)
    end
end

function SkewBox:SetLabelText(labelText)
    self:CreateLabelIfNotExists()
    -- TODO: Add html entities encode
    self.labelText = labelText
    self.elements.label.inner_rml = labelText
    return self
end

function SkewBox:IsLabelVisible()
    self:CreateLabelIfNotExists()
    return self.elements.label:IsClassSet("show")
end

function SkewBox:SetLabelVisible(blnVisible)
    self:CreateLabelIfNotExists()
    self.elements.label:SetClass("show", blnVisible)
    return self
end

function SkewBox:HideLabel()
    self:SetLabelVisible(false)
    return self
end

function SkewBox:ShowLabel()
    self:SetLabelVisible(true)
    return self
end

function SkewBox:SetLabelPosition(position)
    self:CreateLabelIfNotExists()
    self.elements.label:SetClass(SkewBox.LABEL_POSITION.RIGHT, position == SkewBox.LABEL_POSITION.RIGHT)
    return self
end





return { SkewBox = SkewBox }