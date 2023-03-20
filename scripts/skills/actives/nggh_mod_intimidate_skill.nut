this.nggh_mod_intimidate_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.intimidate";
		this.m.Name = "Intimidate";
		this.m.Description = "Frighten foes with your fierce appearance, make they hesitate to act and more likely to miss their attacks or being scared. ";
		this.m.Icon = "ui/perks/active_intimidate.png";
		this.m.IconDisabled = "ui/perks/active_intimidate_sw.png";
		this.m.Overlay = "active_intimidate";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 36;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function onAdded()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player && AI.findBehavior(::Const.AI.Behavior.ID.Warcry) == null)
		{
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_warcry"));
		}
	}
	
	function getTooltip()
	{
		local ret = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Applies [color=" + ::Const.UI.Color.NegativeValue + "]Intimidated[/color] effect to any enemy within [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles radius"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Causes a [color=" + ::Const.UI.Color.NegativeValue + "]Morale Check[/color] to any enemy within [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles radius"
			}
		];

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses " + this.getName());
		}

		::Time.scheduleEvent(::TimeUnit.Virtual, 1000, this.onDelayedEffect.bindenv(this), _user);
		return true;
	}

	function onDelayedEffect( _user )
	{
		local myTile = _user.getTile();

		foreach( a in ::Tactical.Entities.getHostileActors(_user.getFaction(), myTile, this.getMaxRange()) )
		{
			if (a.getMoraleState() == ::Const.MoraleState.Ignore)
			{
				continue;
			}

			local difficulty = ::Math.pow(myTile.getDistanceTo(a.getTile()), ::Const.Morale.AllyKilledDistancePow);
			local effect = ::new("scripts/skills/effects/nggh_mod_intimidated_effect");
			
			if(!a.checkMorale(-1, -difficulty, ::Const.MoraleCheckType.MentalAttack))
			{
				effect.m.IsWorsen = true;
			}

			a.getSkills().add(effect);
		}
	}


});

