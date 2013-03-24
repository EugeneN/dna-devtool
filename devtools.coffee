
set_panel_content = (p, h) ->
    p.document.body.innerHTML = h

render_resp = (panel, data) ->
    set_panel_content panel, data.toString()

responce_from_bg = (data) ->
    "<h3>Responce:</h3>
    <pre>#{(JSON.stringify data).replace(/,/g, ',\n')}</pre>"


chrome.devtools.panels.create(
    "DNA", 
    "dna.png", 
    "panel.html", 

    (panel) ->
        console.log 'hello from DNA panel'
        console.log panel
        # onShown, onHidden, onSearch, createStatusBarButton, show
        _window = undefined
        c = 0

        data = []
        port = chrome.extension.connect {name: "devtools"}
        port.onMessage.addListener (msg) ->
            if _window
                msg.src = 'direct'
                c = c + 1
                msg.c = c
                render_resp _window, (responce_from_bg msg)
            else
                data.push msg

        run_q = (panel_window) ->
            panel.onShown.removeListener run_q
            _window = panel_window

            while (msg = data.shift()) 
                msg.src = 'fromq'
                render_resp _window, (responce_from_bg msg)
            
        panel.onShown.addListener run_q

        panel.onShown.addListener (panel_window) ->
            msg =
                tabid: chrome.devtools.inspectedWindow.tabId
                actionid: 'collect-dna-data'

            port.postMessage msg
            
)      

################################################################################
# The function below is executed in the context of the inspected page.
get_el_dna_interfaces = () ->
    el = $0
    id = el.id

    if window.require? and (DNA = require 'dna-lang')
        cell = DNA.get_cell el.id
        # TODO return a copy of the cell
        if cell isnt undefined
            cell
        else
            node: el
            ':': "No cell for this node"
        
    else
        error: "DNA not available"  

chrome.devtools.panels.elements.createSidebarPane(
    "DNA Cell",
    (sidebar) ->
        updateElementProperties = ->
            sidebar.setExpression "(#{get_el_dna_interfaces.toString()})()" 
  
        updateElementProperties()
        chrome.devtools.panels.elements.onSelectionChanged.addListener updateElementProperties
)


