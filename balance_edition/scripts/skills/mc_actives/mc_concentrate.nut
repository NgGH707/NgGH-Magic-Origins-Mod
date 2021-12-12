this.mc_concentrate <- this.inherit("scripts/skills/skill", {
	m = {},
	
	function create()
	{
		this.m.ID = "actives.mc_concentrate";
		this.m.Name = "Concentrate";
		this.m.Description = "Gather all your mental strength and willpower to enhance your resolve for one turn. Remember, pain can make you lose concentration.";
		this.m.Icon = "skills/active_mc_04.png";
		this.m.IconDisabled = "skills/active_mc_04_sw.png";
		this.m.Overlay = "active_mc_04";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getFatigueCost()
	{
		if (this.m.Container != null)
		{
			return this.skill.getFatigueCost();
		}
		else
		{
			return 5;
		}
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Grant [color=" + this.Const.UI.Color.PositiveValue + "]Concentrate[/color] which gives [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Resolve per stack"
			}
		];
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local effect = this.getContainer().getSkillByID("special.mc_focus");

		if (effect != null)
		{
			return effect.m.Count < 10;
		}
		else 
		{
			return true;    
		}
		
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Container.add(this.new("scripts/skills/special/mc_focus"));

		if (!_user.isHiddenToPlayer())
		{
			_user.playSound(this.Const.Sound.ActorEvent.Fatigue, this.Const.Sound.Volume.Actor * _user.getSoundVolume(this.Const.Sound.ActorEvent.Fatigue));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Concentrate");
		}

		return true;
	}

});

