this.fake_charmed_0_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fake_charmed_0";
		this.m.Name = "Banned Simp";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "Due to recent event this character has been through a harsh time. He has been temporarily banned from OnlyFans. Still horny but have no mean to subdue it.";
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
			}
		];
	}
	
	function onUpdate( _properties )
	{
		_properties.DailyWageMult = 0.0;
	}

});

