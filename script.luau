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
    return nil
end
local get_simulation_radius = getsimulationradius or get_simulation_radius or function ()
    return pcall(get_hidden_property, localPlayer, "SimulationRadius") or math.huge
end
local fire_touch_interest = firetouchinterest or fire_touch_interest or function (...)
    
end

function spoof(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local cframe = target.CFrame
    local rootCFrame = rootPart.CFrame
    local magnitude = (rootCFrame.Position - cframe.Position).Magnitude
    local isOwner = is_network_owner(target)
    local simulationRadius = get_simulation_radius()

    task.spawn(function()
        if (magnitude > simulationRadius - 5) or not isOwner then
            target.CFrame = rootCFrame
            while true do
                if isOwner and magnitude < get_simulation_radius() - 5  then
                    break
                end
                task.wait()
            end
            target.CFrame = cframe
        end
    end)
    pcall(fire_touch_interest, character.PrimaryPart, target, 0)
    if target ~= rootPart then
        target.Velocity = (rootCFrame.Position - cframe.Position) + Vector3.new(0, 30, 0)
    end
end

local mainConnection = RunService.Heartbeat:Connect(function(deltaTime)
    for _, child in ipairs(character:GetChildren()) do
        local partToSpoof = child
        if child:IsA("Accessory") then
            partToSpoof = child:FindFirstChild("Handle")
        end

        if partToSpoof:IsA("BasePart") then
            task.spawn(spoof, partToSpoof)
        end
    end
end)

localPlayer.CharacterRemoving:Once(function(character)
    mainConnection:Disconnect()
end)

settings().Physics.AllowSleep = false
settings().Physics.ForceCSGv2 = false
settings().Physics.DisableCSGv2 = true
settings().Physics.UseCSGv2 = false
settings().Rendering.EagerBulkExecution = true
settings().Physics.ThrottleAdjustTime = math.huge
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
localPlayer.ReplicationFocus = workspace