this.getroottable().HexenHooks.hookAI <- function ()
{
	//Allow ai to use my new skills
	::mods_hookExactClass("ai/tactical/behaviors/ai_warcry", function ( o )
	{
		o.m.PossibleSkills.extend([
			"actives.frenzy",
			"actives.intimidate"
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function ( o )
	{
		o.m.PossibleSkills.extend([
			"actives.unhold_hand_to_hand",
			"actives.spit_acid",
			"actives.mind_break",
			"actives.death",
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_thresh", function ( o )
	{
		o.m.PossibleSkills.push("actives.uproot_aoe");
	});

	//fix strange behavior of enemy nacho with the modded skill
	::mods_hookNewObject("ai/tactical/behaviors/ai_attack_swallow_whole", function ( o )
	{
		o.m.PossibleSkills.push("actives.legend_skin_ghoul_swallow_whole");
		
		o.onEvaluate <- function( _entity )
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

			if (this.getAgent().getKnownOpponents().len() <= 1)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			if (_entity.getHitpointsPct() < 0.2 && _entity.getTile().getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) > 1)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			foreach( skillID in this.m.PossibleSkills )
			{
				local skill = _entity.getSkills().getSkillByID(skillID);

				if (skill != null && skill.isUsable() && skill.isAffordable())
				{
					this.m.Skill = skill;
					break;
				}
			}

			if (this.m.Skill == null)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			score = score * this.getFatigueScoreMult(this.m.Skill);
			local targets = this.queryTargetsInMeleeRange();

			if (targets.len() == 0)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			local bestTarget = this.getBestTarget(_entity, this.m.Skill, targets);

			if (bestTarget.Target == null)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			this.m.TargetTile = bestTarget.Target.getTile();
			score = score * bestTarget.Score;
			return this.Const.AI.Behavior.Score.SwallowWhole * score;
		};
		
		o.getBestTarget = function( _entity, _skill, _targets )
		{
			local bestTarget;
			local bestScore = 0.0;

			foreach( target in _targets )
			{
				if (!_skill.onVerifyTarget(_entity.getTile(), target.getTile()))
				{
					continue;
				}

				local score = 0.0;

				if (target.getHitpoints() <= 10)
				{
					continue;
				}
				
				local p = target.getCurrentProperties();
				
				if (!target.getFlags().has("human"))
				{
					score = score + p.getMeleeDefense() * 2;
					score = score + p.getMeleeSkill() * 0.25;
					score = score + target.getHitpoints() * 3;
					score = score * p.TargetAttractionMult;
				}
				else
				{
					score = score + p.getMeleeDefense() * 2;
					score = score + p.getMeleeSkill() * 0.25;
					score = score + target.getHitpoints() * 0.5;
					score = score + (target.getArmor(this.Const.BodyPart.Body) * (p.HitChance[this.Const.BodyPart.Body] / 100.0) + target.getArmor(this.Const.BodyPart.Head) * (p.HitChance[this.Const.BodyPart.Head] / 100.0)) * 0.1;
					score = score * p.TargetAttractionMult;
				}

				if (score > bestScore)
				{
					bestTarget = target;
					bestScore = score;
				}
			}

			return {
				Target = bestTarget,
				Score = bestScore * 0.01
			};
		}
		
	});

	delete this.HexenHooks.hookAI;
}