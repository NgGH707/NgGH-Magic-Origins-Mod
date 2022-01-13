this.spider_bite_skill <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "actives.spider_bite";
		this.m.Name = "Webknecht Bite";
		this.m.Description = "A spider bite that can leave nasty wounds. Deal more damage to target get entangled in web or any kind of ensnare.";
		this.m.KilledString = "Ripped to shreds";
		this.m.Icon = "skills/active_115.png";
		this.m.IconDisabled = "skills/active_115_sw.png";
		this.m.Overlay = "active_115";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_attack_01.wav",
			"sounds/enemies/dlc2/giant_spider_attack_02.wav",
			"sounds/enemies/dlc2/giant_spider_attack_03.wav",
			"sounds/enemies/dlc2/giant_spider_attack_04.wav",
			"sounds/enemies/dlc2/giant_spider_attack_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/giant_spider_attack_hit_01.wav",
			"sounds/enemies/dlc2/giant_spider_attack_hit_02.wav",
			"sounds/enemies/dlc2/giant_spider_attack_hit_03.wav",
			"sounds/enemies/dlc2/giant_spider_attack_hit_04.wav",
			"sounds/enemies/dlc2/giant_spider_attack_hit_05.wav",
			"sounds/enemies/dlc2/giant_spider_attack_hit_06.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.IsSerialized = false;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function onAdded()
	{
		local actor = this.m.Container.getActor();

		if (!actor.isPlayerControlled() || actor.isSummoned())
		{
			return;
		}

		this.m.ActionPointCost = 5;
	}
	
	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 20;
		_properties.DamageRegularMax += 40;
		_properties.DamageArmorMult *= 0.7;
		
		if (this.m.Container.getActor().isPlayerControlled())
		{
			_properties.DamageRegularMin += 10;
			_properties.DamageRegularMax += 5;
		}
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_bite") ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

