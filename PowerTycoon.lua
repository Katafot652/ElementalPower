-- [[ ELEMENTAL POWER TYCOON | MAX MENU V46 ]] --
-- Стабільна версія: Player TP Fix + Infinite Yield Auto-Load

task.spawn(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer

    local Window = Rayfield:CreateWindow({
       Name = "Elemental Power Tycoon | Full Sosalovo",
       LoadingTitle = "Admin & Power Systems...",
       LoadingSubtitle = "by Gemini",
       ConfigurationSaving = { Enabled = false }
    })

    -- ВКЛАДКИ
    local MainTab = Window:CreateTab("Main", 4483362458)
    local AbilityTab = Window:CreateTab("Abilities", 4483362458)
    local SpecialTab = Window:CreateTab("Special Skills", 4483362458)
    local PlayerTab = Window:CreateTab("Player", 4483362458)
    local VisualsTab = Window:CreateTab("Visuals", 4483362458)

    -- [ ПРАВИЛЬНИЙ PLAYER TELEPORT ] --
    local SelectedPlayer = "" -- Порожньо за замовчуванням

    local PlayerDropdown = PlayerTab:CreateDropdown({
       Name = "Select Player",
       Options = {"Click Refresh to start..."}, 
       CurrentOption = "",
       MultipleOptions = false,
       Callback = function(Option)
          SelectedPlayer = Option[1]
       end,
    })

    PlayerTab:CreateButton({
       Name = "Refresh Player List",
       Callback = function()
          local list = {}
          for _, p in pairs(game.Players:GetPlayers()) do
             if p ~= player then table.insert(list, p.Name) end
          end
          PlayerDropdown:Set(list)
          Rayfield:Notify({Title = "TP System", Content = "List Updated!", Duration = 2})
       end,
    })

    PlayerTab:CreateButton({
       Name = "Teleport to Player",
       Callback = function()
          -- Перевіряємо, чи це реальний гравець, а не напис "Click Refresh..."
          local target = game.Players:FindFirstChild(SelectedPlayer)
          if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
             player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
          else
             Rayfield:Notify({Title = "TP Error", Content = "Invalid player selected!", Duration = 3})
          end
       end,
    })

    -- [ МАГІЇ ] --
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

    -- [ PLAYER & VISUALS ] --
    VisualsTab:CreateToggle({
       Name = "Player ESP",
       CurrentValue = false,
       Callback = function(v)
          _G.ESP = v
          task.spawn(function()
             while _G.ESP do
                for _, p in pairs(game.Players:GetPlayers()) do
                   if p ~= player and p.Character then
                      local h = p.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", p.Character)
                      h.Name = "ESPHighlight" h.FillColor = Color3.fromRGB(255, 0, 0)
                   end
                end
                task.wait(1)
             end
             for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end end
          end)
       end
    })

    PlayerTab:CreateSection("Movement")
    PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end})
    PlayerTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) if player.Character then player.Character.Humanoid.UseJumpPower = true player.Character.Humanoid.JumpPower = v end end})
    PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) _G.Noclip = v end})
    RunService.Stepped:Connect(function() if _G.Noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

    -- [ MAIN ] --
    MainTab:CreateToggle({Name = "Money Magnet", CurrentValue = false, Callback = function(v) _G.AutoCash = v task.spawn(function() while _G.AutoCash do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("BasePart") and (x.Name:find("Cash") or x.Name:find("Dollar")) then x.CFrame = player.Character.HumanoidRootPart.CFrame end end task.wait(0.5) end end) end})
    MainTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) _G.AutoRebirth = v task.spawn(function() while _G.AutoRebirth do for _, x in pairs(workspace:GetDescendants()) do if x:IsA("ProximityPrompt") and x.ObjectText:find("Rebirth") then player.Character.HumanoidRootPart.CFrame = x.Parent.CFrame + Vector3.new(0, 3, 0) task.wait(0.5) fireproximityprompt(x) end end task.wait(5) end end) end})

    Rayfield:Notify({Title = "Success", Content = "MAX MENU V46 & Admin Loaded!", Duration = 5})
end)

-- [ АВТО-ЗАПУСК АДМІНКИ ] --
-- Запускаємо Infinite Yield в окремому потоці, щоб він не заважав Rayfield
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
end)
