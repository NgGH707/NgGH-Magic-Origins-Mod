::mods_hookExactClass("skills/actives/throw_dirt_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Play nice would not grant you victory everytime, a little dirty trick can easily boost your win chance. Wild Nomad uses sand-attack!!!";
		this.m.Icon = "skills/active_215.png";
		this.m.IconDisabled = "skills/active_215_sw.png";
		this.m.IsUsingHitchance = false;
	};
	obj.getTooltip <- function()
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Throws dirt or sand at the enemy face"
			}
		];
		return ret;
	};
	obj.isUsable = function()
	{
		return this.skill.isUsable();
	};
	obj.onAfterUpdate <- function( _properties )
	{
		if (this.getContainer().getActor().isPlayerControlled())
			this.m.FatigueCost += 7;

	};
});