::mods_hookExactClass("skills/injury_permanent/permanent_injury", function (obj)
{
	local ws_onAdded = obj.onAdded;
	obj.onAdded = function()
	{
		if (!this.getContainer().getActor().getFlags().has("human")) return;

		ws_onAdded();
	};
	local ws_showInjury = obj.showInjury;
	obj.showInjury = function()
	{
		if (!this.getContainer().getActor().getFlags().has("human")) return;

		ws_showInjury();
	};
	local ws_onCombatFinished = obj.onCombatFinished;
	obj.onCombatFinished = function()
	{
		if (!this.getContainer().getActor().getFlags().has("human")) return;

		ws_onCombatFinished();
	};
});