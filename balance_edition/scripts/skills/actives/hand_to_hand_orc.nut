this.hand_to_hand_orc <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hand_to_hand";
		this.m.Name = "Hand-to-Hand Attack";
		this.m.KilledString = "Pummeled to death";
		this.m.Icon = "skills/active_222.png";
		this.m.IconDisabled = this.m.Icon;
		this.m.Overlay = "active_222";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsSerialized = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return (mainhand == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}

	function isHidden()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return mainhand != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
	}

	function onUpdate( _properties )
	{
		if (this.isUsable())
		{
			_properties.DamageRegularMin = 15;
			_properties.DamageRegularMax = 30;
			_properties.DamageArmorMult = 0.7;
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

