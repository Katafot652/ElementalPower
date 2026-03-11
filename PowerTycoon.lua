-- [[ ELEMENTAL POWER TYCOON | MAX MENU V59 ]] --
-- Оновлення: Додано Cruel Sun Spell та Rocket Launcher

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local Window = Rayfield:CreateWindow({
   Name = "Elemental Power Tycoon | Bohdan bot",
   LoadingTitle = "Loading Donation Items...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local AbilityTab = Window:CreateTab("Abilities", 4483362458)
local SpecialTab = Window:CreateTab("Special Skills", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- ==========================================
-- [ ЛОГІКА ВИДАЧІ МАГІЙ ]
-- ==========================================

local function Equip(p) 
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer("equip_mystery_spell", p) 
end

-- Списки магій
local donationItems = {"Cruel Sun Spell", "Rocket Launcher"}
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

-- Створення Dropdowns
SpecialTab:CreateSection("Donation Powers")
SpecialTab:CreateDropdown({
    Name = "Select Donation Item",
    Options = donationItems,
    CurrentOption = "",
    Callback = function(o) Equip(o[1]) end
})

SpecialTab:CreateSection("Special Skills")
SpecialTab:CreateDropdown({
    Name = "Select Special Skill",
    Options = specialSkills,
    CurrentOption = "",
    Callback = function(o) Equip(o[1]) end
})

for element, powers in pairs(allPowers) do
    AbilityTab:CreateDropdown({
        Name = element,
        Options = powers,
        CurrentOption = "",
        Callback = function(o) Equip(o[1]) end
    })
end

-- ==========================================
-- [ CLICK TP ТА PLAYER ]
-- ==========================================

PlayerTab:CreateSection("Movement & TP")

PlayerTab:CreateToggle({
   Name = "Click TP (Hold Z + Click)",
   CurrentValue = false,
   Callback = function(Value) _G.ClickTP = Value end
})

mouse.Button1Down:Connect(function()
    if _G.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.Z) then
        if mouse.Target and player.Character then
            player.Character:MoveTo(mouse.Hit.p)
        end
    end
end)

local SelectedPlayer = ""
PlayerTab:CreateDropdown({
   Name = "Target for Stick TP",
   Options = (function() local n = {} for _, v in pairs(game.Players:GetPlayers()) do if v ~= player then table.insert(n, v.Name) end end return n end)(),
   CurrentOption = "",
   Callback = function(Option) SelectedPlayer = Option[1] end,
})

PlayerTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function() 
       -- Код оновлення списку в Rayfield Dropdown
   end,
})

PlayerTab:CreateToggle({
   Name = "Stick to Player (Loop TP)",
   CurrentValue = false,
   Callback = function(Value)
      _G.LoopTP = Value
      task.spawn(function()
         while _G.LoopTP do
            local target = game.Players:FindFirstChild(SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 4)
            end
            RunService.Heartbeat:Wait()
         end
      end)
   end
})

PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end})
PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) _G.Noclip = v end})
RunService.Stepped:Connect(function() if _G.Noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- ==========================================
-- [ COLORFUL ESP ]
-- ==========================================

local elementColors = {
    ["Fire"] = "rgb(255, 80, 0)", ["Water"] = "rgb(0, 160, 255)", ["Earth"] = "rgb(160, 110, 50)",
    ["Thunder"] = "rgb(255, 255, 0)", ["Ice"] = "rgb(180, 255, 255)", ["Nature"] = "rgb(0, 255, 100)",
    ["Light"] = "rgb(255, 255, 200)", ["Darkness"] = "rgb(130, 0, 255)", ["Lava"] = "rgb(255, 100, 0)",
    ["Super Sonic"] = "rgb(0, 255, 255)", ["Bone"] = "rgb(240, 240, 240)", ["Technology"] = "rgb(150, 150, 150)",
    ["Gravity"] = "rgb(100, 0, 180)", ["Time"] = "rgb(255, 180, 0)", ["Crystal"] = "rgb(255, 0, 200)",
    ["Venom"] = "rgb(120, 255, 0)", ["Devil"] = "rgb(180, 0, 0)", ["Space"] = "rgb(60, 60, 255)", ["None"] = "rgb(200, 200, 200)"
}

VisualsTab:CreateToggle({
   Name = "Colorful Player ESP",
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
                     billboard.Name = "GeminiESP"; billboard.Size = UDim2.new(0, 200, 0, 80); billboard.StudsOffset = Vector3.new(0, 4, 0); billboard.AlwaysOnTop = true
                     local text = Instance.new("TextLabel", billboard)
                     text.BackgroundTransparency = 1; text.Size = UDim2.new(1, 0, 1, 0); text.RichText = true; text.Font = Enum.Font.GothamBold; text.TextSize = 15
                  end
                  local hum = p.Character:FindFirstChildOfClass("Humanoid")
                  if hum then
                     local elem = "None"
                     if p.Team then elem = p.Team.Name:gsub(" Team", "") end
                     local colorTag = elementColors[elem] or elementColors["None"]
                     billboard.Text
