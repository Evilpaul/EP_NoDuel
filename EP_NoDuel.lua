local format = string.format

local EPNoDuel = CreateFrame('Frame')
EPNoDuel:RegisterEvent('DUEL_REQUESTED')

local duelDeclineMessage = 'This is an automated message, all duel requests will be declined'

EPNoDuel:SetScript('OnEvent', function(self, event, originator)
	-- Automatically cancel the duel
	CancelDuel()

	-- The popup is shown, make sure it goes away
	local popup
	for i = 1, STATICPOPUP_NUMDIALOGS do
		popup = _G['StaticPopup' .. i]

		if popup and
		   popup:IsVisible() and
		   popup.which == 'DUEL_REQUESTED' then
			popup:Hide()
		end
	end

	-- report to the user
	DEFAULT_CHAT_FRAME:AddMessage(format('|cffDAFF8A[No Duel]|r Declined duel with %s', originator))

	-- only whisper if the same faction
	local eMyFaction, _ = UnitFactionGroup('player')
	local eTheirFaction, _ = UnitFactionGroup(originator)

	if eMyFaction == eTheirFaction then
		-- tell the idiot
		SendChatMessage(duelDeclineMessage, 'WHISPER', nil, originator)
	end
end)

-- filter out our responses
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', function(_, _, msg, _)
	if msg == duelDeclineMessage then return true end
end)
