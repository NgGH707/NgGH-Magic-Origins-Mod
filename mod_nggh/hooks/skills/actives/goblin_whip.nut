::mods_hookExactClass("skills/actives/goblin_whip", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Whip!";
		this.m.Description = "Whip your goblin troops to remind them know who is the boss here. Stand your ground!";
		this.m.Icon = "skills/active_72.png";
		this.m.IconDisabled = "skills/active_72_sw.png";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		this.m.IsWeaponSkill = false;
	};
	obj.onAdded <- function()
	{
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 11 : 5;
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the targeted [color=" + ::Const.UI.Color.DamageValue + "]goblin[/color] up to \'Confident\' if currently below"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of targeted goblin"
			}
		];
	};

	local ws_onDelayedEffect = obj.onDelayedEffect;
	obj.onDelayedEffect = function( _target )
	{
		_target.getSkills().removeByID("effects.sleeping");
		ws_onDelayedEffect(_target);
	}
});