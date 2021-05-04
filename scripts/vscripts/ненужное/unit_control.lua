function UnitStart( event )
	local waypoint1 = Vector(0,700,300)
	-- Find all enemy units
	print("doit")
	local hero = PlayerResource:GetPlayer(0):GetAssignedHero()
	local units = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	print(units)
	
	-- Make the found units move to (0, 0, )
	for _,unit in pairs(units) do
		print(unit)
		--unit:MoveToPosition(waypoint1)
	end
end