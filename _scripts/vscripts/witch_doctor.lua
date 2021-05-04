function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end
local wardRadius = 600
function unitCtrl() 
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local allies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local cast_ability = thisEntity:FindAbilityByName("addonName_heal_ward")
	if (not cast_ability:IsChanneling()) then
		for _,ally in pairs( allies ) do
			if ally ~= nil and ally:IsAlive() then
				if ally:GetHealthPercent () < 75 then
					local flDist = ( ally:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
					if flDist < wardRadius then
						return SpellCast(cast_ability)
					end
				end
			end
		end
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
				local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist < attackRadius then 
					return Attack(enemy)
				end
			end
		end
		for _,enemy in pairs( enemyHero ) do
			return Approach(enemy)
		end
	end
	return 0.1
end
function Approach(unit)
	if unit ~= nil and unit:IsAlive() and not thisEntity.bMoving then
		if(not unit:IsHero()) then 
			thisEntity.bMoving = true
		end
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
	return 1
end
function SpellCast(cast_ability)
	if (not cast_ability:IsChanneling() and cast_ability:GetCooldownTimeRemaining() == 0) then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
			AbilityIndex = cast_ability:entindex()
		}) 
		Timers:CreateTimer(1,
		function()
			cast_ability:StartCooldown(cast_ability:GetCooldown(1))
		end)
	end
	return 1
end