function CreateWard(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster.death_ward = CreateUnitByName("witch_doctor_death_ward_datadriven", caster:GetOrigin(), true, caster, nil, caster:GetTeam())
	print(caster.death_ward)
	ability:ApplyDataDrivenModifier( caster, caster.death_ward, "modifier_heal_ward_datadriven", {} )
end
function DestroyWard(keys)
	local caster = keys.caster
	UTIL_Remove(caster.death_ward)
	StopSoundEvent(keys.sound, caster)
end
function WardSplit(keys)
	local caster = keys.caster
	local radius = 500
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local projectile_speed = 1000
	local max_targets = 5
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,ally in pairs(allies) do
		if ally ~= nil and ally:IsAlive() then
			if ally:GetHealthPercent () < 90 then
				local projectile_info = 
				{
					EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
					Ability = ability,
					vSpawnOrigin = caster_location,
					Target = ally,
					Source = caster,
					bHasFrontalCone = false,
					iMoveSpeed = projectile_speed,
					bReplaceExisting = false,
					bProvidesVision = false
				}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
			end
		end
		if max_targets == 0 then break end
	end
	max_targets = 5
end