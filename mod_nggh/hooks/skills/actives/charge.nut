::mods_hookExactClass("skills/actives/charge", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Throw yourself at the enemies and slam at them with your hugemungus body.";
		this.m.Icon = "skills/active_52.png";
		this.m.IconDisabled = "skills/active_52_sw.png";
	};
	obj.onAdded <- function()
	{
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 30 : 25;
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI.getID() == ::Const.AI.Agent.ID.Player)
		{
			return;
		}

		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_charge"));
		AI.m.Properties.EngageRangeMin = 1;
		AI.m.Properties.EngageRangeMax = 2;
		AI.m.Properties.EngageRangeIdeal = 2;
	};
	local getTooltip = obj.getTooltip;
	obj.getTooltip = function()
	{
		local ret = getTooltip();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can cause [color=" + ::Const.UI.Color.NegativeValue + "]Stun[/color]"
			}
		])

		return ret;
	};
	obj.isUsable = function()
	{
		return !::Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().isEngagedInMelee();
	};
});