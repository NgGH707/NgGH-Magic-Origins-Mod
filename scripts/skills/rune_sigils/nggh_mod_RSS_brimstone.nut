this.nggh_mod_RSS_brimstone <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
	},
	function create()
	{
		this.m.ID = "special.mod_RSS_brimstone";
		this.m.Name = "Rune Sigil: Brimstone";
		this.m.Description = "Rune Sigil: Brimstone";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		_properties.IsImmuneToFire = true;
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			local myTile = actor.getTile();
			local type = [
				"legend_firefield",
				"fire",
				"alp_hellfire",
				"legend_holyflame",
			];

			if (myTile.Properties.Effect != null && type.find(myTile.Properties.Effect.Type) != null)
			{
				_properties.FatigueRecoveryRate += 10;
				_properties.DamageReceivedRegularMult *= 0.85;
			}
		}
	}

});

