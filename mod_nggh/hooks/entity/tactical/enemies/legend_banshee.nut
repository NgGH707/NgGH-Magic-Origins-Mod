::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/legend_banshee", function ( q )
{
	q.onInit = @(__original) function()
	{
		__original();
		getSkills().add(::new("scripts/skills/actives/nggh_mod_ghost_possess"));
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		getSprite("miniboss").setBrush("bust_miniboss"); 
		getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
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

		local possess = getSkills().getSkillByID("actives.ghost_possess");

		if (possess != null) 
			possess.m.MaxRange = 4;

		m.ActionPoints = 12;
		m.BaseProperties.ActionPoints = 12;
		getSkills().update();
		return true;
	}

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		__original(_killer, _skill, _tile, _fatalityType);

		if (!m.IsMiniboss) return
		
		if (_tile == null)
			_tile = getTile();

		local loot, type = ::Math.rand(20, 100);

		if (type <= 40) 
			loot = ::new("scripts/items/" + ::MSU.Array.rand(clone ::Const.Items.NamedWeapons));
		else if (type <= 60)
			loot = ::new("scripts/items/" + ::MSU.Array.rand(clone ::Const.Items.NamedShields));
		else if (type <= 80)
			loot = ::Const.World.Common.pickHelmet(::Const.World.Common.convNameToList(clone ::Const.Items.NamedHelmets));
		else if (type <= 100)
			loot = ::Const.World.Common.pickArmor(::Const.World.Common.convNameToList(clone ::Const.Items.NamedArmors));

		if (loot != null)
			loot.drop(_tile);
	}

});