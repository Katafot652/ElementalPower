-- [[ ELEMENTAL POWER TYCOON | MAX MENU V41 + OUXI GUI ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Elemental Power Tycoon | MAX MENU V41",
   LoadingTitle = "Merging GUIs...",
   LoadingSubtitle = "by Gemini & Ouxi",
   ConfigurationSaving = { Enabled = false }
})

-- --- [ ВКЛАДКИ RAYFIELD ] ---
local MainTab = Window:CreateTab("Main", 4483362458)
local AbilityTab = Window:CreateTab("Abilities", 4483362458)
local SpecialTab = Window:CreateTab("Special Skills", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- --- [ СПИСКИ МАГІЙ ДЛЯ RAYFIELD ] ---
local specialSkills = {"Dark Flames", "Draedon's Tech", "Yoru", "Plasma Orbs", "Red Saucer", "Undead Staff", "Elysian Beam", "Bubble Flail", "Poison Serpent"}
local allPowers = {
    ["Water"] = {"Atlan's Trident", "Jellyfish", "Bubbles", "Bubble Dash", "Aqua Trident", "Water Beam", "Big Tsunami"},
    ["Super Sonic"] = {"Sonic Blaster", "Sonic Barrage", "Sonic Twister", "Rebound Blast", "Rebound Teleport", "Sonic Boom", "Super Sonic Wave"},
    ["Lava"] = {"Lava Katana", "Lava Ball", "Magam Fists", "Lava Dash", "Volcano Sentry", "Magma Spikes", "Nibiru"},
    ["Bone"] = {"Bone Scythe", "Blaster", "Bones Barrage", "Flying Bone", "Bone Surge", "Twin Blasters", "Judgement Blast"},
    ["Darkness"] = {"Shadow Sword", "Unseen Hands", "Unseen Barrage", "Dark Duo", "Abyss", "Dark Hold", "Dark Arc"},
    ["Light"] = {"Light Saber", "Light Ball", "Light Orbs", "Blinding Light", "Shooting Star", "Light Speed", "Light Beam"},
    ["Nature"] = {"Christmas Tree Sword", "Plantoid", "Spore Bombs", "Nature's Blessing", "Nuclear Spore", "Pine Burst", "Nature's Wrath"},
    ["Ice"] = {"Frost Staff", "Frost Fire Ball", "Ice Disk", "Snow Ball", "Ultracold Aura", "Ice Spikes"},
    ["Thunder"] = {"Thunder Staff", "Bolt", "Barrage", "Discharge", "Flying Nimbus", "Lighting Strike", "Storm"},
    ["Earth"] = {"Tectonic Hamer", "Stone Throw", "Rocks Barrage", "Large Boulder", "Burrow", "Stone Henge", "Earth Spikes"},
    ["Fire"] = {"Fire Sword", "Fire Ball", "Fire Fly", "Fire Bomb", "Comet", "Combust", "Fire Shower"},
    ["Technology"] = {"Hyper Sword", "Phonton Blast", "Twin-Photon Blash", "Tesla Turret", "Orbital", "Tesseract", "Hyper Slash"},
    ["Gravity"] = {"Gravity Katana", "Heavy Infliction", "Tectonic Barrage", "Gravity Orb", "Tectonic Burst", "Zero Gravity", "Gravity Globe"},
    ["Time"] = {"Time Scepter", "Temporal Gate", "Warp Barrage", "Tempo Beam", "Time Trap", "Warp Bomb", "Grand Clock"},
    ["Crystal"] = {"Crystal Cleaver", "Crystal Mine", "Energy Crash", "Energy Crown", "Crystal Eruption", "Energy Crystal", "Crystal Surge"},
    ["Venom"] = {"Venom Blade", "Poison Bullet", "Acid Rain", "Venom Stream", "Hardened Venom", "Poison Demon", "Bubbling Venom"},
    ["Devil"] = {"Devil Sword", "Evil Bullet", "Fangs Barrage", "Evil Flash", "Demon Orb", "Demon Lock", "Dark Tsunami"},
    ["Space"] = {"Space Gun", "Blackhole Orb", "Moon Splitter", "Asteroid Belt", "Meteor Jam", "Cosmic Remote", "Space Saucer"}
}

local function EquipPower(powerName)
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
    if remote then remote:FireServer("equip_mystery_spell", powerName) end
end

-- Створення Dropdowns для Rayfield
SpecialTab:CreateDropdown({Name = "Special Skills", Options = specialSkills, CurrentOption = "", Callback = function(Option) EquipPower(Option[1]) end})
for element, powers in pairs(allPowers) do
    AbilityTab:CreateDropdown({Name = element, Options = powers, CurrentOption = "", Callback = function(Option) EquipPower(Option[1]) end})
end

-- --- [ VISUALS & PLAYER LOGIC ] ---
VisualsTab:CreateToggle({
   Name = "Player ESP (Chams)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESP = Value
      task.spawn(function()
         while _G.ESP do
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= player and p.Character then
                  local h = p.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", p.Character)
                  h.Name = "ESPHighlight" h.FillColor = Color3.fromRGB(255, 0, 0) h.FillTransparency = 0.5
               end
            end
            task.wait(1)
         end
         for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end end
      end)
   end
})

PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(Value) _G.Noclip = Value end})
RunService.Stepped:Connect(function() if _G.Noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(Value) if player.Character then player.Character.Humanoid.WalkSpeed = Value end end})
PlayerTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(Value) if player.Character then player.Character.Humanoid.UseJumpPower = true player.Character.Humanoid.JumpPower = Value end end})
PlayerTab:CreateToggle({Name = "Z-Teleport (Z+Click)", CurrentValue = false, Callback = function(Value)
      _G.ClickTP = Value
      local mouse = player:GetMouse()
      mouse.Button1Down:Connect(function() if _G.ClickTP and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Z) then if mouse.Target then player.Character:MoveTo(mouse.Hit.p) end end end)
end})

