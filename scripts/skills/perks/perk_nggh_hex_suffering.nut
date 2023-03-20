this.perk_nggh_hex_suffering <- ::inherit("scripts/skills/perk_nggh_hex", {
	m = {
		Mult = 1.18
	},
	function create()
	{
		this.perk_nggh_hex.create();
		this.m.ID = "perk.hex_suffering";
		this.m.HexType = ::Const.Hex.Type.Suffering;
		this.m.Name = ::Const.Strings.PerkName.NggHHexSuffering;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexSuffering;
		this.m.PerkGroup = ::Const.Perks.HexeSpecializedHexTree;
		this.m.Icon = "ui/perks/perk_hex_cyan.png";
		this.m.Color =::createColor("#06ffd9");
		this.m.ColorName = "cyan";
	}

	function onAdded()
	{
		this.perk_nggh_hex.onAdded();

		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			actor.setHitpoints(::Math.floor(actor.getHitpoints() * this.m.Mult));
		}

		local skill_container = this.getContainer().get();
		skill_container.m.IsRedirect <- false;
		skill_container.setRedirect <- function( _f )
		{
			this.m.IsRedirect = _f;
		};
		skill_container.redirectSkill <- function( _skill, _order = 0 )
		{
			if (::Const.Hex.Suffering_AffectedEffects.find(_skill.getID()) == null) return false;

			local hex = this.getSkillByID("effects.hex_master");

			if (hex == null) return false;

			if (hex.getSlave().len() == 0) return false;

			foreach (s in hex.getSlave())
			{
				if (s == null || s.isNull())
				{
					continue;
				}
				
				s.getContainer().add(_skill, _order);
				return true;
			}

			return false;
		};
		local ws_add = skill_container.add;
		skill_container.add = function( _skill, _order = 0 )
		{
			if (this.m.IsRedirect && this.redirectSkill(_skill, _order))
			{
				return;
			}

			ws_add(_skill, _order);
		};
	}

	function onRemoved()
	{
		this.perk_nggh_hex.onRemoved();
		this.getContainer().setRedirect(false);
	}

	function onHex( _targetEntity, _masterHex, _slaveHex )
	{
		this.perk_nggh_hex.onHex(_targetEntity, _masterHex, _slaveHex);

		_masterHex.m.AdditionalTooltips.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Forces your hexed victim(s) to suffer certain types of [color=" + ::Const.UI.Color.NegativeValue + "]Negative[/color] status effect in place of you"
		});

		foreach (id in ::Const.Hex.Suffering_AffectedEffects)
		{
			local effects = this.getContainer().getAllSkillsByID(id);

			if (effects.len() == 0) continue;

			foreach (e in effects)
			{
				this.getContainer().remove(e);

				if (!e.isGarbage())
				{
					_targetEntity.getSkills().add(e);
				}
			}
		}

		this.getContainer().setRedirect(true);
	}

	function getAdditionalTooltips()
	{
		return [
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has to suffer certain types of [color=" + ::Const.UI.Color.NegativeValue + "]Negative[/color] status effect in place of the hexer"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= this.m.Mult;
	}

});

