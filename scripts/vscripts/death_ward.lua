function Spawn( entityKeyValues )
	print("wd_ward_think")
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end

function unitCtrl() 
	SpellCast(thisEntity:FindAbilityByName("addonName_heal_ward_control"))
	return 0.2
end

function SpellCast(cast_ability, target)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
		AbilityIndex = cast_ability:entindex(),
	}) 
end