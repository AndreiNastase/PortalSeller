PortalSeller = CreateFrame("Frame")

PortalSeller.matchWords = {
        "wtb portal to Undercity",
        "wtb portal UC",
        "wtb uc portal",
		"wtb portal to Orgrimmar",
        "wtb portal OG",
        "wtb og portal",
		"wtb portal to Thunder BLuff",
        "wtb portal tb",
        "wtb tb portal",
		"wtb portal to dalaran",
        "wtb portal dala",
        "wtb dala portal",
		"wtb dalaran portal",
}

function PortalSeller:Print(...)
    print("[Portal Seller] " .. ...)
end

function PortalSeller:Boot()
    self:SetScript("OnEvent", function(self, event, ...)
        self[event](self, ...)
    end)
    self:RegisterEvent("ADDON_LOADED")
end

function PortalSeller:ADDON_LOADED(name)
    if name == "PortalSeller" then
        self:OnBoot()
    end
end


function PortalSeller:RegisterSlashCommand()
    SLASH_PORTALSELLER1 = "/ps"
    SLASH_PORTALSELLER2 = "/portalseller"
    SlashCmdList["PORTALSELLER"] = function(msg)
        local _, _, command, args = string.find(msg, "%s?(%w+)%s?(.*)")
        if command then
            self:OnSlashCommand(command, args)
        end
    end
	self:Print("Portal Seller type /ps on /ps off for enable/disable the addon")
end

function PortalSeller:OnSlashCommand(command, args)
    command = string.lower(command)
    if command == "on" then
        self:On()
    elseif command == "off" then
        self:Off()
    else
        self:Print("Unknown command.")
    end  
end

function PortalSeller:On()
    self:RegisterEvent("CHAT_MSG_SAY")
    self:RegisterEvent("CHAT_MSG_YELL")
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:Print("Looking for portal buyers...")
end

function PortalSeller:Off()
    self:UnregisterEvent("CHAT_MSG_SAY")
    self:UnregisterEvent("CHAT_MSG_YELL")
    self:UnregisterEvent("CHAT_MSG_WHISPER")
    self:Print("All done. Time for breakfast.")
end

function PortalSeller:OnBoot()
	--self:MakeLowercaseMatchWords();
    self:RegisterSlashCommand()
    self:Print("Portal Seller is Loaded.")
end

function PortalSeller:CHAT_MSG_SAY(...)
    self:OnChat(...)
end

function PortalSeller:CHAT_MSG_YELL(...)
    self:OnChat(...)
end

function PortalSeller:CHAT_MSG_WHISPER(...)
    self:OnChat(...)
end

function PortalSeller:OnChat(text, playerName, _, _, shortPlayerName, _, _, _, _, _, _, guid)
    
end

function PortalSeller:MakeLowercaseMatchWords()
    for destination, wordList in pairs(self.matchWords) do
        for index, word in ipairs(wordList) do
			--self:Print(string.lower(word))
            self.matchWords[destination][index] = string.lower(word)
        end
    end
end


function PortalSeller:WantsPortal(playerName, guid, message)
    if playerName == UnitName("player") then
        return false
    end
    
    local _, playerClass = GetPlayerInfoByGUID(guid)
    if playerClass == "MAGE11" then
        return false
    end
	--self:Print('Am primit de la player: '..message)
	--for word in string.gmatch(message, "%a+") do
		--	self:Print('---->>>: '..word)
			local match, destination = self:MatchWordToDestination(string.lower(message))
			if match then
				return match, destination
			end
	--	end

    return false
end

function PortalSeller:MatchWordToDestination(word)
	--self:Print('MatchWordToDestination: '..word)
    word = string.lower(word)
    for destination, wordList in pairs(self.matchWords) do
        --if self:ArrayHas(word, wordList) then
		if string.find(string.lower(word), string.lower(wordList)) then
            return true, destination
        end
    end
    return false
end

function PortalSeller:ArrayHas(item, array)
    for index, value in pairs(array) do
        if value == item then
            return true
        end
    end
    return false
end

function PortalSeller:OnChat(text, playerName, _, _, shortPlayerName, _, _, _, _, _, _, guid)
    if self:WantsPortal(playerName, guid, text) then
        InviteUnit(playerName)
    end
end

PortalSeller:Boot()