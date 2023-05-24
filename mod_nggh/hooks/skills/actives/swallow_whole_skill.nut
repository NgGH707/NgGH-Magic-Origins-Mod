::mods_hookExactClass("skills/actives/swallow_whole_skill", function ( obj )
{
	obj.m.IsArena <- false;
	obj.m.Cooldown <- 0;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Chuckle your foe into your belly. Yum! tasty right?";
		this.m.Icon = "skills/active_103.png";
		this.m.IconDisabled = "skills/active_103_sw.png";
		this.m.IsUsingHitchance = false;
	};
	obj.setCooldown <- function()
	{
		this.m.SwallowedEntity = null;
		this.m.Cooldown = 3;
	};
	obj.isFull <- function()
	{
		return this.m.SwallowedEntity != null;
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can be used to [color=" + ::Const.UI.Color.PositiveValue + "]Swallow[/color] an unlucky target"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not swallow something bigger than you[/color]"
			}
		];

		if (this.m.Cooldown != 0)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
				}
			]);
		}

		return ret;
	};
	obj.isUsable = function()
	{
		return this.skill.isUsable() && !this.isFull() && this.m.Cooldown == 0;
	};
	obj.isHidden <- function()
	{
		return this.getContainer().getActor().getSize() != 3 || this.skill.isHidden();
	};
	obj.onTurnStart <- function()
	{
		if (this.m.SwallowedEntity != null)
		{
			local hp = ::Math.maxf(0.05, this.m.SwallowedEntity.getHitpointsPct() - 0.05);
			this.m.SwallowedEntity.setHitpointsPct(hp);
			local b = this.m.SwallowedEntity.getBaseProperties();

			foreach ( BodyPart in [
				::Const.BodyPart.Body,
				::Const.BodyPart.Head
			]) 
			{
				local armorDamage = ::Math.rand(5, 7);
				local overflowDamage = armorDamage;

				if (b.Armor[BodyPart] != 0)
				{
					overflowDamage = overflowDamage - b.Armor[BodyPart] * b.ArmorMult[BodyPart];
					b.Armor[BodyPart] = ::Math.max(0, b.Armor[BodyPart] * b.ArmorMult[BodyPart] - armorDamage);
				}

				if (overflowDamage > 0)
				{
					this.m.SwallowedEntity.getItems().onDamageReceived(overflowDamage, ::Const.FatalityType.None, BodyPart, null);
				}
			}
		}

		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	};
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		
		if (target.getSkills().hasSkill("racial.champion") || target.getFlags().has("IsPlayerCharacter"))
		{
			return false;
		}

		if (::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player).len() == 1 && !this.getContainer().getActor().isPlayerControlled())
		{
			return false;
		}
		
		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}
		
		if (!this.checkCanBeSwallow(target))
		{
			return false;
		}

		return true;
	};
	obj.onUse = function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (typeof target == "instance")
		{
			target = target.get();
		}

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " devours " + ::Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		skills.removeByID("effects.legend_vala_chant_disharmony_effect");
		skills.removeByID("effects.legend_vala_chant_fury_effect");
		skills.removeByID("effects.legend_vala_chant_senses_effect");
		skills.removeByID("effects.legend_vala_currently_chanting");
		skills.removeByID("effects.legend_vala_in_trance");

		if (target.getMoraleState() != ::Const.MoraleState.Ignore)
		{
			target.setMoraleState(::Const.MoraleState.Breaking);
		}
		
		::Tactical.getTemporaryRoster().add(target);
		::Tactical.TurnSequenceBar.removeEntity(target);
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);

		if (!::Tactical.State.isAutoRetreat() && !target.isPlayerControlled())
		{
			::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyDestroyed);
		}

		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoul_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoul_04_head_0" + _user.m.Head);
		_user.m.Sound[::Const.Sound.ActorEvent.Death] = _user.m.Sound[::Const.Sound.ActorEvent.Other2];
		local effect = ::new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		effect.setLink(this);
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _user.getPos());
		}

		local skill = this.getContainer().getSkillByID("actives.nacho_vomit");

		if (skill != null)
		{
			skill.setCooldown();
		}

		return true;
	};
	obj.onSwallow <- function( _user )
	{
		_user.getFlags().set("has_eaten", true);
		_user.addXP(this.m.SwallowedEntity.getXPValue());
		_user.setHitpoints(::Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));
		_user.getSprite("head").setBrush("bust_ghoul_03_head_0" + _user.m.Head);
		_user.getSprite("injury").setBrush("bust_ghoul_03_injured");
		_user.getSprite("body").setBrush("bust_ghoul_body_03");
	};
	obj.onCombatStarted <- function()
	{
		this.m.IsArena = ::Tactical.State.m.StrategicProperties != null && ::Tactical.State.m.StrategicProperties.IsArenaMode;
	};
	obj.onCombatFinished <- function()
	{
		local actor = this.getContainer().getActor();
		
		if (this.m.SwallowedEntity != null && this.getContainer().getActor().isPlayerControlled())
		{
			//this.m.SwallowedEntity.getItems().dropAll(actor.getTile(), actor, false);
			if (!this.m.IsArena && this.m.SwallowedEntity.m.WorldTroop != null && ("Party" in this.m.SwallowedEntity.m.WorldTroop) && this.m.SwallowedEntity.m.WorldTroop.Party != null)
			{
				this.m.SwallowedEntity.m.WorldTroop.Party.removeTroop(this.m.SwallowedEntity.m.WorldTroop);
			}

			this.onSwallow(actor);
		}
		
		this.m.SwallowedEntity = null;
		this.m.IsArena = false;
		this.m.Cooldown = 0;
	};
	obj.checkCanBeSwallow <- function( _entity )
	{
		if (_entity.getFlags().has("ghoul") || _entity.getFlags().has("sand_golem"))
		{
			return _entity.getSize() < 3;
		}

		local type = _entity.getType();

		if (type == ::Const.EntityType.Player)
		{
			if (_entity.getFlags().has("Type"))
			{
				type = _entity.getFlags().get("Type");
			}
			else
			{
				return true;
			}
		}
		
		if (::Const.SwallowWholeInvalidTargets.find(type) != null)
		{
			return false;
		}
		
		return true;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
});