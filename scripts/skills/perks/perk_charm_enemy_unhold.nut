this.perk_charm_enemy_unhold <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.charm_enemy_unhold";
		this.m.Name = this.Const.Strings.PerkName.CharmEnemyUnhold;
		this.m.Description = this.Const.Strings.PerkDescription.CharmEnemyUnhold;
		this.m.Icon = "ui/perks/charmed_unhold_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onAdded()
	{
		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			actor.setHitpoints(this.Math.floor(actor.getHitpoints() * 1.10));
		}
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.10;
		_properties.StaminaMult *= 1.10;
	}
	
});