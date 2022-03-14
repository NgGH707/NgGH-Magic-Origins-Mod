this.mod_kraken_command_squeeze_skill <- this.inherit("scripts/skills/skill", {
	m = {
		DamageMult = 1.0,
	},
	function create()
	{
		this.m.ID = "actives.mod_kraken_command_squeeze";
		this.m.Name = "Squeeze Prey";
		this.m.Description = "Tighten your grip, squeeze out the life of your poor prey.";
		this.m.Icon = "skills/active_147.png";
		this.m.IconDisabled = "skills/active_147_sw.png";
		this.m.Overlay = "active_147";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume = 0.75;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 60;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local damage_regular_min = this.Math.floor(35 * this.m.DamageMult);
		local damage_regular_max = this.Math.floor(55 * this.m.DamageMult);
		local damage_direct_min = this.Math.floor(damage_regular_min * 0.3);
		local damage_direct_max = this.Math.floor(damage_regular_max * 0.3);
		local damage_armor_min = this.Math.floor(damage_regular_min * 1.25);
		local damage_armor_max = this.Math.floor(damage_regular_max * 1.25);

		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] damage to hitpoints, of which [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] can ignore armor"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_max + "[/color] damage to armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/difficulty_hard.png",
				text = "Affects all ensnared targets"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.DamageMult = _properties.IsSpecializedInNets ? 1.35 : 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local tentacles = this.getContainer().getActor().getTentacles();

		foreach ( t in tentacles )
		{
			if (t == null || t.isNull() || !t.isAlive() || t.isDying())
			{
				continue;
			}
			
			if (!t.isPlacedOnMap())
			{
				return true;
			}
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local allActors = this.Tactical.Entities.getAllInstancesAsArray();

		foreach ( a in allActors ) 
		{
			local skill = a.getSkills().getSkillByID("effects.kraken_ensnare");

		    if (skill == null)
		    {
		    	continue;
		    }

		    if (skill.m.ParentID != null && this.getContainer().getActor().getID() == skill.m.ParentID)
			{
				skill.applyDamage(true);
			}
		}
		
		return true;
	}

});

