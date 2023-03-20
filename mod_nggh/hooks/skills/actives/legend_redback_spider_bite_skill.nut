::mods_hookExactClass("skills/actives/legend_redback_spider_bite_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "A spider bite that can leave nasty wounds. Deal more damage to target get entangled in web or any kind of ensnare.";
		this.m.KilledString = "Ripped to shreds";
		this.m.Icon = "skills/active_115.png";
		this.m.IconDisabled = "skills/active_115_sw.png";
		this.m.InjuriesOnBody = ::Const.Injury.CuttingAndPiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingAndPiercingHead;
	};
	obj.onAdded <- function()
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlayerControlled() || actor.isSummoned())
		{
			return;
		}

		this.m.ActionPointCost = 5;
		this.m.DirectDamageMult += 0.1;
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultTooltip();
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_bite") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
});