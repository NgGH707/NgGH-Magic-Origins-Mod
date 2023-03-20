this.perk_nggh_charm_enemy_ghoul <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_ghoul";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmEnemyGhoul;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmEnemyGhoul;
		this.m.Icon = "ui/perks/charmed_ghoul_01.png";
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
			actor.setHitpoints(::Math.floor(actor.getHitpoints() * 1.10));
		}
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.10;
		_properties.InitiativeMult *= 1.05;
	}
	
});