::mods_hookExactClass("entity/tactical/enemies/legend_demon_hound", function ( obj )
{
	obj.onFactionChanged <- function()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("blur_1").setHorizontalFlipping(flip);
		this.getSprite("blur_2").setHorizontalFlipping(flip);
	}

	local ws_onDeath = obj.onDeath;
	obj.onDeath = function( _killer, _skill, _tile, _fatalityType )
	{
		ws_onDeath(_killer, _skill, _tile, _fatalityType);

		if (this.m.IsMiniboss)
		{
			if (_tile == null)
			{
				_tile = this.getTile();
			}

			local loot;

			if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		    {
		    	loot = ::new("scripts/items/armor_upgrades/named/nggh_mod_named_bone_platings_upgrade");
		    }
		    else
		    {
		    	loot = ::new("scripts/items/legend_armor/armor_upgrades/nggh_mod_named_bone_platings_legend_upgrade");
		    }

		    loot.setName(this.getName());
		    loot.m.Tile = _tile;
		    _tile.Items.push(loot);
			_tile.IsContainingItems = true;
		}
	};

	obj.makeMiniboss <- function()
	{
		local b = this.m.BaseProperties;
		this.m.XP = ::Const.Tactical.Actor.LegendWhiteDirewolf.XP;
		b.setValues(::Const.Tactical.Actor.LegendWhiteDirewolf);
		b.Hitpoints = 500;
		b.DamageRegularMult = 1.15;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.AIAgent = ::new("scripts/ai/tactical/agents/legend_white_wolf_agent");
		this.m.AIAgent.setActor(this);
		this.m.IsMiniboss = true;
		this.m.IsGeneratingKillName = false;
		this.getSprite("miniboss").setBrush("bust_miniboss");
		this.m.Skills.add(::new("scripts/skills/racial/nggh_mod_fake_champion_racial"));
		this.m.Skills.add(::new("scripts/skills/racial/ghost_racial"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
		//this.m.Skills.add(::new("scripts/skills/perks/perk_skeleton_harden_bone"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_terrifying_visage"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_battleheart"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(::new("scripts/skills/racial/werewolf_racial"));

		if (::Is_PTR_Exist)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_vengeful_spite"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_menacing"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_bully"));
		}

		this.setHitpointsPct(1.0);
		return true;
	};
});