this.goblin_whip <- this.inherit("scripts/skills/skill", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.m.ID = "actives.goblin_whip";
		this.m.Name = "Whip!";
		this.m.Description = "Whip your goblin troops to remind them know who is the boss here. Stand your ground!";
		this.m.Icon = "skills/active_72.png";
		this.m.IconDisabled = "skills/active_72_sw.png";
		this.m.Overlay = "active_72";
		this.m.SoundOnUse = [
			"sounds/enemies/goblin_whip_00.wav",
			"sounds/enemies/goblin_whip_01.wav",
			"sounds/enemies/goblin_whip_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsShieldRelevant = false;
		this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
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
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the targeted [color=" + this.Const.UI.Color.DamageValue + "]goblin[/color] up to \'Confident\' if currently below"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of targeted goblin"
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getMoraleState() == this.Const.MoraleState.Confident)
		{
			return false;
		}

		return _targetTile.getEntity().getFlags().has("goblin");
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		
		if (!target.isHiddenToPlayer() || !_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onDelayedEffect.bindenv(this), target);
		}
		else
		{
			this.onDelayedEffect(target);
		}

		return true;
	}

	function onDelayedEffect( _target )
	{
		_target.getSkills().removeByID("effects.sleeping");
		
		if (_target.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			_target.checkMorale(this.Const.MoraleState.Steady - this.Const.MoraleState.Fleeing, 9000);
		}
		else
		{
			_target.checkMorale(3, 9000);
		}
	}

});

