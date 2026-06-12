--!strict

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

------ SETUP ------
local Networker = {}

--[=[
    @within Networker
    @function _getStream
    @param name        string -- Name of the networking instance (DO NOT REUSE NAMES)
    @param networkType string -- type of the networking instance
    @desc Creates a 
]=]

function Networker.GetStream(name: string, networkType: string)
    ------ NETWORK VARS ------
    local onClient = RunService:IsClient()
    local network  = onClient and ReplicatedStorage:WaitForChild("Network") or ReplicatedStorage:FindFirstChild("Network")

    ------ SETUP FOLDER ------
    if not network and not onClient then
        local newNetwork  = Instance.new("Folder") 
        newNetwork.Name   = "Network"
        newNetwork.Parent = ReplicatedStorage
        network = newNetwork
    end

    if not network then error("NETWORK WAS NO CREATED!") end

    local stream = network:FindFirstChild(name) or Instance.new(networkType)
    stream.Name = name
    stream.Parent = network
    

    return stream
end

-- add more as needed

return Networker