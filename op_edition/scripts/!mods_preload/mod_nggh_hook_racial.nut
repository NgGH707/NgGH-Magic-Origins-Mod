this.getroottable().Nggh_MagicConcept.hookRacial <- function ()
{
	//
	::mods_hookExactClass("skills/racial/alp_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Partly Exist In Dreams";
			this.m.Description = "Has strong resistance against ranged and piercing attacks due to part of its real body only existing in a dream. It has the habbit to haunt and stalk its prey.";
			this.m.Icon = "skills/status_effect_102.png";
			this.m.IconMini = "status_effect_102_mini";
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Causes all Alps to teleport after taking damage"
				}
			];
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			local AI = this.getContainer().getActor().getAIAgent();
			AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_alp_teleport"));
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
		{
			local actor = this.getContainer().getActor();

			if (_damageHitpoints >= actor.getHitpoints())
			{
				return;
			}
			
			local tag = {
				Faction = this.getContainer().getActor().getFaction(),
			};
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 30, this.teleport.bindenv(this), tag);
		};
		obj.onDeath = function()
		{
			local tag = {
				Faction = this.getContainer().getActor().getFaction(),
			};
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 30, this.teleport.bindenv(this), tag);
		};
		obj.teleport = function( _tag )
		{
			local allies = this.Tactical.Entities.getInstancesOfFaction(_tag.Faction);

			foreach( a in allies )
			{
				local skill = a.getSkills().getSkillByID("actives.alp_teleport")

				if (a.isAlive() && a.getHitpoints() > 0 && skill != null)
				{
					if (a.getFlags().get("disable_auto_teleport"))
					{
						continue;
					}

					if (!a.getAIAgent().hasKnownOpponent())
					{
						local strategy = a.getAIAgent().getStrategy().update();

						do
						{
						}
						while (!resume strategy);
					}
					
					local b = a.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.AlpTeleport);
					b.onEvaluate(a);
					b.onExecute(a);
				}
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/goblin_ambusher_racial", function(obj) 
	{
		obj.m.Chance <- 100;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Poisonous Weapon";
			this.m.Description = "Goblins love using poison to weaken their prey and enemy. Instead of killing its victim this poison will slow them down and stop them from getting away easily.";
			this.m.Icon = "skills/status_effect_00.png";
			this.m.IconMini = "status_effect_54_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Chance + "%[/color] to inflicts [color=" + this.Const.UI.Color.DamageValue + "]Goblin Poison[/color] on each attack"
				}
			];
		};

		local ws_onTargetHit = obj.onTargetHit;
		obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_skill == null || !_skill.m.IsWeaponSkill)
			{
				return;
			}

			if (this.getContainer().getActor().isPlayerControlled() && this.Math.rand(1, 100) > this.m.Chance)
			{
				return;
			}

			ws_onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		};
	});


	//
	::mods_hookExactClass("skills/racial/goblin_shaman_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Shaman Trick";
			this.m.Description = "Has a high chance to act first at the start of battle";
			this.m.Icon = "skills/status_effect_34.png";
			this.m.IconMini = "status_effect_34_mini";
			this.m.Overlay = "status_effect_34";
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]+100[/color] Initiative to Turn Order for the first turn"
				}
			];
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.onUpdate = function( _properties )
		{	
			if (this.Tactical.isActive() && this.Time.getRound() <= 1)
			{
				_properties.InitiativeForTurnOrderAdditional += 100;
			}
		}
	});


	//
	::mods_hookExactClass("skills/racial/legend_greenwood_schrat_racial", function(obj) 
	{
		obj.m.DamRec <- 0.3;
		obj.m.Script <- "enemies/legend_greenwood_schrat_small";

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Living Wood";
			this.m.Description = "As guardians of the forest, a Greenwood Schrat has an incredibly resilient wooden body. Any part of its broken body part could grow into a living schrat too.";
			this.m.Icon = "skills/status_effect_86.png";
			this.m.IconMini = "status_effect_86_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
			this.m.Script = "minions/special/legend_greenwood_schrat_small_minion";
		};
		obj.getTooltip <- function()
		{
			local actor = this.getContainer().getActor();
			local isSpecialized = this.getContainer().hasSkill("perk.sapling");
			local hp = this.Math.floor(actor.getHitpointsMax() * 0.067);
			local chance = 25 + (isSpecialized ? 10 : 0);
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "Takes [color=" + this.Const.UI.Color.NegativeValue + "]" + (1 - this.m.DamRec) * 100 + "%[/color] less damage if has a shield equipped"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] to spawn a Greenwood Sapling when taking at least [color=" + this.Const.UI.Color.PositiveValue + "]" + hp + "[/color] damage"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Resistance against most ranged attacks"
				}
			];

			return ret;
		};

		local ws_isHidden = obj.isHidden;
		obj.isHidden = function()
		{
			if (!this.Tactical.isActive())
			{
				return false;
			}

			return ws_isHidden();
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();

			if (actor.isArmedWithShield())
			{
				_properties.DamageReceivedTotalMult *= this.m.DamRec;
			}
		};
		obj.onBeforeDamageReceived = function( _attacker, _skill, _hitInfo, _properties )
		{
			if (_skill == null)
			{
				return;
			}

			if (_skill.isRanged() && _skill.hasDamageType(this.Const.Damage.DamageType.Piercing))
			{
				_properties.DamageReceivedRegularMult *= 0.33;
			}
		};
		obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
		{
			local actor = this.getContainer().getActor();
			local mult = actor.isPlayerControlled() ? 6.7 : 1.0;
			local isSpecialized = this.getContainer().hasSkill("perk.sapling");

			if (_damageHitpoints >= actor.getHitpointsMax() * 0.01 * mult)
			{
				local candidates = [];
				local myTile = actor.getTile();

				for( local i = 0; i < 6; i = i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else
					{
						local nextTile = myTile.getNextTile(i);

						if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
						{
							candidates.push(nextTile);
						}
					}

					i = ++i;
				}

				local bonus = isSpecialized ? 10 : 0;

				if (candidates.len() != 0)
				{
					if (this.getContainer().getActor().isPlayerControlled() && this.Math.rand(1, 100) > 25 + bonus)
					{
						return;
					}

					local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
					local sapling = this.Tactical.spawnEntity("scripts/entity/tactical/" + this.m.Script, spawnTile.Coords);
					sapling.setFaction(actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction());
					sapling.riseFromGround();

					if (isSpecialized)
					{
						sapling.setMaster(actor);
						sapling.setFaction(actor.getFaction());
					}
				}
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/legend_greenwood_schrat_racial", function(obj) 
	{
		obj.m.DamRec <- 0.3;
		obj.m.Script <- "enemies/schrat_small";

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Living Wood";
			this.m.Description = "As guardians of the forest, a Schrat has an incredibly resilient wooden body. Any part of its broken body part could grow into a living schrat too.";
			this.m.Icon = "skills/status_effect_86.png";
			this.m.IconMini = "status_effect_86_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
			this.m.Script = "minions/special/schrat_small_minion";
		};
		obj.getTooltip <- function()
		{
			local actor = this.getContainer().getActor();
			local isSpecialized = this.getContainer().hasSkill("perk.sapling");
			local hp = this.Math.floor(actor.getHitpointsMax() * 0.1);
			local chance = 25 + (isSpecialized ? 10 : 0);
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "Takes [color=" + this.Const.UI.Color.NegativeValue + "]" + (1 - this.m.DamRec) * 100 + "%[/color] less damage if has a shield equipped"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] to spawn a Sapling when taking at least [color=" + this.Const.UI.Color.PositiveValue + "]" + hp + "[/color] damage"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Resistance against most ranged attacks"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Vulnerable against fire"
				}
			];

			return ret;
		};

		local ws_isHidden = obj.isHidden;
		obj.isHidden = function()
		{
			if (!this.Tactical.isActive())
			{
				return false;
			}

			return ws_isHidden();
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();

			if (actor.isArmedWithShield())
			{
				_properties.DamageReceivedTotalMult *= this.m.DamRec;
			}
		};
		obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
		{
			local actor = this.getContainer().getActor();
			local isSpecialized = this.getContainer().hasSkill("perk.sapling");

			if (_damageHitpoints >= actor.getHitpointsMax() * 0.1)
			{
				local candidates = [];
				local myTile = actor.getTile();

				for( local i = 0; i < 6; i = ++i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else
					{
						local nextTile = myTile.getNextTile(i);

						if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
						{
							candidates.push(nextTile);
						}
					}
				}

				local bonus = isSpecialized ? 10 : 0;

				if (candidates.len() != 0)
				{
					if (this.getContainer().getActor().isPlayerControlled() && this.Math.rand(1, 100) > 25 + bonus)
					{
						return;
					}

					local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
					local sapling = this.Tactical.spawnEntity("scripts/entity/tactical/" + this.m.Script, spawnTile.Coords);
					sapling.setFaction(actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction());
					sapling.riseFromGround();

					if (isSpecialized)
					{
						sapling.setMaster(actor);
						sapling.setFaction(actor.getFaction());
					}
				}
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/legend_redback_spider_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Redback Poison";
			this.m.Description = "An even more dangerous giant spider to play with. Its poison is the deadliest.";
			this.m.Icon = "skills/status_effect_54.png";
			this.m.IconMini = "status_effect_54_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has extremely potent poison"
				},
				{
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that have Trapped in Web, Net, Vines status effects"
				}
			];
		};
		obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints <= this.Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			{
				return;
			}

			if (!_targetEntity.isAlive() || _targetEntity.isDying())
			{
				return;
			}

			if (_targetEntity.getFlags().has("undead"))
			{
				return;
			}

			if (!_targetEntity.isHiddenToPlayer())
			{
				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
				}

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
			}

			this.spawnIcon("status_effect_54", _targetEntity.getTile());
			local properties = this.getContainer().getActor().getCurrentProperties();
			local poison = _targetEntity.getSkills().getSkillByID("effects.legend_redback_spider_poison");

			if (!_targetEntity.getSkills().hasSkill("effects.stunned") && !_targetEntity.getCurrentProperties().IsImmuneToStun)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is stunned");
			}

			if (poison == null)
			{
				local effect = this.new("scripts/skills/effects/legend_redback_spider_poison_effect");
				effect.setDamage(properties.IsSpecializedInDaggers ? effect.getDamage() * 2 : 1);
				effect.setActorID(this.getContainer().getActor().getID());
				_targetEntity.getSkills().add(effect);
			}
			else
			{
				poison.resetTime();
				poison.setActorID(this.getContainer().getActor().getID());
				
				if (properties.IsSpecializedInDaggers && this.Math.rand(1, 10) <= 5)
				{
					poison.setDamage(poison.getDamage() + 1);
				}
			}
		};
		obj.onUpdate = function( _properties )
		{
			if (!this.Tactical.isActive())
			{
				return;
			}
			
			local num = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()).len();
			_properties.Bravery += (num - 1) * 3;
		};
		obj.onAnySkillUsed = function( _skill, _targetEntity, _properties )
		{
			if (_targetEntity == null)
			{
				return;
			}
			
			local targetStatus = _targetEntity.getCurrentProperties();
			
			if (targetStatus.IsRooted && !targetStatus.IsImmuneToRoot)
			{
				_properties.DamageDirectMult *= 2.0;
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/spider_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Webknecht Poison";
			this.m.Description = "A giant spider can be dangerous to play with, especially when it has deadly venom.";
			this.m.Icon = "skills/status_effect_54.png";
			this.m.IconMini = "status_effect_54_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers;
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + (isSpecialized ? 10 : 5) + "[/color] poison damage per turn, for " + (isSpecialized ? 2 : 3) + " turns"
				},
				{
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that have Trapped in Web, Net, Vines status effects"
				}
			];
		};
		obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_damageInflictedHitpoints < this.Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			{
				return;
			}

			if (!_targetEntity.isAlive())
			{
				return;
			}

			if (_targetEntity.getFlags().has("undead"))
			{
				return;
			}
			
			if (_targetEntity.getCurrentProperties().IsImmuneToPoison)
			{
				return;
			}

			if (!_targetEntity.isHiddenToPlayer())
			{
				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
				}

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
			}

			this.spawnIcon("status_effect_54", _targetEntity.getTile());
			local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers;
			local poison = _targetEntity.getSkills().getSkillByID("effects.spider_poison");

			if (poison == null)
			{
				local effect = this.new("scripts/skills/effects/spider_poison_effect");
				effect.m.TurnsLeft = isSpecialized ? 2 : 3;
				effect.setDamage(isSpecialized ? 10 : 5);
				effect.setActorID(this.getContainer().getActor().getID());
				_targetEntity.getSkills().add(effect);
			}
			else
			{
				poison.resetTime();
				poison.setActorID(this.getContainer().getActor().getID());
				
				if (isSpecialized)
				{
					poison.m.Count += 1;
					poison.m.TurnsLeft = 2;
				}
			}
		};
		obj.onUpdate = function( _properties )
		{
			if (!this.Tactical.isActive())
			{
				return;
			}
			
			local num = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()).len();
			_properties.Bravery += (num - 1) * 3;
		};
		obj.onAnySkillUsed = function( _skill, _targetEntity, _properties )
		{
			if (_targetEntity == null)
			{
				return;
			}
			
			local targetStatus = _targetEntity.getCurrentProperties();
			
			if (targetStatus.IsRooted && !targetStatus.IsImmuneToRoot)
			{
				_properties.DamageDirectMult *= 2.0;
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/legend_bog_unhold_racial", function(obj) 
	{
		obj.m.RecoverMult <- 15;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Bog Unhold Regeneration";
			this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This unhold has the stink of the swamp.";
			this.m.Icon = "skills/status_effect_79.png";
			this.m.IconMini = "status_effect_79_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.RecoverMult = 10;
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.RecoverMult + "%[/color] of max health"
				}
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Getting [color=" + this.Const.UI.Color.PositiveValue + "]Poisoned[/color] is no longer interupting health regeneration"
				}
			];
		};
		obj.onTurnStart = function()
		{
			local actor = this.getContainer().getActor();
			local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
			local healthAdded = this.Math.min(healthMissing, this.Math.floor(actor.getHitpointsMax() * this.m.RecoverMult * 0.01));

			if (healthAdded <= 0)
			{
				return;
			}

			actor.setHitpoints(actor.getHitpoints() + healthAdded);
			actor.setDirty(true);

			if (!actor.isHiddenToPlayer())
			{
				this.spawnIcon("status_effect_79", actor.getTile());

				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
				}

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/legend_rock_unhold_racial", function(obj) 
	{
		obj.m.RecoverMult <- 10;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Rock Unhold Regeneration";
			this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours. This one has an especially resilient skin like a set of armor.";
			this.m.Icon = "skills/status_effect_79.png";
			this.m.IconMini = "status_effect_79_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.RecoverMult = 5;
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/armor_body.png",
					text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.RecoverMult + "%[/color] of max armor"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(this.m.RecoverMult * 1.5) + "%[/color] of max health"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/tooltips/negative.png",
					text = "Getting [color=" + this.Const.UI.Color.NegativeValue + "]Poisoned[/color] stops health regeneration"
				}
			];
		};
		obj.onTurnStart = function()
		{
			local actor = this.getContainer().getActor();
			local mult = this.m.RecoverMult * 0.01;
			local b = actor.getBaseProperties();
			local totalBodyArmor = b.ArmorMax[0];
			local totalHeadArmor = b.ArmorMax[1];
			local currentBodyArmor = b.Armor[0];
			local currentHeadArmor = b.Armor[1];
			local missingBodyArmor = totalBodyArmor - currentBodyArmor;
			local missingHeadArmor = totalHeadArmor - currentHeadArmor;
			local healRateBody = totalBodyArmor * mult;
			local healRateHead = totalHeadArmor * mult;
			local addedBodyArmor = this.Math.abs(this.Math.min(missingBodyArmor, healRateBody));
			local addedHeadArmor = this.Math.abs(this.Math.min(missingHeadArmor, healRateBody));
			local newBodyArmor = currentBodyArmor + addedBodyArmor;
			local newHeadArmor = currentHeadArmor + addedHeadArmor;

			if (addedBodyArmor <= 0 && addedHeadArmor <= 0)
			{
				return;
			}

			local poison = [
				"spider_poison_effect",
				"legend_redback_spider_poison_effect",
				"legend_RSW_poison_effect",
				"goblin_poison",
				"legend_zombie_poison",
				"legend_rat_poison",
			];
			local isPoisoned = false;

			foreach ( string in poison ) 
			{
			    if (actor.getSkills().hasSkill("effects." + string))
			    {
			    	isPoisoned = true;
			    	break;
			    }
			}

			if (!isPoisoned)
			{
				actor.setArmor(this.Const.BodyPart.Body, newBodyArmor);
				actor.setArmor(this.Const.BodyPart.Head, newHeadArmor);
				actor.setDirty(true);

				if (!actor.isHiddenToPlayer())
				{
					this.spawnIcon("status_effect_79", actor.getTile());

					if (this.m.SoundOnUse.len() != 0)
					{
						this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
					}

					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " regenerated " + addedBodyArmor + " points of body armor");
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " regenerated " + addedHeadArmor + " points of head armor");
				}
			}
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor().get();

			if (this.Tactical.isActive() && this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 2 && (this.isKindOf(actor, "unhold_armored") || this.isKindOf(actor, "unhold_frost_armored")))
			{
				_properties.InitiativeForTurnOrderAdditional += 40;
			}
		}
	});

	
	//
	::mods_hookExactClass("skills/racial/unhold_racial", function(obj) 
	{
		obj.m.RecoverMult <- 15;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Unhold Regeneration";
			this.m.Description = "Unholds have unbelievable regeneration that no other creature can match. It can easily regrow a missing limb within hours.";
			this.m.Icon = "skills/status_effect_79.png";
			this.m.IconMini = "status_effect_79_mini";
		};
		obj.isHidden <- function()
		{
			return this.getContainer().hasSkill("racial.legend_rock_unhold");
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.RecoverMult = 7;
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.RecoverMult + "%[/color] of max health"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/tooltips/negative.png",
					text = "Getting [color=" + this.Const.UI.Color.NegativeValue + "]Poisoned[/color] stops health regeneration"
				}
			];
		};
		obj.onTurnStart = function()
		{
			local actor = this.getContainer().getActor();
			local mult = this.m.RecoverMult * 0.01;
			local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
			local healthAdded = this.Math.min(healthMissing, this.Math.floor(actor.getHitpointsMax() * mult));

			if (healthAdded <= 0)
			{
				return;
			}
			
			local poison = [
				"spider_poison_effect",
				"legend_redback_spider_poison_effect",
				"legend_RSW_poison_effect",
				"goblin_poison",
				"legend_zombie_poison",
				"legend_rat_poison",
			];
			local isPoisoned = false;

			foreach ( string in poison ) 
			{
			    if (actor.getSkills().hasSkill("effects." + string))
			    {
			    	isPoisoned = true;
			    	break;
			    }
			}

			if (!isPoisoned)
			{
				actor.setHitpoints(actor.getHitpoints() + healthAdded);
				actor.setDirty(true);

				if (!actor.isHiddenToPlayer())
				{
					this.spawnIcon("status_effect_79", actor.getTile());

					if (this.m.SoundOnUse.len() != 0)
					{
						this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
					}

					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
				}
			}
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor().get();

			if (this.Tactical.isActive() && this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 2 && (this.isKindOf(actor, "unhold_armored") || this.isKindOf(actor, "unhold_frost_armored")))
			{
				_properties.InitiativeForTurnOrderAdditional += 40;
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/lindwurm_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Acid Blood";
			this.m.Description = "This beast has one of the most dangerous blood, it can easily dissolve any most kinds of armor.";
			this.m.Icon = "skills/status_effect_78.png";
			this.m.IconMini = "status_effect_78_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Splash acid on melee attacker"
				}
			];
		}
	});


	//
	::mods_hookExactClass("skills/racial/serpent_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Tough Scales";
			this.m.Description = "Serpents have tough scales that can deflect firearm shots, making them quite resistant to that kind of attack.";
			this.m.Icon = "skills/status_effect_113.png";
			this.m.IconMini = "status_effect_113_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]+15[/color] Initiative For Turn Order"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/sturdiness.png",
					text = "Takes [color=" + this.Const.UI.Color.NegativeValue + "]33%[/color] less damage from firearms"
				}
			];
		};
		local ws_onUpdate = obj.onUpdate;
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();

			if (actor.isPlayerControlled())
			{
				if (!this.Tactical.isActive())
				{
					return;
				}

				local myTile = actor.getTile();

				if (!actor.isPlacedOnMap() || myTile.hasZoneOfOccupationOtherThan(actor.getAlliedFactions()))
				{
					return;
				}

				_properties.InitiativeForTurnOrderAdditional += 15;
			}
			else
			{
				ws_onUpdate(_properties);
			}
		};
	});


	//
	::mods_hookExactClass("skills/racial/skeleton_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Resistant to Ranged Attacks";
			this.m.Description = "Ranged, Slashing and Piercing attacks are not very effective against this character.";
			this.m.Icon = "ui/perks/perk_32.png";
			this.m.IconMini = "perk_32_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				}
			];
		};
	});


	//
	::mods_hookExactClass("skills/racial/trickster_god_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Godly Regeneration";
			this.m.Description = "Such unimaginable scene unfolds before your eyes. Is this regeneration?";
			this.m.Icon = "skills/status_effect_79.png";
			this.m.IconMini = "status_effect_79_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]6%[/color] of max health"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has an attack can [color=" + this.Const.UI.Color.PositiveValue + "]Ignore[/color] knock back immunity"
				}
			];
		};
	});


	//
	::mods_hookExactClass("skills/racial/werewolf_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Gain additional damage scaling with loss health";
			this.m.Icon = "skills/status_effect_wolf_rider.png";
			this.m.IconMini = "status_effect_wolf_rider_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			local healthMax = this.getContainer().getActor().getHitpointsMax();
			local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
			local additionalDamage = this.Math.floor(healthMax * healthMissing * 0.25);

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				additionalDamage = this.Math.floor(additionalDamage * 1.5);
			}
			
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + additionalDamage + "[/color] Attack Damage"
				}
			];
		};
		obj.onUpdate = function( _properties )
		{
			local healthMax = this.getContainer().getActor().getHitpointsMax();
			local healthMissing = 1 - this.getContainer().getActor().getHitpointsPct();
			local additionalDamage = this.Math.floor(healthMax * healthMissing * 0.25);

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				additionalDamage = this.Math.floor(additionalDamage * 1.5);
			}

			if (additionalDamage > 0)
			{
				_properties.DamageRegularMin += additionalDamage;
				_properties.DamageRegularMax += additionalDamage;
			}
		}
	});


	//
	::mods_hookExactClass("skills/racial/champion_racial", function(obj) 
	{
		obj.m.IsPlayer <- false;
		obj.m.GainHP <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "The toughest among the strongest. Who dares to challenge those like them?";
		};
		obj.onAdded <- function()
		{
			local actor = this.getContainer().getActor();

			if (actor.hasSprite("miniboss"))
			{
				actor.getSprite("miniboss").setBrush("bust_miniboss");
				actor.setDirty(true);
			}

			if (actor.isPlayerControlled())
			{
				this.m.IsPlayer = true;
				this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
				this.m.Order = this.Const.SkillOrder.First + 1;
				this.m.IsActive = false;
				this.m.IsStacking = false;
				this.m.IsHidden = false;
				this.getContainer().getActor().m.IsMiniboss = true;
				
				if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() < 1.0)
				{
					this.getContainer().getActor().setSize(0.95);
				}
			}
			else 
			{
				this.getContainer().add(this.new("scripts/skills/special/champion_loot"));    
			}
		};
		obj.onRemoved <- function()
		{
			local actor = this.getContainer().getActor();
			actor.getSprite("miniboss").Visible = false;
			actor.setDirty(true);
		};
		obj.getTooltip <- function()
		{
			local mult = 1.0;
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1.35 : 1) * 35 * mult) + "%[/color] Hitpoints"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Attack Damage"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Initiative"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Melee Skill"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Ranged Skill"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor((this.m.GainHP ? 1 : 1.25) * 25 * mult) + "%[/color] Melee Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(15 * mult) + "%[/color] Ranged Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(50 * mult) + "%[/color] Resolve"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.Math.floor(50 * mult) + "%[/color] Max Fatigue"
				}
			];
		};
		obj.onUpdate = function( _properties )
		{
			local mult = 1.0;
			_properties.DamageTotalMult *= 1 + (0.15 * mult);
			_properties.BraveryMult *= 1 + (0.5 * mult);
			_properties.StaminaMult *= 1 + (0.5 * mult);
			_properties.MeleeSkillMult *= 1 + (0.15 * mult);
			_properties.RangedSkillMult *= 1 + (0.15 * mult);
			_properties.InitiativeMult *= 1 + (0.15 * mult);
		
			_properties.MeleeDefenseMult *= 1 + (0.25 * mult);
			_properties.RangedDefenseMult *= 1 + (0.25 * mult);
			_properties.HitpointsMult *= 1 + (0.35 * mult);

			this.m.GainHP = this.getContainer().getActor().getBaseProperties().MeleeDefense >= 20 || this.getContainer().getActor().getBaseProperties().RangedDefense >= 20 || this.getContainer().getActor().getBaseProperties().MeleeDefense >= 15 && this.getContainer().getActor().getBaseProperties().RangedDefense >= 15;

			if (this.m.GainHP)
			{
				_properties.HitpointsMult *= 1 + (0.35 * mult);
			}
			else
			{
				_properties.MeleeDefenseMult *= 1 + (0.25 * mult);
				_properties.RangedDefenseMult *= 1 + (0.25 * mult);
			}
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == null)
			{
				return;
			}
			
			if (_skill.getID() == "actives.spider_bite" || _skill.getID() == "actives.legend_redback_spider_bite")
			{
				_properties.DamageTotalMult *= 1.15;
			}
		};
	});


	// Add the general properties a ghost should have
	::mods_hookExactClass("skills/racial/ghost_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "This character doesn\'t have an actual body or a definite form. Making it extremely hard to land on a hit.";
			this.m.Icon = "skills/racial_ghost.png";
			this.m.IconMini = "racial_ghost_mini"
		};
	    obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
	    obj.onUpdate <- function( _properties )
	    {
	    	_properties.IsImmuneToBleeding = true;
			_properties.IsImmuneToPoison = true;
			_properties.IsImmuneToKnockBackAndGrab = true;
			_properties.IsImmuneToStun = true;
			_properties.IsImmuneToRoot = true;
			_properties.IsImmuneToDisarm = true;
			_properties.IsAffectedByRain = false;
			_properties.IsAffectedByNight = false;
			_properties.IsAffectedByInjuries = false;
			_properties.IsMovable = false;
			_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
	    }
	});


	//
	::mods_hookExactClass("skills/racial/mummy_racial", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Resistant to Ranged Attacks";
			this.m.Description = "Ranged, Slashing and Piercing attacks are not very effective against this character.";
			this.m.Icon = "ui/perks/perk_32.png";
			this.m.IconMini = "perk_32_mini";
		};
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return;
			}
			
			this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
			this.m.Order = this.Const.SkillOrder.First + 1;
			this.m.IsActive = false;
			this.m.IsStacking = false;
			this.m.IsHidden = false;
		};
		obj.getTooltip <- function()
		{
			return [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 3
					type = "text",
					icon = "ui/icons/special.png",
					text = "Curse the attack on death"
				}
			];
		};
	});

	delete this.Nggh_MagicConcept.hookRacial;
}