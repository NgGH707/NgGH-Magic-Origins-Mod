this.getroottable().HexenHooks.hookPTR <- function ()
{
	local AutoEnableForBeasts = function(_skill)
	{
		local actor = _skill.getContainer().getActor().get();

		if (this.isKindOf(actor, "player_beast") || this.isKindOf(actor, "minion"))
		{
			_skill.m.IsForceEnabled = true;
		}
	};
	local autoForcedPerks = [
		"perk_ptr_whack_a_smack",
		"perk_ptr_light_weapon",
		"perk_ptr_between_the_ribs",
		"perk_ptr_cull",
		"perk_ptr_utilitarian",
		"perk_ptr_heavy_strikes",
		"perk_ptr_dismantle",
		"perk_ptr_easy_target",
		"perk_ptr_deadly_precision",
		"perk_ptr_from_all_sides",
		"perk_ptr_mauler",
		"perk_ptr_pointy_end",
		"perk_ptr_through_the_gaps",
	];

	foreach ( perk in autoForcedPerks) 
	{
	    ::mods_hookExactClass("skills/perks/" + perk, function ( obj )
		{
			obj.onAdded <- function()
			{
				AutoEnableForBeasts(this);
			};
		});
	}

	::mods_hookExactClass("skills/perks/perk_ptr_versatile_weapon", function ( obj )
	{
		obj.m.IsForceEnabled <- false;
		obj.onAdded <- function()
		{
			AutoEnableForBeasts(this);
		};
		obj.onUpdate <- function( _properties )
		{
			if (!this.m.IsForceEnabled)
			{
				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon == null || !weapon.isWeaponType(this.Const.Items.WeaponType.Sword))
				{
					return;
				}
			}

			_properties.MeleeDamageMult += this.m.Bonus;
			_properties.DamageDirectAdd += this.m.Bonus;
			_properties.DamageArmorMult += this.m.Bonus;
		}
	});
	::mods_hookExactClass("skills/actives/ptr_between_the_eyes_skill", function ( obj )
	{
		obj.isHidden <- function()
		{
			if (this.getContainer().getActor().getFlags().has("human"))
			{
				return !this.getContainer().getActor().isArmedWithMeleeWeapon();
			}

			return this.m.IsHidden;
		};
	});

	::mods_hookExactClass("skills/effects/ptr_swordmaster_scenario_recruit_effect", function ( obj )
	{
		local ws_evolve = obj.evolve;
		obj.evolve <- function()
		{
			local actor = this.getContainer().getActor();

			if (!actor.getFlags().has("human"))
			{
				local attributes = {
					MeleeSkill = this.Math.rand(1, 5),
					MeleeDefense = this.Math.rand(1, 5),
					Stamina = this.Math.rand(1, 5),		
					Bravery = this.Math.rand(5, 10),
					Initiative = this.Math.rand(5, 10)
				};

				actor.getBaseProperties().MeleeSkill += attributes.MeleeSkill;
				actor.getBaseProperties().MeleeDefense += attributes.MeleeDefense;	
				actor.getBaseProperties().Stamina += attributes.Stamina;		
				actor.getBaseProperties().Bravery += attributes.Bravery;
				actor.getBaseProperties().Initiative += attributes.Initiative;
				return;
			}

			ws_evolve();
		};
	});

	delete this.HexenHooks.hookPTR;
}