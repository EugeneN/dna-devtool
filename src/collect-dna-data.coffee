#document.body.style.backgroundColor='green'
# return 3.1415
console.log '?????', window
cells = window.require('dna-lang').get_cells()
ret = {}

for id, cell of cells
    ret[id] = 
        protocols: Object.keys cell.impls
        receptors: Object.keys cell.receptors

console.log '>>>>', ret

return ret