-- --- [ MAIN TAB LOGIC ] ---
MainTab:CreateToggle({Name = "Money Magnet", CurrentValue = false, Callback = function(v) _G.AutoCash = v task.spawn(function() while _G.AutoCash do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("BasePart") and (x.Name:find("Cash") or x.Name:find("Dollar")) then x.CFrame = player.Character.HumanoidRootPart.CFrame end end task.wait(0.5) end end) end})
MainTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) _G.AutoRebirth = v task.spawn(function() while _G.AutoRebirth do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("ProximityPrompt") and x.ObjectText:find("Rebirth") then player.Character.HumanoidRootPart.CFrame = x.Parent.CFrame + Vector3.new(0, 3, 0) task.wait(0.5) fireproximityprompt(x) end end task.wait(5) end end) end})

-- ==========================================================
-- --- [ ПРЯМЕ ВБУДОВУВАННЯ OUXI GUI (БЕЗ ЗМІН) ] ---
-- ==========================================================

local G2L = {};

G2L["1"] = Instance.new("ScreenGui", game.CoreGui);
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["AutoLocalize"] = false;
G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
G2L["1"]["Name"] = [[Ouxi]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;

G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["ZIndex"] = 999999999;
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 25);
G2L["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["2"]["Size"] = UDim2.new(0, 304, 0, 275);
G2L["2"]["Position"] = UDim2.new(0.3, 0, 0.5, 0); -- Трохи змістив вліво, щоб не перекривало Rayfield
G2L["2"]["Name"] = [[UI]];

G2L["3"] = Instance.new("UICorner", G2L["2"]);
G2L["3"]["CornerRadius"] = UDim.new(0, 4);

G2L["4"] = Instance.new("Frame", G2L["2"]);
G2L["4"]["ZIndex"] = 999999999;
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["4"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["4"]["Size"] = UDim2.new(0.9900000095367432, 0, 0, 32);
G2L["4"]["Position"] = UDim2.new(0.5, 0, 0, 0);
G2L["4"]["Name"] = [[Header]];

G2L["5"] = Instance.new("TextLabel", G2L["4"]);
G2L["5"]["ZIndex"] = 999999999;
G2L["5"]["BackgroundTransparency"] = 1;
G2L["5"]["TextSize"] = 14;
G2L["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["Size"] = UDim2.new(0, 207, 0, 32);
G2L["5"]["Text"] = [[OuxiHub | Elemental Powers]];
G2L["5"]["Name"] = [[NName]];
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]]);

