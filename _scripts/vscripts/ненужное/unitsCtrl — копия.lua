local addonName_abilities_table = {
	[1] = "addonName_arc_lightning",
	[2] = "addonName_voodoo_restoration"
}
local addonName_events_table = {
	["OnSpawn"] = 0,
	["OnAttack"] = 1
	
}
local cur_abilities = {
	[0] = nil,
	[1] = nil
}
local cur_ability_events_table = {
	[0] = "",
	[1] = ""
}
local cur_ability_chance_table = {
	[0] = "",
	[1] = ""
}

local isFirstThink = true

function Spawn( entityKeyValues )
	FindAbility()
	SetSpecialValues()
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end

function FindAbility()
	for _,_ability in pairs(addonName_abilities_table) do
		for _,_cur_ability in pairs(cur_abilities) do
			if _cur_ability == nil 
				_cur_ability = thisEntity:FindAbilityByName(_ability)
				break
			end
		end
	end
end

function SetSpecialValues()
	for i,_cur_ability in pairs(cur_abilities) do
		cur_ability_events_table[i] = _cur_ability:GetSpecialValueFor("event")
		cur_ability_chance_table[i] = _cur_ability:GetSpecialValueFor("chance")
	end
end
function SpawnEvent() 
	for i,_cur_ability in pairs(cur_abilities) do
		if cur_ability_events_table[i] == addonName_events_table["OnSpawn"] then
			SpellCast(cur_ability_events_table[i])
		end
	end
end
function unitCtrl() 
	for i,_cur_ability in pairs(cur_abilities) do
		print(_cur_ability:GetName())
		print(cur_ability_events_table[i])
		print(cur_ability_chance_table[i])
	end
	if isFirstThink and then
		isFirstThink = false
		SpawnEvent() 
	end
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then 
				return AttackEvent(enemy)
			end
		end
	end
	for _,enemy in pairs( enemyHero ) do
		return Approach(enemy)
	end
end
function AttackEvent(enemy)
	local skillNumber = RandomInt(1,#cur_abilities)--test
	if RandomInt(1,100) < cur_ability_chance_table[skillNumber] then
		return SpellCast(cur_abilities[skillNumber], enemy)
	else return Attack(enemy)
	end		

end
function Approach(unit)
	print("Approach")
	print(unit)
	print(unit == nil)
	print(thisEntity)
	thisEntity.bMoving = true
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end
function Attack(unit)
	thisEntity.bMoving = false
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = unit:entindex()
		--Position = unit:GetOrigin(),
		--Queue = false,
	})
	return 0.5
end
function SpellCast(cast_ability, target = nil)
	if 
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
		AbilityIndex = cast_ability:entindex(),
		TargetIndex = target:entindex()
	})
	return 0.1
end