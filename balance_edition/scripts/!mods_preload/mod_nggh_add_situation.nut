this.getroottable().Nggh_MagicConcept.hookAddSituation <- function ()
{
	::mods_hookNewObject("factions/actions/add_random_situation_action", function ( obj )
	{
		local ws_onUpdate = ::mods_getMember(obj, "onUpdate")
		obj.onUpdate = function( _faction )
		{
			ws_onUpdate(_faction);

			if (this.m.Score == 0 || this.m.Situation == "" || this.m.Situation == null)
			{
				if (this.m.Settlement == null)
				{
					this.m.Settlement = _faction.getSettlements()[this.Math.rand(0, _faction.getSettlements().len() - 1)];
				}

				if (_faction.getType() == this.Const.FactionType.NobleHouse && !this.m.Settlement.isMilitary())
				{
					return;
				}

				if (this.m.Settlement.getSituations().len() >= 2)
				{
					return;
				}

				if (this.m.Settlement.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) <= 10)
				{
					return;
				}

				if (this.m.Settlement.hasSituation("situation.raided") || this.m.Settlement.hasSituation("situation.besieged") || this.m.Settlement.hasSituation("situation.short_on_food"))
				{
					return;
				}

				local chance = this.World.Assets.getOrigin().getID() == "scenario.mage_trio" ? 10 : 5;

				if (this.Math.rand(1, 100) > chance)
				{
					return;
				}
				
				this.m.Situation = "mc_wandering_mage_situation";
				this.m.Score = 1;
			}
		}
	});

	delete this.Nggh_MagicConcept.hookAddSituation;
}