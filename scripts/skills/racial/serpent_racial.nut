this.serpent_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.serpent";
		this.m.Name = "Resistance Scales";
		this.m.Description = "Serpents have tough scales that can deflect firearm shots, making them quite resistant to that kind of attack.";
		this.m.Icon = "skills/status_effect_113.png";
		this.m.IconMini = "status_effect_113_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+15[/color] Initiative For Turn Order"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + this.Const.UI.Color.NegativeValue + "]33%[/color] less damage from firearms"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onRoundEnd()
	{
		this.getContainer().update();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		if (!actor.isPlacedOnMap() || myTile.hasZoneOfOccupationOtherThan(actor.getAlliedFactions()))
		{
			return;
		}
		
		if (this.getContainer().getActor().isPlayerControlled())
		{
			_properties.InitiativeForTurnOrderAdditional += 15;
			
			return;
		}
		
		local targets = actor.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.Idle).queryTargetsInMeleeRange(2, 3);

		if (targets.len() == 0)
		{
			return;
		}

		local hasPotentialTarget = false;

		foreach( t in targets )
		{
			if (t.getTile().getZoneOfControlCountOtherThan(t.getAlliedFactions()) <= 1)
			{
				hasPotentialTarget = true;
				break;
			}
		}

		if (!hasPotentialTarget)
		{
			return;
		}

		_properties.InitiativeForTurnOrderAdditional += 15;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}

		if (_skill.getID() == "actives.fire_handgonne" || _skill.getID() == "actives.ignite_firelance")
		{
			_properties.DamageReceivedRegularMult *= 0.66;
		}
	}

});

