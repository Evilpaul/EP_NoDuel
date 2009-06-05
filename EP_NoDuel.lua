local EPNoDuel = CreateFrame("Frame");
EPNoDuel:RegisterEvent("DUEL_REQUESTED");

local duelDeclineMessage = "This is an automated message, all duel requests will be declined";

function EPNoDuel:MessageOutput(inputMessage)
	ChatFrame1:AddMessage("|cffDAFF8A[No Duel]|r " .. inputMessage);
end;

function EPNoDuel:DeclineDuel()
	-- Automatically cancel the duel
	CancelDuel();

	-- The popup is shown, make sure it goes away
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local popup = _G["StaticPopup" .. i]

		if popup then
			if popup:IsVisible() and
			   popup.which == "DUEL_REQUESTED" then
				popup:Hide();
			end
		end
	end

	-- report to the user
	self:MessageOutput(string.format("Declined duel with %s", arg1));

	-- try and stop whispers across factions
	local eMyFaction, _ = UnitFactionGroup("player");
	local eTheirFaction, _ = UnitFactionGroup(arg1);

	if eMyFaction == eTheirFaction then
		-- tell the idiot
		SendChatMessage(duelDeclineMessage, "WHISPER", nil, arg1);
	end;
end;

EPNoDuel:SetScript("OnEvent", function(self, event, addon)
	self:DeclineDuel();
end);

-- filter out our responses
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", function(_, _, msg, _)
	if msg == duelDeclineMessage then return true; end; -- filter out the reply whisper
end);
