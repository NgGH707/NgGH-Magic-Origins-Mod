this.gorge_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.gorge";
		this.m.Name = "Gorge";
		this.m.Description = "A powerful attack that can be used at a distance.";
		this.m.Icon = "skills/active_107.png";
		this.m.IconDisabled = "skills/active_107_sw.png";
		this.m.Overlay = "active_107";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_01.wav",
			"sounds/enemies/lindwurm_gorge_02.wav",
			"sounds/enemies/lindwurm_gorge_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/lindwurm_gorge_hit_01.wav",
			"sounds/enemies/lindwurm_gorge_hit_02.wav",
			"sounds/enemies/lindwurm_gorge_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.DirectDamageMult = 0.4;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 80;
		_properties.DamageRegularMax += 140;
		_properties.DamageArmorMult *= 1.5;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

