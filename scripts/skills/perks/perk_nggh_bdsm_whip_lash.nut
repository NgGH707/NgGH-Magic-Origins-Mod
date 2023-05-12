this.perk_nggh_bdsm_whip_lash <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bdsm_whip_lash";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_WhipLash;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_WhipLash;
		this.m.Icon = "ui/perks/perk_bdsm_whip.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Last - 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isEquippedWithWhip()
	{
		local main = this.getContainer().getActor().getMainhandItem();
		return main != null && main.isWeaponType(::Const.Items.WeaponType.Whip);
	}

	function onAfterUpdate( _properties )
	{
		if (!this.isEquippedWithWhip()) return;

		_properties.MeleeSkill += ::Math.round(this.getContainer().getActor().getInitiative() * 0.15);
 	}

 	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || _skill.getID() != "actives.whip") return;

		if (_targetEntity == null) return;
			
		local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) - 1;
		_properties.MeleeDamageMult *= 1.0 + (0.12 * d);
		_properties.DamageDirectAdd += 0.06 * d;
	}

});

