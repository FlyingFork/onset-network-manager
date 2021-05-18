network = {}
network.web = nil
network.info = {
    "packetlossTotal",
    "packetlossLastSecond",
    "messagesInResendBuffer",
    "bytesInResendBuffer",
    "bytesResent",
    "bytesSendTotal",
    "bytesReceivedTotal",
    "bytesResentTotal",
    "isLimitedByCongestionControl",
    "isLimitedByOutgoingBandwidthLimit"
}

function network.receiver()
    if not IsGameDevMode() then 
        return AddPlayerChat('<span color="#ff0000" style="bold" size="10">ERROR: You need to have the game in Development mode!</>')
    end

    if network.web then
        AddPlayerChat('<span color="#ff0000" style="bold" size="10">INFO: The menu was closed!</>')
        return network.destroy()
    end

    AddPlayerChat('<span color="#00ff00" style="bold" size="10">INFO: The menu is now visible!</>')
    network.create()
end
AddRemoteEvent("network:receiver", network.receiver)

function network.create()
    network.web = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)

    LoadWebFile(network.web, ("http://asset/%s/html/index.html"):format(GetPackageName()))
	SetWebAnchors(network.web, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(network.web, WEB_VISIBLE)

    network.timer = CreateTimer(network.updater, 1000)

    network.receive = {}
    network.send = {}
end

function network.destroy()
    SetWebVisibility(network.web, WEB_HIDDEN)
    DestroyTimer(network.timer)
    DestroyWebUI(network.web)

    network.receive = nil
    network.timer = nil
    network.send = nil
    network.web = nil
end

function network.updater()
    if network.web then 
        local info = GetNetworkStats()

        -- Info
        local span = "<p style='margin: 0;'><span style='color: white; font-weight: bold;'>"

        span = span .. "Network Information<br><br>"

        for index, item in pairs(network.info) do 
            span = span .. "" .. item .. ": " .. tostring(info[item]) .. "<br><br>"
        end 

        span = span .. "</span></p>"
        print(span)
        ExecuteWebJS(network.web, 'setText("' .. span .. '");')

        -- Chart
        local receiveSize = #network.receive or 0
        if receiveSize >= 10 then
            network.receive[1] = nil

            for i, e in pairs(network.receive) do 
                network.receive[i-1] = e
                network.receive[i] = nil
            end 

            table.insert(network.receive, info["bytesReceived"])
        else
            table.insert(network.receive, info["bytesReceived"])
        end

        local sendSize = #network.send or 0
        if sendSize >= 10 then
            network.send[1] = nil
            
            for i, e in pairs(network.send) do 
                network.send[i-1] = e
                network.send[i] = nil
            end 

            table.insert(network.send, info["bytesSend"])
        else
            table.insert(network.send, info["bytesSend"])
        end

        ExecuteWebJS(network.web, "updateChart(1, [" .. table.concat(network.receive, ",") .. "]);")
        ExecuteWebJS(network.web, "updateChart(0, [" .. table.concat(network.send, ",") .. "]);")
    end 
end

AddEvent("OnPackageStop", function()
    if network.web then
        network.destroy()
    end
end)