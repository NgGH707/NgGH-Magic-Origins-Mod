this.fake_charmed_1_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fake_charmed_1";
		this.m.Name = "Enduring Love";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "From a captive of charm, This character is starting to be lover of some kind. In love of someone in your company, though not really with his own hearth.";
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
		_properties.InitiativeMult += 0.05;
	}

});

