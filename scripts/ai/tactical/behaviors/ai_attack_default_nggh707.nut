this.ai_attack_default_nggh707 <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.hand_to_hand",
			"actives.chop",
			"actives.slash",
			"actives.slash_lightning",
			"actives.thrust",
			"actives.impale",
			"actives.strike",
			"actives.rupture",
			"actives.crumble",
			"actives.prong",
			"actives.stab",
			"actives.bash",
			"actives.cleave",
			"actives.hammer",
			"actives.overhead_strike",
			"actives.smite",
			"actives.cudgel",
			"actives.whip",
			"actives.zombie_bite",
			"actives.hyena_bite",
			"actives.werewolf_bite",
			"actives.ghoul_claws",
			"actives.ghastly_touch",
			"actives.nightmare",
			"actives.flail",
			"actives.pound",
			"actives.cascade",
			"actives.split_man",
			"actives.batter",
			"actives.throw_javelin",
			"actives.throw_axe",
			"actives.throw_balls",
			"actives.throw_spear",
			"actives.wardog_bite",
			"actives.warhound_bite",
			"actives.wolf_bite",
			"actives.gorge",
			"actives.spider_bite",
			"actives.uproot_small",
			"actives.kraken_bite",
			"actives.kraken_devour",
			"actives.ghost_overhead_strike",
			"actives.headbutt",
			"actives.serpent_bite"
			"spells.death",
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.AttackDefault;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.Skill = null;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasVisibleOpponent())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		score = score * this.getFatigueScoreMult(this.m.Skill);
		local myTile = _entity.getTile();
		local targets = this.queryTargetsInMeleeRange(this.m.Skill.getMinRange(), this.m.Skill.getMaxRange() + (this.m.Skill.isRanged() ? myTile.Level : 0), this.m.Skill.getMaxLevelDifference());

		if (targets.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local bestTarget;

		if (this.m.Skill.isRanged())
		{
			bestTarget = this.queryBestRangedTarget(_entity, this.m.Skill, targets);
		}
		else
		{
			bestTarget = this.queryBestMeleeTarget(_entity, this.m.Skill, targets);
		}

		if (bestTarget.Target == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getIntentions().IsChangingWeapons)
		{
			score = score * this.Const.AI.Behavior.AttackAfterSwitchWeaponMult;
		}

		this.m.TargetTile = bestTarget.Target.getTile();
		return this.Math.max(0, this.Const.AI.Behavior.Score.Attack * bestTarget.Score * score);
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			this.m.IsFirstExecuted = false;
			return false;
		}

		if (this.m.TargetTile != null && this.m.TargetTile.IsOccupiedByActor)
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Using " + this.m.Skill.getName() + " against " + this.m.TargetTile.getEntity().getName() + "!");
			}
			
			local bonusDelay = 0;
			
			if (this.m.Skill.getID() == "spells.death")
			{
				bonusDelay = 1500;
				this.Tactical.spawnSpriteEffect("necro_quote_11", this.createColor("#ffffff"), _entity.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			}
			
			local dist = _entity.getTile().getDistanceTo(this.m.TargetTile);
			this.m.Skill.use(this.m.TargetTile);

			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer))
			{
				this.getAgent().declareAction();

				if (dist > 1 && this.m.Skill.isShowingProjectile())
				{
					this.getAgent().declareEvaluationDelay(750 + bonusDelay);
				}
				else if (this.m.Skill.getDelay() != 0)
				{
					this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay() + bonusDelay);
				}
			}

			this.m.TargetTile = null;
		}

		return true;
	}

});

