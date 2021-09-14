this.fake_charmed_2_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fake_charmed_2";
		this.m.Name = "Passionate Love";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "A big step in a relationship. This character is in love of someone in your company and feel great joy because of it. he\'s true with his own heart for his love is eternal and he will thoughtlessly die for it. This love will give him strength.";
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Resolve"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Initiative"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Max Fatigue"
			}
		];

		return ret;
	}
	
	function onUpdate( _properties )
	{
		_properties.DailyWageMult = 0.0;
	}

	function onAfterUpdate( _properties )
	{
		_properties.BraveryMult += 0.10;
		_properties.StaminaMult += 0.10;
		_properties.InitiativeMult += 0.05;
	}

});

