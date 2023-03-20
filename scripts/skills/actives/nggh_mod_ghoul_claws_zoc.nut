this.nggh_mod_ghoul_claws_zoc <- ::inherit("scripts/skills/skill", {
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
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsHidden = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
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
		return this.getContainer().getActor().getMainhandItem() != null;
	}

	function isUsable()
	{
		return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.getContainer().getActor().getCurrentProperties().IsAbleToUseWeaponSkills);
	}

	function onUpdate( _properties )
	{
		local size = this.getContainer().getActor().getSize();
		this.m.ChanceDecapitate = 25 * size;
		this.m.ChanceDisembowel = 25 * size;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectClaws);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

