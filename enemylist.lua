enemyList = {}
local function updateEnemyList()
    if storage.enemyText then
        enemyList = {}
        for enemy in string.gmatch(storage.enemyText, '[^\r\n]+') do
            table.insert(enemyList, enemy:lower():trim())
        end
    end
end
cole = UI.Button("Lista de Inimigos", function()
    UI.MultilineEditorWindow(storage.enemyText or "", {title="Inimigos", description="Coloque o nome dos inimigos, 1 por linha \nNick\nNick", width=250, height=200}, function(text)
        storage.enemyText = text
        updateEnemyList()
    end)
end)
cole:setImageColor('#fa07f6')
updateEnemyList()
macro(100, 'Enemy Lista', function()
    local pos = player:getPosition()
    local actualTarget, actualTargetHp = nil, nil
    for _, enemy in ipairs(enemyList) do
        for _, creature in ipairs(getSpectators(pos)) do
            local specHp = creature:getHealthPercent()
            local specName = creature:getName():lower():trim()
            
            if creature:isPlayer() and specHp and specHp > 0 then
                if specName == enemy then
                    if creature:canShoot() then
                        if not actualTarget or actualTargetHp > specHp then
                            actualTarget, actualTargetHp = creature, specHp
                        end
                    end
                end
            end
        end
    end
    if actualTarget and g_game.getAttackingCreature() ~= actualTarget then
        modules.game_interface.processMouseAction(nil, 2, pos, nil, actualTarget, actualTarget)
    end
end)
