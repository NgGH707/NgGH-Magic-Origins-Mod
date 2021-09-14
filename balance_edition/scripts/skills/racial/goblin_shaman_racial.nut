this.goblin_shaman_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.goblin_shaman";
		this.m.Name = "Shaman Trick";
		this.m.Description = "Has a high chance to act first at the start of battle";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
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
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+100[/color] Initiative to Turn Order for the first turn"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onUpdate( _properties )
	{	
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 1 && !this.Tactical.State.isScenarioMode())
		{
			_properties.InitiativeForTurnOrderAdditional += 100;
		}
	}

});

