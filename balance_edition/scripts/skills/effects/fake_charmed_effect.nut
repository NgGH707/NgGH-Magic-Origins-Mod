this.fake_charmed_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fake_charmed";
		this.m.Name = "Simp";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his master, your everyday simp no more no less.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Resolve"
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
		_properties.BraveryMult += 0.05;
	}

});

