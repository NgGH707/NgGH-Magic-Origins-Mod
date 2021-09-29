this.mod_kraken_enrage_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_enrage";
		this.m.Name = "Enrage";
		this.m.Description = "Enters a state of aggression, become more and more ferocious.";
		this.m.Icon = "ui/perks/perk_madden_active.png";
		this.m.IconDisabled = "ui/perks/perk_madden_active_sw.png";
		this.m.Overlay = "perk_madden_active";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Become [color=" + this.Const.UI.Color.NegativeValue + "]Enraged[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Will lower your health down to [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] of max hitpoints"
			},
		];
	}

	function isHidden()
	{
		return this.getContainer().getActor().isEnraged();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local HP = _user.getHitpointsPct();

		if (HP > 0.5)
		{
			_user.setHitpointsPct(0.5);
		}

		_user.setEnraged(true);

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " becomes enraged");
		}

		return true;
	}

});

