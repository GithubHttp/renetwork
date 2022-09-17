--[[ 
/////////// Renetwork ////////////
 Renetwork is a new network spoof.
//////////////////////////////////
 ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character

local is_network_owner = isnetworkowner or is_network_owner or function (object: Instance)
    if object:IsA("Accessory") then
        object = object:FindFirstDescendant("BasePart")
    end
    assert(object ~= nil and object:IsA("BasePart"), "Attempt to check the network owner of a " .. typeof(object))
    return object.ReceiveAge == 0
end
local get_hidden_property = gethiddenproperty or get_hidden_property or function (...)
    return math.huge
end
local fire_touch_interest = firetouchinterest or fire_touch_interest or function (...)
    
end

function spoof(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local cframe = target.CFrame
    local rootCFrame = rootPart.CFrame
    local isOwner = is_network_owner(target)
    local magnitude = (rootCFrame.Position - cframe.Position).Magnitude
    local simulationRadius = get_hidden_property(localPlayer, "SimulationRadius")

    task.spawn(function()
        if magnitude > simulationRadius - 1 or not isOwner then
            target.CFrame = rootCFrame
            task.wait(1 / 1000)
            target.CFrame = cframe
        end
    end)
    pcall(fire_touch_interest, character.PrimaryPart, target, 0)
    if target ~= rootPart then
        target.Velocity = (rootCFrame.Position - cframe.Position) + Vector3.new(0, 50, 0)
    end
end

local mainConnection = RunService.Heartbeat:Connect(function(deltaTime)
    for _, child in ipairs(character:GetChildren()) do
        local partToSpoof = child
        if child:IsA("Accessory") then
            partToSpoof = child:FindFirstChildOfClass("BasePart") or child
        end

        if partToSpoof:IsA("BasePart") then
            task.spawn(spoof, partToSpoof)
        end
    end
end)

localPlayer.CharacterRemoving:Once(function(character)
    mainConnection:Disconnect()
end)
