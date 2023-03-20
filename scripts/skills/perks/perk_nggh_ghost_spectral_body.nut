this.perk_nggh_ghost_spectral_body <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ghost_spectral_body";
		this.m.Name = ::Const.Strings.PerkName.NggHGhostSpectralBody;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGhostSpectralBody;
		this.m.Icon = "ui/perks/legend_vala_warden.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedRangedMult = 0.0;
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		local dist = _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile());

		if (dist <= 1)
		{
			_properties.MeleeDefense += 10;
			_properties.RangedDefense += 10;
		}
	}

});

