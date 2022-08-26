--///////////////////////////////////////--
--   Made by Proville6, please credit!
--///////////////////////////////////////--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character

settings().Physics.AllowSleep = false

function accessoryNetless(target: Accessory)
    local rootPart = character.HumanoidRootPart
    local handle = target.Handle
    local old = handle.CFrame
    local new = rootPart.CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    if magnitude > gethiddenproperty(localPlayer, "SimulationRadius") then
        handle.CFrame = new
        task.wait(1 / 1000)
        handle.CFrame = old
    end

    handle.Velocity = (new.Position - old.Position) + Vector3.new(0, 50, 0)
end
function partNetless(target: BasePart)
    local rootPart = character.HumanoidRootPart
    local old = target.CFrame
    local new = rootPart.CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    if magnitude > gethiddenproperty(localPlayer, "SimulationRadius") then
        target.CFrame = new
        task.wait(1 / 1000)
        target.CFrame = old
    end

    if target ~= rootPart then
        target.Velocity = (new.Position - old.Position) + Vector3.new(0, 50, 0)
    end
end

local mainConnection = RunService.Heartbeat:Connect(function(deltaTime)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then
            task.spawn(accessoryNetless, child)
        elseif child:IsA("BasePart") then
            task.spawn(partNetless, child)
        end
    end
end)

localPlayer.CharacterRemoving:Once(function(character)
    mainConnection:Disconnect()
end)
