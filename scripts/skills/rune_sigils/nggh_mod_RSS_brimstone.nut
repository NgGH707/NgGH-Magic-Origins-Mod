nggh_mod_RSS_brimstone <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRssBrimstone);
		m.Description = "Rune Sigil: Brimstone";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onAfterUpdate( _properties )
	{
		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		_properties.IsImmuneToFire = true;
		local actor = getContainer().getActor();

		if (actor.isPlacedOnMap()) {
			local myTile = actor.getTile();
			local type = [
				"legend_firefield",
				"fire",
				"alp_hellfire",
				"legend_holyflame",
			];

			if (myTile.Properties.Effect != null && type.find(myTile.Properties.Effect.Type) != null) {
				_properties.FatigueRecoveryRate += 10;
				_properties.DamageReceivedRegularMult *= 0.85;
			}
		}
	}

});

