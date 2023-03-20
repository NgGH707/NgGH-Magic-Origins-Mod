::mods_hookExactClass("ai/tactical/agents/ghost_agent", function ( obj )
{
	local ws_onAddBehaviors = obj.onAddBehaviors;
	obj.onAddBehaviors = function()
	{
		ws_onAddBehaviors();
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_ghost_possess"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
	}
});