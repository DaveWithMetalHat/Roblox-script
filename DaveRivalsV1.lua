local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🎯 Rivals | Elite Combat",
   LoadingTitle = "DavewithmetalHat's Elite",
   LoadingSubtitle = "by DavewithmetalHat",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RivalsConfig",
      FileName = "CombatSettings"
   },
   KeySystem = false 
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TargetPart = "Head" 
local FOV = 200 

-- [[ COMBAT TAB ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateDropdown({
   Name = "Aim Target",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(Option)
      TargetPart = Option
   end,
})

CombatTab:CreateToggle({
   Name = "Lock-On Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      _G.Aimbot = Value
   end,
})

-- [[ VISUALS TAB ]]
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
   Name = "Wallhack (ESP)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      _G.ESP = Value
      while _G.ESP do
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               if not player.Character:FindFirstChild("Highlight") then
                  local highlight = Instance.new("Highlight", player.Character)
                  highlight.FillColor = Color3.fromRGB(255, 0, 0)
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               end
            end
         end
         task.wait(1)
         if not _G.ESP then
             for _, p in pairs(Players:GetPlayers()) do
                 if p.Character and p.Character:FindFirstChild("Highlight") then
                     p.Character.Highlight:Destroy()
                 end
             end
         end
      end
   end,
})

-- [[ ENGINE ]]
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Aimbot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local Target = nil
        local ShortestDistance = FOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild(TargetPart) then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[TargetPart].Position)
                if OnScreen then
                    local Magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if Magnitude < ShortestDistance then
                        Target = v.Character[TargetPart]
                        ShortestDistance = Magnitude
                    end
                end
            end
        end
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

Rayfield:Notify({
   Title = "Script Active",
   Content = "Logged in as DavewithmetalHat",
   Duration = 5,
})
