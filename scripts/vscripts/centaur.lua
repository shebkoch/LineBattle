function Spawn( entityKeyValues )
	thisEntity:SetIdleAcquire(false)
	thisEntity:SetAcquisitionRange(0)
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 0.1)
end
function unitCtrl() 
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	
	for _,enemy in pairs( enemyHero ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < attackRadius then 
				return Attack(enemy)
			else
				return Approach(enemy)		
			end
		end
	end
	return 0.1
end
function Approach(unit)
	if unit ~= nil and unit:IsAlive() then
		thisEntity.bMoving = true
		local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
		vToEnemy = vToEnemy:Normalized()
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed(),
			Queue = false
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
			TargetIndex = unit:entindex(),
			Queue = false
			--Position = unit:GetOrigin(),
			--Queue = false,
		})
	end
	return 0.5
end