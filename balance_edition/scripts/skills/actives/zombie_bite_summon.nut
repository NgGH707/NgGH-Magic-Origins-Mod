this.zombie_bite_summon <- this.inherit("scripts/skills/skill", {
	m = {
		isVampire = false
	},
	function create()
	{
		this.m.ID = "actives.zombie_bite";
		this.m.Name = "Bite";
		this.m.Description = "Ripping off your enemy face with your own mouth. Do poorly against armor.";
		this.m.KilledString = "Bitten to Death";
		this.m.Icon = "skills/active_24.png";
		this.m.IconDisabled = "skills/active_24_sw.png";
		this.m.Overlay = "active_24";
		this.m.SoundOnUse = [
			"sounds/enemies/zombie_bite_01.wav",
			"sounds/enemies/zombie_bite_02.wav",
			"sounds/enemies/zombie_bite_03.wav",
			"sounds/enemies/zombie_bite_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		
		if (!this.m.isVampire)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] chance to hit"
			});
		}
		
		return ret;
	}
	
	function onAdded()
	{
		local type = this.m.Container.getActor().getType();
		
		if (type == this.Const.EntityType.Vampire)
		{
			this.m.isVampire = true;
			this.m.Icon = "skills/active_24_a.png";
			this.m.IconDisabled = "skills/active_24_a_sw.png";
		}
	}
	
	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}
	
	function isRangedZombie()
	{
		local type = this.m.Container.getActor().getType();
		
		if (type == 106 || type == 107 || type == 108)
		{
			return true
		}
		
		return false
	}

	function isUsable()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local type = this.m.Container.getActor().getType();
		
		if (this.isRangedZombie() || type == this.Const.EntityType.Vampire)
		{
			return this.skill.isUsable();
		}
		
		return (mainhand == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}
	
	function isHidden()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local type = this.m.Container.getActor().getType();
		
		if (this.isRangedZombie() || type == this.Const.EntityType.Vampire)
		{
			return this.skill.isHidden();
		}
		
		return mainhand != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 5;
			_properties.DamageRegularMin = 15;
			_properties.DamageRegularMax = 30;
			_properties.DamageArmorMult *= 0.5;
			_properties.HitChance[this.Const.BodyPart.Head] += 15;
			
			if (this.m.isVampire)
			{
				_properties.MeleeSkill -= 15;
				_properties.DamageRegularMin += 4;
				_properties.DamageRegularMax += 11;
				_properties.HitChance[this.Const.BodyPart.Head] += 100;
			}
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
			
			if (this.isRangedZombie())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

