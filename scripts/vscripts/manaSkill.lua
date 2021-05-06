function manaRegenGain(keys)
	local caster = keys.caster
	caster:SetBaseManaRegen(caster:GetBaseManaRegen() + 1)
end
