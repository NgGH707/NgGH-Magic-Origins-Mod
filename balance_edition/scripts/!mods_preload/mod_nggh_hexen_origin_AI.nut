this.getroottable().HexenHooks.hookAI <- function ()
{
	local gt = this.getroottable();
	gt.Const.AI.Behavior.ID.GhostPossess <- this.Const.AI.Behavior.ID.COUNT;
	gt.Const.AI.Behavior.ID.COUNT = this.Const.AI.Behavior.ID.COUNT + 1;
	gt.Const.AI.Behavior.Name.push("GhostPossess");
	gt.Const.AI.Behavior.Order.GhostPossess <- 39;
	gt.Const.AI.Behavior.Score.GhostPossess <- 200;
	gt.Const.AI.Behavior.GhostPossessNoTurnTarget <- 1.1;
	gt.Const.AI.Behavior.GhostPossessRangedTarget <- 0.33;
	gt.Const.AI.Behavior.GhostPossessSpearwallMult <- 2.0;
	gt.Const.AI.Behavior.GhostPossessShieldwallMult <- 1.5;
	gt.Const.AI.Behavior.GhostPossessRiposteMult <- 1.5;
	gt.Const.AI.Behavior.GhostPossessMeleeBonus <- 1.25;
	gt.Const.AI.Behavior.GhostPossessZoCMult <- 1.2;
	gt.Const.AI.Behavior.GhostPossessInMeleeWithMe <- 2.0;
	gt.Const.AI.Behavior.GhostPossessCanReachMe <- 1.5;


	// new skill for ghosts
	local ghosts = [
		"ghost_agent",
		"mirror_image_agent",
	];
	foreach ( g in ghosts )
	{
		::mods_hookExactClass("ai/tactical/agents/" + g, function ( o )
		{
			local ws_onAddBehaviors = o.onAddBehaviors;
			o.onAddBehaviors = function()
			{
				ws_onAddBehaviors();
				this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_ghost_possess"));
				this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
			}
		});
	}

	// allow ai to use my new skills
	::mods_hookExactClass("ai/tactical/behaviors/ai_warcry", function ( o )
	{
		o.m.PossibleSkills.extend([
			"actives.frenzy",
			"actives.intimidate"
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_darkflight", function ( o )
	{
		o.m.PossibleSkills.extend([
			"actives.alp_teleport",
			"actives.legend_darkflight"
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
	::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function(o) 
	{
		o.m.PossibleSkills.extend([
			"actives.legend_magic_missile",
			"actives.legend_chain_lightning",
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_bow", function(o) 
	{
		o.m.PossibleSkills.extend([
			"actives.legend_magic_missile",
			"actives.legend_chain_lightning",
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_throw_net", function(o) 
	{
		o.m.PossibleSkills.extend([
			"actives.mage_legend_magic_web_bolt",
		]);
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_miasma", function(o) 
	{
		o.m.PossibleSkills.push("actives.legend_miasma");
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_wither", function(o) 
	{
		o.m.PossibleSkills.push("actives.legend_wither");
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_raise_undead", function(o) 
	{
		o.m.PossibleSkills.push("actives.legend_raise_undead");
	});
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_thresh", function ( o )
	{
		o.m.PossibleSkills.push("actives.uproot_aoe");
	});


	// fix lightning storm can only be used by lich
	::mods_hookExactClass("ai/tactical/behaviors/ai_lightning_storm", function ( o )
	{
		o.selectBestTarget = function( _entity, _targets )
		{
			local size = this.Tactical.getMapSize();
			local scores = [];
			scores.resize(size.X);

			for( local i = 0; i < scores.len(); i = ++i )
			{
				scores[i] = {
					Score = 0.0,
					X = i
				};
			}

			local entities = this.Tactical.Entities.getInstancesOfFaction(_entity.getFaction());

			foreach( e in entities )
			{
				local skill = e.getSkills().getSkillByID("actives.lightning_storm");

				if (skill != null && skill.getTiles().len() != 0)
				{
					scores[skill.getTiles()[0].SquareCoords.X].Score = -999999.0;
				}
			}

			foreach( target in _targets )
			{
				if (target.Actor.getType() == this.Const.EntityType.Wardog || target.Actor.getType() == this.Const.EntityType.ArmoredWardog || target.Actor.getType() == this.Const.EntityType.Warhound)
				{
					continue;
				}

				local x = target.Actor.getTile().SquareCoords.X;
				local score = this.queryTargetValue(_entity, target.Actor, this.m.Skill);

				if (target.Actor.getCurrentProperties().IsStunned || target.Actor.getCurrentProperties().IsRooted)
				{
					score = score * this.Const.AI.Behavior.LightningStormStunnedTargetMult;
				}

				if (target.Actor.getTile().hasZoneOfControlOtherThan(target.Actor.getAlliedFactions()))
				{
					score = score * this.Const.AI.Behavior.LightningStormTargetInZOCMult;
				}

				scores[x].Score += score;
			}

			scores.sort(function ( _a, _b )
			{
				if (_a.Score > _b.Score)
				{
					return -1;
				}
				else if (_a.Score < _b.Score)
				{
					return 1;
				}

				return 0;
			});

			if (scores[0].Score > 0)
			{
				return this.Tactical.getTileSquare(scores[0].X, 15);
			}
			else
			{
				return null;
			}
		};
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