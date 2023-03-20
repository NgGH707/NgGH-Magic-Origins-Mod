this.perk_nggh_charm_enemy_unhold <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_unhold";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyUnhold;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyUnhold;
		this.m.Icon = "ui/perks/charmed_unhold_01.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAdded()
	{
		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			actor.setHitpoints(::Math.floor(actor.getHitpoints() * 1.15));
		}
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.15;
		_properties.StaminaMult *= 1.10;
	}
	
});