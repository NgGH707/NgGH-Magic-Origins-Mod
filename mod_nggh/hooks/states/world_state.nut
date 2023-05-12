::mods_hookExactClass("states/world_state", function(obj)
{
	local ws_onDeserialize = obj.onDeserialize;
	obj.onDeserialize = function(_in)
	{
		ws_onDeserialize(_in);

		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (!bro.getFlags().has("Hexe")) continue;

			if (bro.getFlags().get("HasBeenResetPerk")) continue;

			if (bro.getNameOnly().find("Artemis Snow") == null) continue;

			bro.getFlags().set("HasBeenResetPerk", true);
			bro.getBackground().forceResetCustomPerkTree();

			local b = bro.getBaseProperties();
			b.Stamina += 14;
			b.MeleeSkill += 15;
			b.RangedSkill -= 15;
			b.MeleeDefense += 4;
			b.Initiative += 5;

			bro.getSkills().update();
			break;
		}
	}
});