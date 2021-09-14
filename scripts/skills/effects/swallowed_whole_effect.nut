this.swallowed_whole_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Name = ""
	},
	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return "Devoured " + this.m.Name;
	}

	function create()
	{
		this.m.ID = "effects.swallowed_whole";
		this.m.Name = "Devour";
		this.m.Icon = "skills/status_effect_72.png";
		this.m.IconMini = "status_effect_72_mini";
		this.m.Overlay = "status_effect_72";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	
	function getDescription()
	{
		return "This character has devoured [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Name + "[/color], and feeling all full.";
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

});

