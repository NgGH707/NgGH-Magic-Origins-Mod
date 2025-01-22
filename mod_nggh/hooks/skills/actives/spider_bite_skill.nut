::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/spider_bite_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "A spider bite that can leave nasty wounds. Deal more damage to target get entangled in web or any kind of ensnare.";
		m.KilledString = "Ripped to shreds";
		m.Icon = "skills/active_115.png";
		m.IconDisabled = "skills/active_115_sw.png";
		m.InjuriesOnBody = ::Const.Injury.CuttingAndPiercingBody;
		m.InjuriesOnHead = ::Const.Injury.CuttingAndPiercingHead;
	}

	q.getTooltip <- function()
	{
		return getDefaultTooltip();
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = getContainer().getActor();

		if (::MSU.isKindOf(actor, "player"))
			m.ActionPointCost -= 1;

		m.FatigueCostMult = getContainer().hasSkill("perk.spider_bite") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
});