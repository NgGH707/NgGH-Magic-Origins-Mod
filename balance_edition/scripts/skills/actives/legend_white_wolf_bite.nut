this.legend_white_wolf_bite <- this.inherit("scripts/skills/skill", {
	m = {
		IsRestrained = false,
		IsSpent = false
	},
	function setRestrained( _f )
	{
		this.m.IsRestrained = _f;
	}
	
	function create()
	{
		this.m.ID = "actives.legend_whit_wolf_bite";
		this.m.Name = "White Direwolf Bite";
		this.m.Description = "Ripping off your enemy face with your powerful white wolf jaw.";
		this.m.KilledString = "Ripped to shreds";
		this.m.Icon = "skills/active_71.png";
		this.m.IconDisabled = "skills/active_71_sw.png";
		this.m.Overlay = "active_71";
		this.m.SoundOnUse = [
			"sounds/enemies/wolf_bite_01.wav",
			"sounds/enemies/wolf_bite_02.wav",
			"sounds/enemies/wolf_bite_03.wav",
			"sounds/enemies/wolf_bite_04.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/werewolf_claw_hit_01.wav",
			"sounds/enemies/werewolf_claw_hit_02.wav",
			"sounds/enemies/werewolf_claw_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}
	
	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}
	
	function onAdded()
	{
		this.m.ActionPointCost = this.m.Container.getActor().isPlayerControlled() ? 4 : 6;
		this.m.FatigueCost = this.m.Container.getActor().isPlayerControlled() ? 10 : 20;

		if (this.getContainer().getActor().getFlags().has("bewitched"))
		{
			this.m.IsHidden = true;
		}
	}
	
	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function onUpdate( _properties )
	{
		if (!this.m.IsRestrained)
		{
			_properties.DamageRegularMin += 45;
			_properties.DamageRegularMax += 75;
			_properties.DamageArmorMult *= 0.8;
		}
	}
	
	function onTurnStart()
	{
		this.m.IsSpent = false;
	}
	
	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.IsRestrained)
		{
			this.m.IsSpent = true;
		}

		return this.attackEntity(_user, _targetTile.getEntity());
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this && this.m.IsRestrained)
		{
			_properties.DamageRegularMin += 45;
			_properties.DamageRegularMax += 75;
			_properties.DamageArmorMult += 0.8;

			local items = this.m.Container.getActor().getItems();
			local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (mhand != null)
			{
				_properties.DamageRegularMin -= mhand.m.RegularDamage;
				_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
				_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
			}
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}

});