G2L["8"] = Instance.new("ScrollingFrame", G2L["2"]);
G2L["8"]["ZIndex"] = 999999999;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["8"]["Size"] = UDim2.new(0, 285, 0, 210);
G2L["8"]["Position"] = UDim2.new(0.5, 0, 0.185, 0);
G2L["8"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["8"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["8"]["ScrollBarThickness"] = 5;
G2L["8"]["Name"] = [[Powers]];

G2L["9"] = Instance.new("UIListLayout", G2L["8"]);
G2L["9"]["Padding"] = UDim.new(0, 7);

-- [ Логіка Handler для Ouxi ]
local function C_17()
    local script = Instance.new("LocalScript", G2L["2"])
    local powers = {
        ["Lava"] = {"Lava Katana", "Lava Ball", "Magam Fists", "Lava Dash", "Volcano Sentry", "Magma Spikes", "Nibiru"},
        ["Bone"] = {"Bone Scythe", "Blaster", "Bones Barrage", "Flying Bone", "Bone Surge", "Twin Blasters", "Judgement Blast"},
        ["Darkness"] = {"Shadow Sword", "Unseen Hands", "Unseen Barrage", "Dark Duo", "Abyss", "Dark Hold", "Dark Arc"},
        ["Light"] = {"Light Saber", "Light Ball", "Light Orbs", "Blinding Light", "Shooting Star", "Light Speed", "Light Beam"},
        ["Nature"] = {"Christmas Tree Sword", "Plantoid", "Spore Bombs", "Nature's Blessing", "Nuclear Spore", "Pine Burst", "Nature's Wrath"},
        ["Ice"] = {"Frost Staff", "Frost Fire Ball", "Ice Disk", "Snow Ball", "Ultracold Aura", "Ice Spikes"},
        ["Thunder"] = {"Thunder Staff", "Bolt", "Barrage", "Discharge", "Flying Nimbus", "Lighting Strike", "Storm"},
        ["Earth"] = {"Tectonic Hamer", "Stone Throw", "Rocks Barrage", "Large Boulder", "Burrow", "Stone Henge", "Earth Spikes"},
        ["Fire"] = {"Fire Sword", "Fire Ball", "Fire Fly", "Fire Bomb", "Comet", "Combust", "Fire Shower"},
        ["Technology"] = {"Hyper Sword", "Phonton Blast", "Twin-Photon Blash", "Tesla Turret", "Orbital", "Tesseract", "Hyper Slash"},
        ["Gravity"] = {"Gravity Katana", "Heavy Infliction", "Tectonic Barrage", "Gravity Orb", "Tectonic Burst", "Zero Gravity", "Gravity Globe"},
        ["Time"] = {"Time Scepter", "Temporal Gate", "Warp Barrage", "Tempo Beam", "Time Trap", "Warp Bomb", "Grand Clock"},
        ["Crystal"] = {"Crystal Cleaver", "Crystal Mine", "Energy Crash", "Energy Crown", "Crystal Eruption", "Energy Crystal", "Crystal Surge"},
        ["Venom"] = {"Venom Blade", "Poison Bullet", "Acid Rain", "Venom Stream", "Hardened Venom", "Poison Demon", "Bubbling Venom"},
        ["Devil"] = {"Devil Sword", "Evil Bullet", "Fangs Barrage", "Evil Flash", "Demon Orb", "Demon Lock", "Dark Tsunami"},
        ["Space"] = {"Space Gun", "Blackhole Orb", "Moon Splitter", "Asteroid Belt", "Meteor Jam", "Cosmic Remote", "Space Saucer"}
    }
    
    local function addButton(name)
        local b = Instance.new("TextButton", G2L["8"])
        b.Size = UDim2.new(0, 264, 0, 26)
        b.BackgroundColor3 = Color3.fromRGB(17,17,17)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Text = name
        b.MouseButton1Click:Connect(function() EquipPower(name) end)
    end

    for k, v in pairs(powers) do for _, p in pairs(v) do addButton(p) end end
end
task.spawn(C_17)

-- [ Логіка Dragify для Ouxi ]
local function C_18()
    local gui = G2L["2"]
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.KeyCode.Unknown then dragging = false end end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
task.spawn(C_18)

Rayfield:Notify({Title = "V41 Loaded", Content = "Rayfield & Ouxi GUI are active!", Duration = 5})
