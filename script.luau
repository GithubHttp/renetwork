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
--[[ local get_hidden_property = gethiddenproperty or get_hidden_property or function (...)
    return math.huge
end
local fire_touch_interest = firetouchinterest or fire_touch_interest or function (...)
    
end ]]
--local raknet = rnet or raknet or rak_net or nil
--local lastRakCall = os.clock()

--settings().Physics.AllowSleep = false

--[[ function sendNetworkOwnerChanged(obj, systemid)
    if raknet and raknet.packetWriter then
        local packetWriter = raknet.packetWriter;
        packetWriter:start();
        packetWriter:writeByte(0x83);
        packetWriter:writeByte(0x07);
        packetWriter:writeInstance(obj);
        packetWriter:writeUInt16BE(0x818);
        packetWriter:writeVarInt64(systemid);
        raknet.send(packetWriter:finish());
    end
end

function setowner(target, new, old)
    if (os.clock() - lastRakCall) > 1 / 750 then
        task.spawn(sendNetworkOwnerChanged, target, 1)
        lastRakCall = os.clock()
    end
    target.CFrame = new
    task.wait(1 / 1000)
    target.CFrame = old
end ]]

function spoof(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local cframe = target.CFrame
    local rootCFrame = rootPart.CFrame
    local isOwner = is_network_owner(target)

    --local magnitude = (rootCFrame.Position - cframe.Position).Magnitude
    if not isOwner then
        target.CFrame = rootCFrame
        while is_network_owner(target) do task.wait() end
        target.CFrame = cframe
    end
    if target ~= rootPart then
        target.Velocity = Vector3.one * 27
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
