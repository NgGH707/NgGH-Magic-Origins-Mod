::mods_hookExactClass("skills/actives/legend_flogging", function ( obj )
{
	obj.onAfterUpdate <- function( _properties )
	{
		if (_properties.IsSpecializedInWhips)
		{
			this.m.ActionPointCost -= 1;
		}
		
		local special = this.getContainer().getSkillByID("perk.bdsm_mask_on");

		if (special != null)
		{
			this.m.FatigueCost = ::Math.max(1, this.m.FatigueCost - special.getBonus());
		}
	}
});