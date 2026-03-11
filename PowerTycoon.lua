-- [[ ELEMENTAL POWER TYCOON | MAX MENU V47 ]] --

-- 1. ЗАПУСК АДМІНКИ (INFINITE YIELD)
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Elemental Power Tycoon | ",
   LoadingTitle = "Advanced Visuals & TP...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

-- ВКЛАДКИ
local MainTab = Window:CreateTab("Main", 4483362458)
local AbilityTab = Window:CreateTab("Abilities", 4483362458)
local SpecialTab = Window:CreateTab("Special Skills", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- ==========================================
-- [ ПОВНИЙ ФІКС PLAYER TP (LOOP TOGGLE) ]
-- ==========================================

local SelectedPlayer = ""

local function GetPlayerNames()
    local names = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then table.insert(names, p.Name) end
    end
    return names
end

local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Select Target Player",
   Options = GetPlayerNames(),
   CurrentOption = "",
   MultipleOptions = false,
   Callback = function(Option) SelectedPlayer = Option[1] end,
})

PlayerTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function() PlayerDropdown:Set(GetPlayerNames()) end,
})

PlayerTab:CreateToggle({
   Name = "Loop TP to Player (Stick)",
   CurrentValue = false,
   Callback = function(Value)
      _G.LoopTP = Value
      task.spawn(function()
         while _G.LoopTP do
            local target = game.Players:FindFirstChild(SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
            task.wait() -- Максимальна швидкість телепорту
         end
      end)
   end
})

-- ==========================================
-- [ ADVANCED ESP (NAME, HP, ELEMENT) ]
-- ==========================================

VisualsTab:CreateToggle({
   Name = "Advanced Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      _G.AdvESP = Value
      task.spawn(function()
         while _G.AdvESP do
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                  local head = p.Character.Head
                  local billboard = head:FindFirstChild("GeminiESP") or Instance.new("BillboardGui", head)
                  
                  if billboard.Name ~= "GeminiESP" then
                     billboard.Name = "GeminiESP"
                     billboard.Size = UDim2.new(0, 200, 0, 50)
                     billboard.StudsOffset = Vector3.new(0, 3, 0)
                     billboard.AlwaysOnTop = true
                     
                     local text = Instance.new("TextLabel", billboard)
                     text.BackgroundTransparency = 1
                     text.Size = UDim2.new(1, 0, 1, 0)
                     text.TextColor3 = Color3.fromRGB(255, 255, 255)
                     text.TextStrokeTransparency = 0
                     text.Font = Enum.Font.GothamBold
                     text.TextSize = 14
                  end

                  -- Отримання даних
                  local hp = p.Character:FindFirstChildOfClass("Humanoid") and math.floor(p.Character:FindFirstChildOfClass("Humanoid").Health) or 0
                  local element = "None"
                  
                  -- Спроба знайти стихію в leaderstats або в персонажі
                  local lstats = p:FindFirstChild("leaderstats")
                  if lstats and lstats:FindFirstChild("Power") then element = lstats.Power.Value
                  elseif lstats and lstats:FindFirstChild("Element") then element = lstats.Element.Value
                  end

                  billboard.TextLabel.Text = string.format("%s\nHP: %s | Element: %s", p.DisplayName, hp, element)
                  
                  -- Колір залежно від здоров'я
                  if hp > 70 then billboard.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                  elseif hp > 30 then billboard.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                  else billboard.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) end
               end
            end
            task.wait(0.5)
         end
         -- Видалення при вимкненні
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("GeminiESP") then
               p.Character.Head.GeminiESP:Destroy()
            end
         end
      end)
   end
})

-- ==========================================
-- [ МАГІЇ, SPEED, NOCLIP ТА ІНШЕ ]
-- ==========================================

PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end})
PlayerTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) if player.Character then player.Character.Humanoid.UseJumpPower = true player.Character.Humanoid.JumpPower = v end end})
PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) _G.Noclip = v end})

RunService.Stepped:Connect(function() if _G.Noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

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

local function Equip(p) game:GetService("ReplicatedStorage").RemoteEvent:FireServer("equip_mystery_spell", p) end

SpecialTab:CreateDropdown({Name = "Special Skills", Options = specialSkills, CurrentOption = "", Callback = function(o) Equip(o[1]) end})
for el, pwr in pairs(allPowers) do
    AbilityTab:CreateDropdown({Name = el, Options = pwr, CurrentOption = "", Callback = function(o) Equip(o[1]) end})
end

-- MAIN (MAGNET & REBIRTH)
MainTab:CreateToggle({Name = "Money Magnet", CurrentValue = false, Callback = function(v) _G.AutoCash = v task.spawn(function() while _G.AutoCash do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("BasePart") and (x.Name:find("Cash") or x.Name:find("Dollar")) then x.CFrame = player.Character.HumanoidRootPart.CFrame end end task.wait(0.5) end end) end})
MainTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) _G.AutoRebirth = v task.spawn(function() while _G.AutoRebirth do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("ProximityPrompt") and x.ObjectText:find("Rebirth") then player.Character.HumanoidRootPart.CFrame = x.Parent.CFrame + Vector3.new(0, 3, 0) task.wait(0.5) fireproximityprompt(x) end end task.wait(5) end end) end})

Rayfield:Notify({Title = "Ready!", Content = "V47 Merged & Active", Duration = 3})
