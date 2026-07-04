-- =========================================================================
-- ANANAZOR ULTIMATE GHOST ENGINE - V10.4.1 (UNIVERSAL GHOST MODE)
-- FEATURES: FULL RESTORE + SILENT BYPASS + EARLY WARNING SYSTEM + DYNAMIC AFK SLEEP + MOBILE LOC TOGGLE + GHOST MODE
-- KEYBIND: [INSERT] TO TOGGLE | [F9] OR [LOC BTN] TO FAKE LOCATION
-- =========================================================================

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local PLR = game:GetService("Players").LocalPlayer
local LS = game:GetService("LogService")
local SC = game:GetService("ScriptContext")
local PG = PLR:WaitForChild("PlayerGui")
local RS_Storage = game:GetService("ReplicatedStorage")

-- [UNIVERSAL ANTI-BAN: NAMECALL HOOK]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "InvokeServer") and (self.Name:lower():find("kick") or self.Name:lower():find("ban") or self.Name:lower():find("teleport")) then
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [SOCIAL UI & EARLY WARNING SYSTEM - FULLY RESTORED]
local Screen = Instance.new("ScreenGui", PG)
Screen.Name = "NovaGhost_UI"
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.DisplayOrder = 999
Screen.IgnoreGuiInset = true

local WarningLabel = Instance.new("TextLabel", Screen)
WarningLabel.Size = UDim2.new(0, 300, 0, 50)
WarningLabel.Position = UDim2.new(0.5, -150, 0.4, 0)
WarningLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
WarningLabel.TextColor3 = Color3.new(1, 1, 1)
WarningLabel.Text = "DETECTION IMMINENT: SELF-DESTRUCTING"
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.TextSize = 18
WarningLabel.Visible = false

local function CreateBtn(name, pos, text, link)
    local btn = Instance.new("TextButton", Screen)
    btn.ZIndex = 10
    btn.Size = UDim2.new(0, 140, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- RAINBOW EFFECT
    task.spawn(function()
        while btn.Parent do
            for i = 0, 1, 0.05 do
                btn.TextColor3 = Color3.fromHSV(i, 1, 1)
                task.wait(0.1)
            end
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if request then request({Url = link, Method = "GET"}) end
        if setclipboard then setclipboard(link) btn.Text = "Link Copied!" task.wait(2) btn.Text = text end
    end)
    return btn
end

CreateBtn("Discord", UDim2.new(1, -150, 0, 10), "Join Discord", "https://discord.gg/P2gfGVnxx")
CreateBtn("YouTube", UDim2.new(1, -150, 0, 45), "My Channel", "https://www.youtube.com/@Brkyyt82")

-- [MOBILE LOC TOGGLE BUTTON]
local ToggleBtn = Instance.new("TextButton", Screen)
ToggleBtn.ZIndex = 10
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.Text = "LOC"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 10
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- [CORE ENGINE & PROXY - RESTORED]
local active = true
local fakeLocation = false
local ProxyPart = Instance.new("Part")
ProxyPart.Name = "NovaGhost_Proxy"
ProxyPart.Size = Vector3.new(2, 2, 2)
ProxyPart.Transparency = 1
ProxyPart.CanCollide = false
ProxyPart.Anchored = false
ProxyPart.Parent = workspace

local function MaintainStealth(part)
    pcall(function() part.CFrame = part.CFrame + Vector3.new(0, 0, 0) end)
end

-- [GHOST FEATURES: SMOOTH NOCLIP, TELEPORT LAG & GLITCH ALIBI]
local lastPos = nil
local function TriggerGhostFeatures(actionType)
    local hrp = PLR.Character and PLR.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if actionType == "noclip" then
        for i = 1, 10 do hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 0.25 task.wait(0.02) end
    elseif actionType == "teleport" then
        task.wait(math.random(150, 300) / 1000)
    elseif actionType == "glitch" then
        hrp.AssemblyLinearVelocity = Vector3.new(0, -50, 0) 
        task.wait(0.1)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

-- [LOC TOGGLE FUNCTION]
local function ToggleFakeLoc()
    fakeLocation = not fakeLocation
    if fakeLocation then
        TriggerGhostFeatures("teleport")
        ProxyPart.CFrame = PLR.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end
ToggleBtn.MouseButton1Click:Connect(ToggleFakeLoc)

-- [ANTI-CONSOLE & ANTI-CONSOLESPY - SILENT HOOKING]
if hookfunction then
    hookfunction(print, function() end)
    hookfunction(warn, function() end)
else
    rawset(_G, "print", nil)
    rawset(_G, "warn", nil)
end

-- [CORE LOOPS - RESTORED WITH DYNAMIC AFK SLEEP MODE]
RS.Heartbeat:Connect(function()
    if active and PLR.Character and PLR.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = PLR.Character.HumanoidRootPart
        
        if lastPos and (hrp.Position - lastPos).Magnitude > 30 then TriggerGhostFeatures("teleport") end
        lastPos = hrp.Position

        if fakeLocation then hrp.CFrame = ProxyPart.CFrame end
        if hrp.AssemblyLinearVelocity.Magnitude > 0.5 then
            ProxyPart.CFrame = hrp.CFrame
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(math.random(-1,1)/100, 0, math.random(-1,1)/100)
            MaintainStealth(hrp)
        else
            ProxyPart.CFrame = hrp.CFrame
        end
    end
end)

-- [ANTI-KICK / ANTI-BAN & EARLY WARNING SYSTEM - FULLY RESTORED]
SC.Error:Connect(function() return end)
LS.MessageOut:Connect(function(msg, msgType)
    if msgType == Enum.MessageType.MessageError then
        local lowerMsg = msg:lower()
        if lowerMsg:find("kick") or lowerMsg:find("ban") or lowerMsg:find("teleport") then
            WarningLabel.Visible = true
            task.wait(1.5)
            active = false
            ProxyPart:Destroy()
            script:Destroy()
        end
    end
end)

-- [FFLAGS - RESTORED]
if setfflag then
    pcall(function()
        setfflag("ReportAbuseChatKeywords", "false")
        setfflag("DebugDisableReceiptProcessing", "true")
    end)
end

UIS.InputBegan:Connect(function(key, gameProcessed)
    if not gameProcessed then
        if key.KeyCode == Enum.KeyCode.Insert then 
            active = not active 
            if not active then TriggerGhostFeatures("glitch") end
            if active then TriggerGhostFeatures("noclip") end
        end
        if key.KeyCode == Enum.KeyCode.F9 then ToggleFakeLoc() end
    end
end)
