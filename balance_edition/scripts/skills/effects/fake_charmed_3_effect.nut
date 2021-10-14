this.fake_charmed_3_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fake_charmed_3";
		this.m.Name = "Obsessive Simp";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "From a simple horny simp, this character has become a true simp. Simping is an obsession for this character, he will do everything to please his one true big boody girl. Donating his own house, murdering, stealing, whatever it is, he shall do it only to touch that sweet ass.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Max Fatigue"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Attack Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Chance to hit head"
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
		_properties.StaminaMult += 0.5;
		_properties.InitiativeMult += 0.05;
		_properties.DamageTotalMult += 0.05;
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});

