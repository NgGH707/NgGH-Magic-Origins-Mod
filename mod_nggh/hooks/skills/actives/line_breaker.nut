::mods_hookExactClass("skills/actives/line_breaker", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Using brute force to knock a target to the side so you can advance forward. Can be used on allies.";
		this.m.Icon = "skills/active_53.png";
		this.m.IconDisabled = "skills/active_53_sw.png";
		this.m.IsAttack = false;
	};
	obj.onAdded <- function()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI.getID() == ::Const.AI.Agent.ID.Player)
		{
			return;
		}

		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_line_breaker"));
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Knock a target to the side then move forward"
			}
		];
	}
});