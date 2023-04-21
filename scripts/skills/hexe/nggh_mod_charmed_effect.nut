// this effect is only for ai only, never give a player this effect
this.nggh_mod_charmed_effect <- ::inherit("scripts/skills/effects/charmed_effect", {
	m = {
		IsBodyguard = false,
		IsTheLastEnemy = false,
		IsSuicide = false,
		IsDead = false
	},
	function isTheLastEnemy( _v )
	{
		this.m.IsTheLastEnemy = _v;
	}
	
	function setMaster( _f )
	{
		this.m.Master = ::WeakTableRef(_f);
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local brush = "bust_base_beasts";

		/*
		if (actor.getAIAgent().getBehavior(::Const.AI.Behavior.ID.Protect) != null)
		{
			this.m.IsBodyguard = true;
			actor.getAIAgent().removeBehavior(::Const.AI.Behavior.ID.Protect);
		}
		*/

		this.charmed_effect.onAdded();

		if (this.isGarbage())
		{
			return;
		}

		if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.getContainer() != null && this.m.Master.getContainer().getActor() != null)
		{
			brush = this.m.Master.getContainer().getActor().getSprite("socket").getBrush().Name;
		}

		if (this.m.IsTheLastEnemy)
		{
			actor.killSilently();
			return;
		}

		// change ai agent
		this.m.OriginalAgent = actor.getAIAgent();
		actor.setAIAgent(::new("scripts/ai/tactical/player_agent"));
		actor.getAIAgent().setActor(actor);
		actor.m.IsControlledByPlayer = true;

		actor.getSprite("socket").setBrush(brush);
		actor.getFlags().set("Charmed", true);
		actor.setDirty(true);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.getContainer() != null && this.m.Master.getContainer().getActor() != null && !this.m.Master.getContainer().getActor().isNull())
		{
			local charmer = this.m.Master.getContainer().getActor();
			local XPkiller = ::Math.floor(_targetEntity.getXPValue() * ::Const.XP.XPForKillerPct);
			charmer.addXP(XPkiller);

			local stat_collector = charmer.getSkills().getSkillByID("special.stats_collector");

			if (stat_collector != null)
			{
				stat_collector.onTargetKilled(_targetEntity, _skill);
			}

			local XPgroup = _targetEntity.getXPValue() * (1.0 - ::Const.XP.XPForKillerPct);
			local brothers = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);

			if (brothers.len() == 1)
			{
				if (charmer.getSkills().hasSkill("trait.oath_of_distinction"))
				{
					return;
				}

				charmer.addXP(XPgroup);
			}
			else
			{
				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().IsAllyXPBlocked)
					{
						return;
					}

					bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
				}
			}

			foreach( bro in ::World.getPlayerRoster().getAll() )
			{
				if (bro.isInReserves() && bro.getSkills().hasSkill("perk.legend_peaceful"))
				{
					bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
				}
			}
		}
	}

	function onRemoved()
	{
		local hasMaster = this.m.Master != null && !this.m.Master.isNull();

		if (hasMaster)
		{
			this.m.Master.setCooldown(1);
		}
		else
		{
			this.m.Master = null;
		}

		if (hasMaster && (this.m.IsSuicide || this.m.IsDead))
		{
			this.m.Master.removeSlave(this.getContainer().getActor().getID());
			this.m.Master = null;
		}
		else
		{
			this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_charm_resistance_effect"));
		}
		
		this.getContainer().getActor().m.IsControlledByPlayer = false;
		this.charmed_effect.onRemoved();

		/*
		if (this.m.IsBodyguard)
		{
			this.getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_protect"));
		}
		*/
	}

	function onCombatFinished()
	{
		this.m.IsSuicide = true;
		local actor = this.getContainer().getActor();
		local troop = actor.getWorldTroop();

		if (troop != null && ("Party" in troop) && troop.Party != null && !troop.Party.isNull())
		{
			troop.Party.removeTroop(troop);
		}

		this.charmed_effect.onCombatFinished();
	}

	function onDeath( _fatalityType )
	{
		this.m.IsDead = true;
		this.onRemoved();
	}

});

