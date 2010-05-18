local format = string.format

local EPNoDuel = CreateFrame('Frame')
EPNoDuel:RegisterEvent('DUEL_REQUESTED')

local duelDeclineMessage = 'This is an automated message, all duel requests will be declined'

function EPNoDuel:MessageOutput(inputMessage)
	ChatFrame1:AddMessage(format('|cffDAFF8A[No Duel]|r %s', inputMessage))
end;

function EPNoDuel:DUEL_REQUESTED(event, originator)
	-- Automatically cancel the duel
	CancelDuel()

	local popup
	-- The popup is shown, make sure it goes away
	for i = 1, STATICPOPUP_NUMDIALOGS do
		popup = _G['StaticPopup' .. i]

		if popup and 
		   popup:IsVisible() and
		   popup.which == 'DUEL_REQUESTED' then
			popup:Hide()
		end
	end

	-- report to the user
	self:MessageOutput(format('Declined duel with %s', originator))

	-- only whisper if the same faction
	local eMyFaction, _ = UnitFactionGroup('player')
	local eTheirFaction, _ = UnitFactionGroup(originator)

	if eMyFaction == eTheirFaction then
		-- tell the idiot
		SendChatMessage(duelDeclineMessage, 'WHISPER', nil, originator)
	end
end

EPNoDuel:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

-- filter out our responses
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', function(_, _, msg, _)
	if msg == duelDeclineMessage then return true end
end)
