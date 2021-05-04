function Spawn( entityKeyValues )

	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end
local hpToKill = 400; 
function unitCtrl() 
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then

			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < attackRadius then 
				if(enemy:GetHealth() > hpToKill and not enemy:IsHero()) then 
					return SpellCast(thisEntity:FindAbilityByName("addonName_kunkka_black_mark"),enemy)
				end
				return Attack(enemy)
			end
			else if(flDist < attackRadius + approachRadius) then
				return Approach(enemy)
			end
		end
	end
	for _,enemy in pairs( enemyHero ) do
		return Approach(enemy)
	end
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
function SpellCast(cast_ability, target)
	print("spellCast")
	print(target)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,	
		AbilityIndex = cast_ability:entindex(),
		TargetIndex = target:entindex()
	}) 
	Timers:CreateTimer(1,
    function()
		cast_ability:StartCooldown(cast_ability:GetCooldown(1))
	end)
	return 0.5
end