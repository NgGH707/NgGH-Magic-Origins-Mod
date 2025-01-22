::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/ghost", function ( q )
{
	q.onInit = @(__original) function()
	{
		__original();
		getSkills().add(::new("scripts/skills/actives/nggh_mod_ghost_possess"));
	}

	q.makeMiniboss = @(__original) function()
	{
		if (!__original())
			return false;

		getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		getSkills().add(::new("scripts/skills/perks/perk_fortified_mind"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_terrifying_visage"));
		getSkills().add(::new("scripts/skills/perks/perk_underdog"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_ghost_ghastly_touch"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_ghost_vanish"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			getSkills().add(::new("scripts/skills/perks/perk_nggh_ghost_soul_eater"));
		
		local NineLives = getSkills().getSkillByID("perk.nine_lives");
		
		if (NineLives == null)  {
			NineLives = ::new("scripts/skills/perks/perk_nine_lives");
			getSkills().add(NineLives);
		}

		NineLives.addNineLivesCount(8);

		if (::Is_PTR_Exist) {
			if (::Math.rand(1, 100) <= 50)
				getSkills().add(::new("scripts/skills/perks/perk_ptr_menacing"));
			else
				getSkills().add(::new("scripts/skills/perks/perk_ptr_bully"));
		}

		local scream = getSkills().getSkillByID("actives.horrific_scream");
		if (scream != null) scream.m.MaxRange = 4;
		local possess = getSkills().getSkillByID("actives.ghost_possess");
		if (possess != null) possess.m.MaxRange = 4;
		return true;
	}

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		__original(_killer, _skill, _tile, _fatalityType);

		if (!m.IsMiniboss) return
		
		if (_tile == null)
			_tile = getTile();

		local loot, type = ::Math.rand(20, 100);

		if (type <= 40) {
			local weapons = clone ::Const.Items.NamedWeapons;
			loot = ::new("scripts/items/" + ::MSU.Array.rand(weapons));
		}
		else if (type <= 60) {
			local shields = clone ::Const.Items.NamedShields;
			loot = ::new("scripts/items/" + ::MSU.Array.rand(shields));
		}
		else if (type <= 80) {
			local helmets = clone ::Const.Items.NamedHelmets;
			local weightName = ::Const.World.Common.convNameToList(helmets);
			loot = ::Const.World.Common.pickHelmet(weightName);
		}
		else if (type <= 100) {
			local armor = clone ::Const.Items.NamedArmors;
			local weightName = ::Const.World.Common.convNameToList(armor);
			loot = ::Const.World.Common.pickArmor(weightName);
		}

		if (loot != null)
			loot.drop(_tile);
	}
});