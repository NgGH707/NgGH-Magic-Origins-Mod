::mods_hookExactClass("skills/injury/injury", function (obj)
{
	local ws_showInjury = obj.showInjury;
	obj.showInjury = function()
	{
		if (!this.getContainer().getActor().getFlags().has("human")) return;

		ws_showInjury();
	};
});