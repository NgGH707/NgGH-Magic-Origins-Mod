this.ghastly_touch_summon <- this.inherit("scripts/skills/skill", {
	m = {
		isGhost = false,
		damMax = 10,
		damMin = 5
	},
	function create()
	{
		this.m.ID = "actives.ghastly_touch";
		this.m.Name = "Ghastly Touch";
		this.m.Description = "A chilling touch that can easily drain the soul of some unfortunate victim. Armor or cloth is useless to stop this bone chilling touch.";
		this.m.KilledString = "Frightened to death";
		this.m.Icon = "skills/active_42.png";
		this.m.IconDisabled = "skills/active_42_sw.png";
		this.m.Overlay = "active_42";
		this.m.SoundOnUse = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to hit"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Completely ignores armor"
			}
		]);
		
		return ret;
	}

	function onAdded()
	{
		local type = this.m.Container.getActor().getType();
		
		if (type == this.Const.EntityType.Ghost)
		{
			this.m.isGhost = true;
			this.m.damMax = 25;
			this.m.damMin = 15;
		}
		else
		{
			this.m.ID = "actives.hand_to_hand";
			this.m.ActionPointCost = 4;
		}
	}
	
	function onUpdate( _properties )
	{
	}

	function isUsable()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local type = this.m.Container.getActor().getType();
		
		if (this.m.isGhost)
		{
			return this.skill.isUsable();
		}
		
		return (mainhand == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}
	
	function isHidden()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local type = this.m.Container.getActor().getType();
		
		if (this.m.isGhost)
		{
			return this.skill.isHidden();
		}
		
		if (this.getContainer().getActor().isPlacedOnMap() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return true;
		}
		
		return mainhand != null && (!this.getContainer().hasSkill("effects.disarmed") || !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())) || this.skill.isHidden();
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 10;
			_properties.DamageRegularMin = this.m.damMin;
			_properties.DamageRegularMax = this.m.damMax;
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}

});

