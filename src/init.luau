------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

------ SETUP ------
local Networker = {}

--[=[
    @within Networker
    @function _init
    @modifier Private
    @return Folder
    @desc Creates a folder to place networking instances if it doesnt exist yet
]=]

function Networker._init()
    if ReplicatedStorage:FindFirstChild("Network") then return end 

    local network  = Instance.new("Folder")
    network.Name   = "Network"
    network.Parent = ReplicatedStorage
    return network
end

--[=[
    @within Networker
    @function GetStream
    @param name string        -- Name of the networking instance
    @param networkType string -- Type of the networking instance
    @return Instance.new(networkType)
    @desc 
]=]

-- DONT EVER, EVER, EVER MAKE THE SAME NAME WITH STREAMS
function Networker.GetStream<T>(name: string, networkType: string): T
    local network  = ReplicatedStorage:FindFirstChild("Network")
    local onClient = RunService:IsClient()

    if not network then
        network = (not onClient and Networker._init()) or ReplicatedStorage:WaitForChild("Network")
    end

    local validNetworkTypes: {string} = {
        "RemoteEvent",
        "BindableEvent",
        "RemoteFunction",
        "BindableFunction",
        "UnreliableRemoteEvent",
    }

    if not table.find(validNetworkTypes, networkType) then error(networkType.." is not a valid network type!") end

    local stream  = network:FindFirstChild(name) or ((onClient and network:WaitForChild(name)) or Instance.new(networkType))
    stream.Name   = name
    stream.Parent = network

    return stream :: T
end

return Networker