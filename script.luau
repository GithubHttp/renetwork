--///////////////////////////////////////--
--   Made by Proville6, please credit!
--///////////////////////////////////////--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character

local is_network_owner = isnetworkowner or is_network_owner or function (...)
    return true
end
local fire_touch_interest = firetouchinterest or fire_touch_interest or function (...)
    
end

settings().Physics.AllowSleep = false

function accessoryNetless(target: Accessory)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local handle = target.Handle
    local old = handle.CFrame
    local new = (rootPart or handle).CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    if magnitude > gethiddenproperty(localPlayer, "SimulationRadius") or not is_network_owner(handle) then
        handle.CFrame = new
        task.wait(1 / 1000)
        handle.CFrame = old
    end

    pcall(fire_touch_interest, character.PrimaryPart, handle, 0)

    handle.Velocity = Vector3.new(1, 27.65, 1) * magnitude
end
function partNetless(target: BasePart)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local old = target.CFrame
    local new = (rootPart or target).CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    
    if magnitude > gethiddenproperty(localPlayer, "SimulationRadius") or not is_network_owner(target) then
        target.CFrame = new
        task.wait(1 / 1000)
        target.CFrame = old
     end

     pcall(fire_touch_interest, character.PrimaryPart, target, 0)
    

    if target ~= rootPart then
        target.Velocity = Vector3.new(1, 27.65, 1) * magnitude
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
