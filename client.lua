local web = nil
local timer = nil

local receive = {}
local send = {}

local labels = {
    ["packetlossTotal"] = "Packet Loss Total",
    ["packetlossLastSecond"] = "Packet Loss Last Second",
    ["messagesInResendBuffer"] = "Messages In Resend Buffer",
    ["bytesInResendBuffer"] = "Bytes In Resend Buffer",
    ["bytesResent"] = "Bytes Resent",
    ["bytesSendTotal"] = "Bytes Send Total",
    ["bytesReceivedTotal"] = "Bytes Received Total",
    ["bytesResentTotal"] = "Bytes Resent Total",
    ["isLimitedByCongestionControl"] = "Limited By Congestion Control",
    ["isLimitedByOutgoingBandwidthLimit"] = "Limited By Outgoing Bandwidth Limit"
}

local function create()
    web = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)

    LoadWebFile(web, ("http://asset/%s/html/index.html"):format(GetPackageName()))
	SetWebAnchors(web, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(web, WEB_VISIBLE)

    SetIgnoreLookInput(true)
	ShowMouseCursor(true)
	SetInputMode(INPUT_UI)

    return true
end

local function destroy()
    SetWebVisibility(web, WEB_HIDDEN)
    DestroyWebUI(web)
    web = nil

    SetIgnoreLookInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)

    if (timer) then
        DestroyTimer(timer)
        timer = nil
    end

    receive = {}
    send = {}

    return true
end

local function updater()
    local network = GetNetworkStats()

    local receiveSize = #receive or 0
    if (receiveSize >= 10)then
        receive[1] = nil

        for i, e in pairs(receive) do 
            receive[i-1] = e
            receive[i] = nil
        end 

        table.insert(receive, network["bytesReceived"])
    else
        table.insert(receive, network["bytesReceived"])
    end

    local sendSize = #send or 0
    if (sendSize >= 10)then
        send[1] = nil

        for i, e in pairs(send) do 
            send[i-1] = e
            send[i] = nil
        end 

        table.insert(send, network["bytesSend"])
    else
        table.insert(send, network["bytesSend"])
    end

    for index, element in pairs(labels) do
        ExecuteWebJS(web, 'document.getElementById("' .. index .. '").innerHTML = `' .. element .. ': <span style="color: #FF6384;">' .. tostring((network[index] == false and "No" or network[index] == true and "Yes" or network[index])) .. '</span>`;')
    end

    ExecuteWebJS(web, [[
        receivedChart.data.datasets[0].data = []] .. table.concat(receive, ",") .. [[];
        sentChart.data.datasets[0].data = []] .. table.concat(send, ",") .. [[];

        receivedChart.update();
        sentChart.update();
    ]])
end

function command(player)

    if (not IsGameDevMode()) then
        AddPlayerChat('<span color="#FF0000" style="bold" size="12">ERROR: </><span color="#FFFFFF">The game needs to be in Development mode to acces this menu!</>')
        return false
    end

    if (web == nil and create()) then
        return true
    end
end
AddCommand("network", command)

AddEvent("OnWebLoadComplete", function(e)
	if (e == web and GetWebVisibility(web) == WEB_VISIBLE) then
        timer = CreateTimer(updater, 1000)
    end
end)

AddEvent("onNetworkClose", function()
    if (web and destroy()) then
        AddPlayerChat('<span color="#36A2EB" style="bold" size="12">Network: </><span color="#FFFFFF">The menu was closed!</>')
        return true
    end
end)

AddEvent("onNetworkFocus", function(state)
    if (web) then
        if (tonumber(state) == 1) then
            SetIgnoreLookInput(true)
	        ShowMouseCursor(true)
            SetInputMode(INPUT_UI)
        else
            SetIgnoreLookInput(false)
	        ShowMouseCursor(false)
	        SetInputMode(INPUT_GAME)
        end

        return true
    end
end)

AddEvent("OnPackageStop", function()
    if (web and destroy()) then
        AddPlayerChat('<span color="#36A2EB" style="bold" size="12">Network: </><span color="#FFFFFF">The menu was closed because the resource is stopping!</>')
        return true
    end
end)