this.ghoul_claws_zoc <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ghoul_claws_zoc";
		this.m.Name = "Ghoul Claws";
		this.m.Description = "Long and sharp claws that can tear flesh with ease.";
		this.m.KilledString = "Ripped to shreds";
		this.m.Icon = "skills/active_21.png";
		this.m.IconDisabled = "skills/active_21_sw.png";
		this.m.Overlay = "active_21";
		this.m.SoundOnUse = [
			"sounds/enemies/ghoul_claws_01.wav",
			"sounds/enemies/ghoul_claws_02.wav",
			"sounds/enemies/ghoul_claws_03.wav",
			"sounds/enemies/ghoul_claws_04.wav",
			"sounds/enemies/ghoul_claws_05.wav",
			"sounds/enemies/ghoul_claws_06.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsHidden = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 6;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 33;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function isIgnoredAsAOO()
	{
		return this.m.Container.getActor().getMainhandItem() != null;
	}

	function isUsable()
	{
		return this.m.IsUsable && this.m.Container.getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.m.Container.getActor().getCurrentProperties().IsAbleToUseWeaponSkills);
	}

	function onUpdate( _properties )
	{
		local size = this.getContainer().getActor().getSize();
		this.m.ChanceDecapitate = 25 * size;
		this.m.ChanceDisembowel = 25 * size;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectClaws);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

