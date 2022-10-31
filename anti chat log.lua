repeat
    wait()
until game:IsLoaded()

local StarterGui = game:GetService("StarterGui")
local Player = game:GetService("Players").LocalPlayer

local ChatFixToggle = true
local CoreGuiSettings = {}
local ChatFix

ChatFix = hookmetamethod(StarterGui, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    
    if not checkcaller() and ChatFixToggle and Method == "SetCoreGuiEnabled" then
        local CoreGuiType = Arguments[1]
        local SettingValue = Arguments[2]
        
        if CoreGuiType == ("All" or "Chat") then
            Insert(CoreGuiSettings, CoreGuiType, SettingValue)
            return
        end
    end
    
    return ChatFix(self, ...)
end)

local PlayerScripts = Player:WaitForChild("PlayerScripts")
local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true) or false
local PostMessage = require(ChatMain).MessagePosted

local OldFunctionHook
OldFunctionHook = hookfunction(PostMessage.fire, function(self, Message)
    if not checkcaller() and self == PostMessage then
        Instance.new("BindableEvent"):Fire(Message)
        return
    end
    return OldFunctionHook(self, Message)
end)

setfflag("AbuseReportScreenshot", "False")
setfflag("AbuseReportScreenshotPercentage", 0)

ChatFixToggle = false