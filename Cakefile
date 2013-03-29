{spawn} = require 'child_process'


build = ->
    coffee = spawn 'coffee', ['-c', '-o', 'out', 'src']
    coffee.stderr.on 'data', (data) ->console.log data.toString()
    coffee.stdout.on 'data', (data) -> console.log data.toString()
    coffee.on 'exit', (code) ->
        console.log "Build done w/ rc=", code
    
task 'build', 'simple build', ->
    build()




