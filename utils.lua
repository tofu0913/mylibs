
function checkDeBuffs()
    local player = windower.ffxi.get_player()
    local buffs = S(player.buffs):map(string.lower .. table.get-{'english'} .. table.get+{res.buffs})
    if buffs.sleep or buffs.petrification or buffs.stun or buffs.charm or buffs.amnesia or buffs.terror or buffs.lullaby or buffs.impairment then
        return false
    end
    return true
end

function isInParty(pid)
    if pid == windower.ffxi.get_player().id then
        return true
    end
    local pt = windower.ffxi.get_party()
    for i = 0, 5 do
        local member = pt['p'..i]
        if member ~= nil and member.mob and member.mob.id == pid then
            return true
        end
    end
    return false
end
