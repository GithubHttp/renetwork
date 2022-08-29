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
local get_hidden_property = gethiddenproperty or get_hidden_property or function (...)
    return math.huge
end
local fire_touch_interest = firetouchinterest or fire_touch_interest or function (...)
    
end
local raknet = rnet or raknet or rak_net or nil
local lastRakCall = os.clock()

settings().Physics.AllowSleep = false

function sendNetworkOwnerChanged(obj, systemid)
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
end

function accessoryNetless(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local handle = target.Handle
    local old = handle.CFrame
    local new = (rootPart or handle).CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    local simulationRadius = get_hidden_property(localPlayer, "SimulationRadius")
    local owner = is_network_owner(handle)

    if magnitude > simulationRadius or not owner then
        task.spawn(setowner, handle, new, old)
    end

    pcall(fire_touch_interest, character.PrimaryPart, handle, 0)

    handle.Velocity = Vector3.new(1, 27.65, 1) * magnitude
end
function partNetless(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local old = target.CFrame
    local new = (rootPart or target).CFrame
    local magnitude = (new.Position - old.Position).Magnitude

    
    local simulationRadius = get_hidden_property(localPlayer, "SimulationRadius")
    local owner = is_network_owner(target)
    
    if magnitude > simulationRadius or not owner then
        task.spawn(setowner, target, new, old)
     end

     pcall(fire_touch_interest, character.PrimaryPart, target, 0)
    

    if target ~= rootPart then
        target.Velocity = Vector3.new(1, 27.65, 1) * magnitude
    end
end

local mainConnection = RunService.Heartbeat:Connect(function(deltaTime)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then
            pcall(accessoryNetless, child)
        elseif child:IsA("BasePart") then
            pcall(partNetless, child)
        end
    end
end)

localPlayer.CharacterRemoving:Once(function(character)
    mainConnection:Disconnect()
end)
