this.perk_nggh_ghost_soul_eater <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ghost_soul_eater";
		this.m.Name = ::Const.Strings.PerkName.NggHGhostSoulEater;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGhostSoulEater;
		this.m.Icon = "ui/perks/siphon_circle.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_skill == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (_targetEntity.getTile().getDistanceTo(actor.getTile()) > 2)
		{
			return;
		}

		if ([
			"actives.ghastly_touch",
			"actives.ghost_phase",
			"actives.legend_banshee_scream"
		].find(_skill.getID()) == null)
		{
			return;
		}

		if (actor.isPlayerControlled() && ::Math.rand(1, 100) > 33)
		{
			return;
		}
		
		local NineLives = this.getContainer().getSkillByID("perk.nine_lives");

		if (NineLives != null)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " feasts on the soul of " + ::Const.UI.getColorizedEntityName(_targetEntity));
			}

			NineLives.addNineLivesCount();
		}
	}
});

