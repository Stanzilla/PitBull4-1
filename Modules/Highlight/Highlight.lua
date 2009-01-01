if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_Highlight requires PitBull4")
end

local PitBull4_Highlight = PitBull4:NewModule("Highlight")

PitBull4_Highlight:SetModuleType("custom")
PitBull4_Highlight:SetName("Highlight")
PitBull4_Highlight:SetDescription("Show a highlight when hovering or targeting.")
PitBull4_Highlight:SetDefaults({})

function PitBull4_Highlight:OnEnable()
	self:AddFrameScriptHook("OnEnter")
	self:AddFrameScriptHook("OnLeave")
	
	local mouseFocus = GetMouseFocus()
	for frame in PitBull4:IterateFrames() do
		if mouseFocus == frame then
			self:OnEnter(frame)
		end
	end
end

function PitBull4_Highlight:UpdateFrame(frame)
	if not self:GetLayoutDB(frame).enabled then
		return self:ClearFrame(frame)
	end
	
	if frame.Highlight then
		return false
	end
	
	local highlight = PitBull4.Controls.MakeFrame(frame)
	frame.Highlight = highlight
	highlight:SetAllPoints(frame)
	highlight:SetFrameLevel(highlight:GetFrameLevel() + 5)
	highlight:Hide()
	
	local texture = PitBull4.Controls.MakeTexture(highlight, "OVERLAY")
	highlight.texture = texture
	texture:SetTexture([=[Interface\QuestFrame\UI-QuestTitleHighlight]=])
	texture:SetBlendMode("ADD")
	texture:SetAlpha(0.5)
	texture:SetAllPoints(highlight)
	
	return false
end

function PitBull4_Highlight:ClearFrame(frame)
	if not frame.Highlight then
		return false
	end
	
	frame.Highlight.texture = frame.Highlight.texture:Delete()
	frame.Highlight = frame.Highlight:Delete()
	
	return false
end

function PitBull4_Highlight:OnEnter(frame)
	if not frame.Highlight then
		return
	end
	frame.Highlight:Show()
end

function PitBull4_Highlight:OnLeave(frame)
	if not frame.Highlight then
		return
	end
	frame.Highlight:Hide()
end

PitBull4_Highlight:SetLayoutOptionsFunction(function(self) end)
