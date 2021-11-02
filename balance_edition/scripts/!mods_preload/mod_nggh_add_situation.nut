this.getroottable().Nggh_MagicConcept.hookAddSituation <- function ()
{
	::mods_hookNewObject("factions/actions/add_random_situation_action", function ( obj )
	{
		local oldFunction = ::mods_getMember(obj, "onUpdate")
		obj.onUpdate = function( _faction )
		{
			oldFunction(_faction);

			if (this.m.Score == 0 || this.m.Situation == "" || this.m.Situation == null)
			{
				return;
			}

			local chance = this.Math.rand(1, 100) <= 5;
			this.m.Situation = chance ? "mc_wandering_mage_situation" : this.m.Situation;
			this.m.Score = 1;
		}
	});

	delete this.Nggh_MagicConcept.hookAddSituation;
}