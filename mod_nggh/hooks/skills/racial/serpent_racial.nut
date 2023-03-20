::mods_hookExactClass("skills/racial/serpent_racial", function(obj) 
{
	obj.m.IsPlayer <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Tough Scales";
		this.m.Description = "Serpents have tough scales that protect them from high heat and can also deflect firearm shots, making them quite resistant to those kinds of attack.";
		this.m.Icon = "skills/status_effect_113.png";
		this.m.IconMini = "status_effect_113_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.onAdded <- function()
	{
		this.m.IsPlayer = this.getContainer().getActor().isPlayerControlled();
	}
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
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+15[/color] Initiative For Turn Order while engaging in melee"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less Burning Damage"
			}
		];
	};
	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!::Tactical.isActive()) return;

		if (!actor.isPlacedOnMap()) return;

		if (!actor.m.IsActingEachTurn) return;

		if (this.m.IsPlayer)
		{
			if (!actor.getTile().hasZoneOfOccupationOtherThan(actor.getAlliedFactions())) return;

			_properties.InitiativeForTurnOrderAdditional += 15;
		}
		else
		{
			ws_onUpdate(_properties);
		}
	};
});