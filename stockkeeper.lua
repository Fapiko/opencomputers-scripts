local component = require('component')
local os = require('os')

local GT_INGOT = 'gregtech:gt.metaitem.01'
local CHARGED_CERTUS_DUST = 'dreamcraft:item.ChargedCertusQuartzDust'

local stocks = {
    ANNEALED_COPPER_INGOT={
        name=GT_INGOT,
        damage=11345,
        stock=512
    },
    STEEL_INGOT={
        name=GT_INGOT,
        damage=11305,
        stock=512
    },
    ALUMINIUM_INGOT={
        name=GT_INGOT,
        damage=11019,
        stock=512
    },
    CARBON_DUST={
        name=GT_INGOT,
        damage=2010,
        stock=2048
    },
    STAINLESS_STEEL_INGOT={
        name=GT_INGOT,
        damage=11306,
        stock=512
    },
    CHARGED_CERTUS_DUST={
        name=CHARGED_CERTUS_DUST,
        damage=0,
        stock=256
    }
}

local stocking = {}
local craftingStatus = {}

function filterFor(name)
    local name = string.upper(name)

    if (name == ALUMINIUM_INGOT) then
        return {name=GT_INGOT, damage=GT_ALUMINIUM_INGOT }
    elseif name == CARBON_DUST then
        return {name=GT_INGOT, damage=GT_CARBON_DUST }
    else
        return {name=stocks[name].name, damage=stocks[name].damage}
    end
end

--[[function expandTable(table)
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
end]]

function stock(name, id, amount)
    if stocking[name] == nil or stocking[name] == false then
        local filter = filterFor(name)
        local search = component.me_controller.getItemsInNetwork(filter)

        if search.n > 0 then
            local result = search[1]
            if result.size < amount then
                local craftables = component.me_controller.getCraftables(filter)

                if craftables.n == 1 then
                    local numberToQueue = amount - result.size

                    print(string.format("[%s] Queueing up %d", name, numberToQueue))
                    craftingStatus[name] = craftables[1].request(numberToQueue, false)
                    stocking[name] = not craftingStatus[name].isDone()
                end
            end
        end
    else
        local finished = craftingStatus[name].isDone() or craftingStatus[name].isCanceled()
        print(string.format('[%s] Finished crafting? %s', name, tostring(finished)))

        if finished then
            stocking[name] = false
        end
    end
end

while (true) do
    for k, v in pairs(stocks) do
        stock(k, v.damage, v.stock)
    end

    os.sleep(15)
end
