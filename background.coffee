ports = {}

notifyDevtools = (msg) ->
    Object.keys(ports).forEach (portId_) ->
        ports[portId_].postMessage msg


chrome.extension.onConnect.addListener (port) ->
    return if port.name isnt "devtools"

    ports[port.portId_] = port
    
    port.onDisconnect.addListener (port) ->
        delete ports[port.portId_]
    
    port.onMessage.addListener ({tabid, actionid}) ->
        
        chrome.tabs.executeScript(
            tabid,
            {file: "#{actionid}.js"},
            # {code: "document.body.style.backgroundColor='red'"},
            (res) ->
                msg =
                    tabid: tabid
                    actionid: actionid
                    result: (JSON.stringify res)

                notifyDevtools msg
        )
