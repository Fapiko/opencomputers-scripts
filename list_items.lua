local component = require('component')

function expandTable(table)
    for k, v in pairs(table) do
        if k == 'n' then
            break
        end

        if table.n == nil then
            print(k, v)
        else
            print('Expanding Table ' .. k .. ':')
            expandTable(v)
        end
    end
end

items = component.me_interface.getItemsInNetwork()
expandTable(items)
