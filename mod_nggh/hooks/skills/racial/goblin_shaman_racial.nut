::mods_hookExactClass("skills/racial/goblin_shaman_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Prepared";
		this.m.Description = "Has a higher chance to act first at the start of each battle.";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
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
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]+100[/color] Initiative to Turn Order in the first round"
			}
		];
	};
	obj.onUpdate = function( _properties )
	{	
		if (::Tactical.isActive() && ::Time.getRound() <= 1)
		{
			_properties.InitiativeForTurnOrderAdditional += 100;
		}
	}
});