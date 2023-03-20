//fix strange behavior of enemy nacho with the modded skill
::mods_hookExactClass("ai/tactical/behaviors/ai_attack_swallow_whole", function ( obj )
{
	obj.m.PossibleSkills.push("actives.legend_skin_ghoul_swallow_whole");
	
	obj.onEvaluate <- function( _entity )
	{
		this.m.TargetTile = null;
		this.m.Skill = null;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasVisibleOpponent())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getKnownOpponents().len() <= 1)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getHitpointsPct() < 0.2 && _entity.getTile().getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) > 1)
		{
			return ::Const.AI.Behavior.Score.Zero;
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
			return ::Const.AI.Behavior.Score.Zero;
		}

		score = score * this.getFatigueScoreMult(this.m.Skill);
		local targets = this.queryTargetsInMeleeRange();

		if (targets.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local bestTarget = this.getBestTarget(_entity, this.m.Skill, targets);

		if (bestTarget.Target == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestTarget.Target.getTile();
		score = score * bestTarget.Score;
		return ::Const.AI.Behavior.Score.SwallowWhole * score;
	};
	
	obj.getBestTarget = function( _entity, _skill, _targets )
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
				score = score + (target.getArmor(::Const.BodyPart.Body) * (p.HitChance[::Const.BodyPart.Body] / 100.0) + target.getArmor(::Const.BodyPart.Head) * (p.HitChance[::Const.BodyPart.Head] / 100.0)) * 0.1;
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