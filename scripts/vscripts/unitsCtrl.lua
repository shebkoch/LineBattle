local addonName_abilities_table = {
	[1] = "addonName_arc_lightning",
	[2] = "addonName_voodoo_restoration",
	[3] = "addonName_techies_suicide",
	[4] = "addonName_titan_damage",
	[5] = "addonName_meepo_duplicate"
}
local addonName_events_table = {
	["OnSpawn"] = 0,
	["OnAttack"] = 1,
	["OnDeath"] = 2,
	["OnTime"] = 3,
	["OnEnemyInRadius"] = 4,
	["OnTakeDamage"] = 5,
	["Never"] = 20,
}
local ability_count = 2
local cur_abilities = {
	[0] = nil,
	[1] = nil,
}
local cur_ability_events_table = {
	[0] = "",
	[1] = ""
}
local cur_ability_chance_table = {
	[0] = 0,
	[1] = 0
}

local isFirstThink = true

function Spawn( entityKeyValues )
	FindAbility()
	SetSpecialValues()
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end

function FindAbility()
	print("FindAbility")
	for _,_ability in pairs(addonName_abilities_table) do
		for i = 1,ability_count do
			if cur_abilities[i] == nil then
				cur_abilities[i] = thisEntity:FindAbilityByName(_ability)
				break
			end
		end
	end

end

function SetSpecialValues()
	for i,_cur_ability in pairs(cur_abilities) do
		cur_ability_events_table[i] = _cur_ability:GetLevelSpecialValueFor("event",0)
		cur_ability_chance_table[i] = _cur_ability:GetLevelSpecialValueFor("chance",0)
	end
end
function SpawnEvent() 
	for i,_cur_ability in pairs(cur_abilities) do
		if cur_ability_events_table[i] == addonName_events_table["OnSpawn"] then
			if RandomInt(1,100) < cur_ability_chance_table[i] then
				print(cur_ability_chance_table[i])
				return SpellCast(_cur_ability)
			end
		end
	end
	return 0.5
end

local seconds = 0
function TimeEvent()
		
	return 0.5
end
function unitCtrl() 
	seconds = seconds + 1 
	if(seconds % 2 == 0) then TimeEvent() end
	-- for i,_cur_ability in pairs(cur_abilities) do
		-- print(i)
		-- print(_cur_ability:GetName())
		-- print(cur_ability_events_table[i])
		-- print(cur_ability_chance_table[i])
	-- end
	
	if isFirstThink then
		isFirstThink = false
		return SpawnEvent() 
	end
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < attackRadius then 
				return AttackEvent(enemy)
			end
		end
	end
	for _,enemy in pairs( enemyHero ) do
		return Approach(enemy)
	end
end
function AttackEvent(enemy)
	if enemy ~= nil and enemy:IsAlive() then
		for skillNumber,skill in pairs( cur_abilities ) do
			if cur_ability_events_table[skillNumber] == addonName_events_table["OnAttack"] then
				if RandomInt(1,100) < cur_ability_chance_table[skillNumber] then
					print(spellCast)
					return SpellCast(cur_abilities[skillNumber], enemy)
				else return Attack(enemy)
				end		
			end
		end
	end
	return 0.5
end
function Approach(unit)
	if unit ~= nil and unit:IsAlive() then
		thisEntity.bMoving = true
		local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
		vToEnemy = vToEnemy:Normalized()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
		})
	end
	return 0.5
end
function Attack(unit)
	if unit ~= nil and unit:IsAlive() then
		thisEntity.bMoving = false
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = unit:entindex()
			--Position = unit:GetOrigin(),
			--Queue = false,
		})
	end
	return 0.5
end
function SpellCast(cast_ability, target)
	
	print("spellCast")
	print(target)
	if target == nil then
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
		AbilityIndex = cast_ability:entindex()
	})
	else 
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	
			AbilityIndex = cast_ability:entindex(),
			TargetIndex = target:entindex()
		}) 
		end
		
	return 0.5
end