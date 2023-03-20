::mods_hookExactClass("entity/tactical/enemies/legend_banshee", function ( obj )
{
	local ws_onInit = obj.onInit;
	obj.onInit = function()
	{
		ws_onInit();
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_ghost_possess"));
	};
	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss"); 
		this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fortified_mind"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_terrifying_visage"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_ghost_ghastly_touch"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_ghost_vanish"));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_ghost_soul_eater"));
		}

		local NineLives = this.m.Skills.getSkillByID("perk.nine_lives");
		
		if (NineLives == null) 
		{
			NineLives = ::new("scripts/skills/perks/perk_nine_lives");
			this.m.Skills.add(NineLives);
		}

		NineLives.addNineLivesCount(8);

		if (::Is_PTR_Exist)
		{
			if (::Math.rand(1, 100) <= 50)
			{
				this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_menacing"));
			}
			else
			{
				this.m.Skills.add(::new("scripts/skills/perks/perk_ptr_bully"));
			}
		}

		local possess = this.m.Skills.getSkillByID("actives.ghost_possess");
		if (possess != null) possess.m.MaxRange = 4;
		return true;
	};

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

			local type = ::Math.rand(20, 100);
			local loot;

			if (type <= 40)
			{
				local weapons = clone ::Const.Items.NamedWeapons;
				loot = ::new("scripts/items/" + ::MSU.Array.rand(weapons));
			}
			else if (type <= 60)
			{
				local shields = clone ::Const.Items.NamedShields;
				loot = ::new("scripts/items/" + ::MSU.Array.rand(shields));
			}
			else if (type <= 80)
			{
				local helmets = clone ::Const.Items.NamedHelmets;

				if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
				{
					local weightName = ::Const.World.Common.convNameToList(helmets);
					loot = ::Const.World.Common.pickHelmet(weightName);
				}
				else
				{
					loot = ::new("scripts/items/" + ::MSU.Array.rand(helmets));
				}
			}
			else if (type <= 100)
			{
				local armor = clone ::Const.Items.NamedArmors;
				
				if (!::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
				{
					local weightName = ::Const.World.Common.convNameToList(armor);
					loot = ::Const.World.Common.pickArmor(weightName);
				}
				else
				{
					loot = ::new("scripts/items/" + ::MSU.Array.rand(armor));
				}
			}

			if (loot != null)
			{
				loot.drop(_tile);
			}
		}
	};
});