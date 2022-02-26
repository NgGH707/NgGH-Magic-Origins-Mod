this.getroottable().Nggh_MagicConcept.hookEffects <- function ()
{
	//
	::mods_hookExactClass("skills/effects/berserker_rage_effect", function(obj) 
	{
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.RageStacks = 1;
			}
		};
		obj.isHidden <- function()
		{
			return this.m.RageStacks == 0;
		}
		obj.getTooltip <- function()
		{
			local i = this.Math.maxf(30, (1.0 - 0.01 * this.m.RageStacks) * 100);
			
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
					id = 7,
					type = "text",
					icon = "ui/icons/mood_01.png",
					text = "Currently have [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RageStacks + "[/color] stack(s) of rage"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/damage_dealt.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] bonus damage"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Resolve"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Initiative"
				},
				{
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Only take [color=" + this.Const.UI.Color.PositiveValue + "]" + i + "%[/color] damage from all sources"
				}
			];
			
			return ret;
		};
		obj.onUpdate = function( _properties )
		{
			_properties.DamageReceivedTotalMult *= this.Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
			_properties.Bravery += this.m.RageStacks;
			_properties.DamageRegularMin += this.m.RageStacks;
			_properties.DamageRegularMax += this.m.RageStacks;
			_properties.Initiative += this.m.RageStacks;
		}
		obj.onCombatStarted <- function()
		{
			this.m.RageStacks = 0;
			this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
		};
		obj.onCombatFinished <- function()
		{
			this.m.RageStacks = 1;
			this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
		};
	});


	//
	::mods_hookExactClass("skills/effects/charmed_effect", function(obj) 
	{
		obj.m.IsBodyguard <- false;
		obj.m.IsTheLastEnemy <- false;
		obj.m.IsSuicide <- false;

		obj.isTheLastEnemy <- function( _v )
		{
			this.m.IsTheLastEnemy = _v;
		};
		obj.getName <- function()
		{
			if (this.m.TurnsLeft == 0)
			{
				return this.m.Name;
			}
			
			return this.m.Name + " (" + this.m.TurnsLeft + " turns left)";
		};

		local ws_onAdded = obj.onAdded;
		obj.onAdded = function()
		{
			local actor = this.getContainer().getActor();
			local brush = "bust_base_beasts";

			if (actor.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.Protect) != null)
			{
				this.m.IsBodyguard = true;
				actor.getAIAgent().removeBehavior(this.Const.AI.Behavior.ID.Protect);
			}

			ws_onAdded();

			if (this.m.Master != null && this.m.Master.getContainer() != null && this.m.Master.getContainer().getActor() != null)
			{
				brush = this.m.Master.getContainer().getActor().getSprite("socket").getBrush().Name;
			}

			if (!this.m.IsTheLastEnemy)
			{
				actor.getSprite("socket").setBrush(brush);
				actor.getFlags().set("Charmed", true);
				
				if (!actor.getFlags().has("human"))
				{
					this.onFactionChanged();
				}
				
				actor.setDirty(true);
			}
			else
			{
				actor.killSilently();
			}
		};
		obj.onFactionChanged <- function()
		{
			local actor = this.getContainer().getActor();

			if (this.isKindOf(actor.get(), "player"))
			{
				return;
			}

			local flip = actor.isAlliedWithPlayer();
			local sprites = ["surcoat", "body", "tattoo_body", "body_rage", "injury_body", "head", "tattoo_head", "beard", "hair", "beard_top", "injury", "body_blood", "head_frenzy", "accessory_special", "legs_back", "legs_front"];
			
			foreach (i, s in sprites)
			{
			    if (actor.hasSprite(s))
			    {
			    	actor.getSprite(s).setHorizontalFlipping(flip);
			    }
			}
		};

		local ws_onRemoved = obj.onRemoved;
		obj.onRemoved = function()
		{
			if (this.m.IsSuicide)
			{
				return;
			}

			local actor = this.getContainer().getActor();
			ws_onRemoved();

			if (this.m.IsBodyguard)
			{
				actor.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_protect"));
			}

			if (!actor.getFlags().has("human"))
			{
				this.onFactionChanged();
				actor.setDirty(true);
			}
		};
		obj.onSuicide <- function()
		{
			this.m.IsSuicide = true;
			actor.kill(null, null, this.Const.FatalityType.Suicide);
		};
	});


	//
	::mods_hookExactClass("skills/effects/fake_charmed_effect", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsRemovedAfterBattle = false;
		}
		obj.getName <- function()
		{
			return "Simp";
		}
		obj.getDescription <- function()
		{
			return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his master, your everyday simp no more no less.";
		}
		obj.getTooltip <- function()
		{
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
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Resolve"
				},
			];

			return ret;
		}

		local ws_onUpdate = obj.onUpdate;
		obj.onUpdate = function( _properties )
		{
			_properties.DailyWageMult = 0.0;

			if (this.getContainer().getActor().isPlayerControlled())
			{
				_properties.BraveryMult *= 1.05;
			}
			else
			{
				ws_onUpdate(_properties);
			}
		};
	});


	//
	::mods_hookExactClass("skills/effects/gruesome_feast_effect", function(obj) 
	{
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
			this.m.IsSerialized = true;
		};
		obj.getDescription <- function()
		{
			return "This character ate a fine meal and it helps this character grows up so fast and so too its hunger.";
		};
		obj.getTooltip <- function()
		{
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
				}
			];
			
			if (this.getContainer().getActor().getSize() == 2)
			{
				ret.extend(this.getMidSizeTooltips());
			}
			
			if (this.getContainer().getActor().getSize() == 3)
			{
				ret.extend(this.getHugeSizeTooltips());
			}

			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Need to [color=" + this.Const.UI.Color.PositiveValue + "]Eat[/color] regularly in battle"
			});
			
			return ret;
		};
		obj.getMidSizeTooltips <- function()
		{
			return [
				{
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+120[/color] Hitpoints"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Resolve"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Attack Damage"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Skill"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Initiative"
				},
			];
		};
		obj.getHugeSizeTooltips <- function()
		{
			return [
				{
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+300[/color] Hitpoints"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+60[/color] Resolve"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] Attack Damage"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Melee Skill"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Ranged Defense"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] Initiative"
				},
			];
		};
		obj.onUpdate = function( _properties )
		{
			local size = this.getContainer().getActor().getSize();
			local isPlayer = this.getContainer().getActor().isPlayerControlled();
			local mainhand = this.getContainer().getActor().getMainhandItem();
			this.m.IsHidden = size <= 1;

			if (size == 2)
			{
				_properties.Hitpoints += 120;
				_properties.MeleeSkill += 10;
				_properties.MeleeDefense += 5;
				_properties.RangedDefense -= 5;
				_properties.Bravery += 30;
				_properties.Initiative -= 15;
				_properties.DailyFood += 1;

				if (mainhand == null || mainhand.isItemType(this.Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(this.Const.Items.ItemType.RangedWeapon))
				{
					_properties.DamageRegularMin += 15;
					_properties.DamageRegularMax += 20;
				}
				else
				{
					_properties.DamageRegularMin += 5;
					_properties.DamageRegularMax += 8;
				}
			}
			else if (size == 3)
			{
				_properties.Hitpoints += 300;
				_properties.MeleeSkill += 20;
				_properties.MeleeDefense += 10;
				_properties.RangedDefense -= 10;
				_properties.Bravery += 60;
				_properties.Initiative -= 30;
				_properties.DailyFood += 4;

				if (mainhand == null || mainhand.isItemType(this.Const.Items.ItemType.TwoHanded) && !mainhand.isItemType(this.Const.Items.ItemType.RangedWeapon))
				{
					_properties.DamageRegularMin += 30;
					_properties.DamageRegularMax += 40;
				}
				else
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 15;
				}
				
				if (!isPlayer)
				{
					this.getContainer().getActor().getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				}
			}
		}
	});


	//
	::mods_hookExactClass("skills/effects/legend_hidden_effect", function(obj) 
	{
		obj.onAdded = function()
		{
			local actor = this.getContainer().getActor();
			if (actor.getTile().IsVisibleForPlayer)
			{
				if (this.Const.Tactical.HideParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.HideParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.HideParticles[i].Brushes, actor.getTile(), this.Const.Tactical.HideParticles[i].Delay, this.Const.Tactical.HideParticles[i].Quantity, this.Const.Tactical.HideParticles[i].LifeTimeQuantity, this.Const.Tactical.HideParticles[i].SpawnRate, this.Const.Tactical.HideParticles[i].Stages);
					}
				}
			}

			actor.setBrushAlpha(10);

			if (actor.getFlags().has("human"))
			{
				actor.getSprite("hair").Visible = false;
				actor.getSprite("beard").Visible = false;
			}

			actor.setHidden(true);
			actor.setDirty(true);
		}
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();
			if (actor.getSkills().hasSkill("perk.legend_assassinate"))
			{
				_properties.DamageRegularMin *= 1.5;
				_properties.DamageRegularMax *= 1.5;

				if (actor.getSkills().hasSkill("background.legend_assassin") || actor.getSkills().hasSkill("background.assassin") || actor.getSkills().hasSkill("background.assassin_southern"))
				{
				_properties.DamageRegularMax *= 1.5;
				}
				if (actor.getSkills().hasSkill("bbackground.legend_commander_assassin"))
				{
				_properties.DamageRegularMax *= 2.0;
				}
			}

			_properties.TargetAttractionMult *= 0.5;
			actor.setBrushAlpha(10);
			
			if (actor.getFlags().has("human"))
			{
				actor.getSprite("hair").Visible = false;
				actor.getSprite("beard").Visible = false;
			}

			actor.setHidden(true);
			actor.setDirty(true);
		}
	});


	//
	::mods_hookExactClass("skills/effects/sleeping_effect", function(obj)
	{
		obj.m.PreventWakeUp <- false;
		obj.m.AppliedMoraleCheck <- false;

		obj.onRemoved = function()
		{
			local actor = this.getContainer().getActor();

			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}

			actor.getFlags().set("Sleeping", false);
			
			if (actor.getFlags().has("human"))
			{
				if (actor.hasSprite("closed_eyes"))
				{
					actor.getSprite("closed_eyes").Visible = false;
				}
				
				if ("setEyesClosed" in actor.get())
				{
					actor.setEyesClosed(false);
				}
			}

			actor.setDirty(true);
			
			if (this.m.AppliedMoraleCheck && actor.isAlive() && !actor.isDying())
			{
				actor.checkMorale(-1, -10, this.Const.MoraleCheckType.MentalAttack);
				actor.checkMorale(-1, -5, this.Const.MoraleCheckType.MentalAttack);
			}
		};
		obj.onUpdate = function( _properties )
		{
			local actor = this.getContainer().getActor();
			_properties.IsStunned = true;
			_properties.Initiative -= 100;

			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").setBrush(actor.isAlliedWithPlayer() ? "bust_sleep" : "bust_sleep_mirrored");
				actor.getSprite("status_stunned").Visible = true;
				
				if (actor.getFlags().has("human"))
				{
					if (actor.hasSprite("closed_eyes"))
					{
						actor.getSprite("closed_eyes").Visible = true;
					}
					
					if ("setEyesClosed" in actor.get())
					{
						actor.setEyesClosed(true);
					}
				}

				actor.setDirty(true);
			}
		};
		obj.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
		{
			if (_attacker != null && _skill != null && _skill.getID() == "actives.nightmare")
			{
				local specialized = _attacker.getSkills().hasSkill("perk.after_wake");
				this.m.PreventWakeUp = specialized && this.Math.rand(1, 100) <= 40;
				this.m.AppliedMoraleCheck = specialized && !this.m.PreventWakeUp;
			}
		};
		obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
		{
			if (_damageHitpoints > 0 && !this.m.PreventWakeUp)
			{
				this.removeSelf();
			}

			this.m.PreventWakeUp = false;
		}
	});


	//
	::mods_hookExactClass("skills/effects/swallowed_whole_effect", function(obj) 
	{
		obj.m.Link <- null;
		obj.m.IsSpecialized <- false;

		obj.getLink <- function()
		{
			return this.m.Link;
		};
		obj.setLink <- function( _l )
		{
			if (_l == null)
			{
				this.m.Link = null;
			}
			else if (typeof _l == "instance")
			{
				this.m.Link = _l;
			}
			else 
			{
			 	this.m.Link = this.WeakTableRef(_l);
			}
		};
		obj.getDescription <- function()
		{
			return "This character has devoured [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Name + "[/color], holding said victim like a hostage in its belly.";
		};
		obj.getTooltip <- function()
		{
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
				}
			];

			if (this.m.IsSpecialized)
			{
				ret.extend([
					{
						id = 4,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Resolve"
					},
					{
						id = 4,
						type = "text",
						icon = "ui/icons/sturdiness.png",
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]-15%[/color] Damage Taken"
					}
				]);
			}

			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sapping hitpoints and armor from devoured victim every round"
			});

			local e = this.m.Link.getSwallowedEntity();

			ret.extend([
				{
					id = 3,
					type = "text",
					text = "[u][size=14]" + this.m.Name + "[/size][/u]"
				},
				{
					id = 4,
					type = "progressbar",
					icon = "ui/icons/armor_head.png",
					value = e.getArmor(this.Const.BodyPart.Head),
					valueMax = e.getArmorMax(this.Const.BodyPart.Head),
					text = "" + e.getArmor(this.Const.BodyPart.Head) + " / " + e.getArmorMax(this.Const.BodyPart.Head) + "",
					style = "armor-head-slim"
				},
				{
					id = 5,
					type = "progressbar",
					icon = "ui/icons/armor_body.png",
					value = e.getArmor(this.Const.BodyPart.Body),
					valueMax = e.getArmorMax(this.Const.BodyPart.Body),
					text = "" + e.getArmor(this.Const.BodyPart.Body) + " / " + e.getArmorMax(this.Const.BodyPart.Body) + "",
					style = "armor-body-slim"
				},
				{
					id = 6,
					type = "progressbar",
					icon = "ui/icons/health.png",
					value = e.getHitpoints(),
					valueMax = e.getHitpointsMax(),
					text = "" + e.getHitpoints() + " / " + e.getHitpointsMax() + "",
					style = "hitpoints-slim"
				}
			]);

			return ret;
		}
		obj.onAdded <- function()
		{
			this.m.IsSpecialized = this.getContainer().hasSkill("perk.nacho_big_tummy")
		};
		obj.onUpdate <- function( _properties )
		{
			if (this.m.IsSpecialized) _properties.BraveryMult *= 1.25;
		};

		obj.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
		{
			if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || !this.m.IsSpecialized || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			{
				return;
			}

			_properties.DamageReceivedRegularMult *= 0.85;
		}
	});


	// make hex count as kill
	::mods_hookExactClass("skills/effects/hex_master_effect", function(obj) 
	{
		obj.onDamageReceived = function(_attacker,_damageHitpoints,_damageArmor)
		{
			if (this.m.Slave == null || this.m.Slave.isNull() || !this.m.Slave.isAlive())
			{
				this.removeSelf();
				return;
			}

			if (_damageHitpoints > 0)
			{
				this.m.Slave.applyDamage(_damageHitpoints, this.getContainer().getActor());
			}

			if (this.m.Slave == null || this.m.Slave.isNull() || !this.m.Slave.isAlive())
			{
				this.removeSelf();
			}
		}
	});


	//
	::mods_hookExactClass("skills/effects/hex_slave_effect", function(obj) 
	{
		obj.applyDamage = function(_damage , _caster)
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
			}

			if (_caster == null || _caster.isNull())
			{
				_caster = this.getContainer().getActor();
			}

			if (typeof _caster == "instance")
			{
				_caster = _caster.get();
			}

			if (("getMaster" in _caster) && _caster.getMaster() != null && !_caster.getMaster().isNull() && _caster.getMaster().isAlive() && !_caster.getMaster().isDying())
			{
				_caster = _caster.getMaster();
			}

			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = _damage;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(_caster, this, hitInfo);
		}
	});


	// Allow poison count as kill
	::mods_hookExactClass("skills/effects/spider_poison_effect", function(obj) 
	{
		obj.m.ActorID <- null;
		obj.m.Count <- 1;
		obj.getName <- function()
		{
			if (this.m.Count <= 1)
			{
				return this.m.Name;
			}
			else
			{
				return this.m.Name + " (x" + this.m.Count + ")";
			}
		}
		obj.setActorID <- function( _id )
		{
	   		this.m.ActorID = _id;
	   	};
	   	obj.applyDamage = function()
		{
			if (this.m.LastRoundApplied != this.Time.getRound())
			{
				this.m.LastRoundApplied = this.Time.getRound();
				this.spawnIcon("status_effect_54", this.getContainer().getActor().getTile());

				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
				}

				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = this.m.Damage + 5 * (this.m.Count - 1);

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					hitInfo.DamageRegular = 1.5 * this.m.Damage;
				}

				local attacker = this.getContainer().getActor();
				hitInfo.DamageDirect = 1.0;
				hitInfo.BodyPart = this.Const.BodyPart.Body;
				hitInfo.BodyDamageMult = 1.0;
				hitInfo.FatalityChanceMult = 0.0;

				if (this.m.ActorID != null)
				{
					local e = this.Tactical.getEntityByID(this.m.ActorID);

					if (e != null && e.isPlacedOnMap() && e.isAlive() && !e.isDying())
					{
						attacker = e;
					}
				}

				this.getContainer().getActor().onDamageReceived(attacker, this, hitInfo);
			}
		};
	});


	//
	::mods_hookExactClass("skills/effects/legend_redback_spider_poison_effect", function(obj) 
	{
		obj.m.ActorID <- null;
		obj.setActorID <- function( _id )
		{
	   		this.m.ActorID = _id;
	   	};
	   	obj.applyDamage = function()
		{
			if (this.m.LastRoundApplied != this.Time.getRound())
			{
				this.m.LastRoundApplied = this.Time.getRound();
				this.spawnIcon("status_effect_54", this.getContainer().getActor().getTile());

				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
				}

				local timeDamage = this.m.Damage * this.m.TurnsLeft;
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = timeDamage;

				if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
				{
					local timeDamage = this.m.Damage * this.m.TurnsLeft;
					hitInfo.DamageRegular = 2 * timeDamage;
				}

				local attacker = this.getContainer().getActor();
				hitInfo.DamageDirect = 1.0;
				hitInfo.BodyPart = this.Const.BodyPart.Body;
				hitInfo.BodyDamageMult = 1.0;
				hitInfo.FatalityChanceMult = 0.0;

				if (this.m.ActorID != null)
				{
					local e = this.Tactical.getEntityByID(this.m.ActorID);

					if (e != null && e.isPlacedOnMap() && e.isAlive() && !e.isDying())
					{
						attacker = e;
					}
				}

				this.getContainer().getActor().onDamageReceived(attacker, this, hitInfo);
			}
		};
	});

	delete this.Nggh_MagicConcept.hookEffects;
}