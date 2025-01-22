::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/legend_demon_hound", function ( q )
{
	q.onFactionChanged <- function()
	{
		actor.onFactionChanged();
		local flip = isAlliedWithPlayer();
		getSprite("body").setHorizontalFlipping(flip);
		getSprite("head").setHorizontalFlipping(flip);
		getSprite("injury").setHorizontalFlipping(flip);
		getSprite("blur_1").setHorizontalFlipping(flip);
		getSprite("blur_2").setHorizontalFlipping(flip);
	}

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		__original(_killer, _skill, _tile, _fatalityType);

		if (m.IsMiniboss) {
			if (_tile == null)
				_tile = getTile();

			local loot = ::new("scripts/items/legend_armor/armor_upgrades/nggh_mod_named_bone_platings_legend_upgrade");
		    loot.setName(getName());
		    loot.m.Tile = _tile;
		    _tile.Items.push(loot);
			_tile.IsContainingItems = true;
		}
	}

	q.makeMiniboss <- function()
	{
		local b = m.BaseProperties;
		m.XP = ::Const.Tactical.Actor.LegendWhiteDirewolf.XP;
		b.setValues(::Const.Tactical.Actor.LegendWhiteDirewolf);
		b.Hitpoints = 400;
		b.DamageRegularMult = 1.15;

		m.ActionPoints = b.ActionPoints;
		m.CurrentProperties = clone b;
		m.AIAgent = ::new("scripts/ai/tactical/agents/legend_white_wolf_agent");
		m.AIAgent.setActor(this);
		m.IsMiniboss = true;
		m.IsGeneratingKillName = false;
		getSprite("miniboss").setBrush("bust_miniboss");
		getSkills().add(::new("scripts/skills/racial/nggh_mod_fake_champion_racial"));
		getSkills().add(::new("scripts/skills/racial/ghost_racial"));
		getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		getSkills().add(::new("scripts/skills/perks/perk_fast_adaption"));
		//getSkills().add(::new("scripts/skills/perks/perk_skeleton_harden_bone"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_terrifying_visage"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_battleheart"));
		getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		getSkills().add(::new("scripts/skills/racial/werewolf_racial"));

		if (::Is_PTR_Exist) {
			getSkills().add(::new("scripts/skills/perks/perk_ptr_vengeful_spite"));
			getSkills().add(::new("scripts/skills/perks/perk_ptr_menacing"));
			getSkills().add(::new("scripts/skills/perks/perk_ptr_bully"));
		}

		setHitpointsPct(1.0);
		return true;
	}
	
});