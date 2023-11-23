::mods_hookExactClass("skills/actives/legend_skin_ghoul_swallow_whole_skill", function ( obj )
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
			local hp = ::Math.maxf(0.05, this.m.SwallowedEntity.getHitpointsPct() - 0.075);
			this.m.SwallowedEntity.setHitpointsPct(hp);
			local b = this.m.SwallowedEntity.getBaseProperties();

			foreach ( BodyPart in [
				::Const.BodyPart.Body,
				::Const.BodyPart.Head
			]) 
			{
				local armorDamage = ::Math.rand(5, 12);
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
	local onVerifyTarget = obj.onVerifyTarget;
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!this.getContainer().getActor().isPlayerControlled())
			return onVerifyTarget(_originTile, _targetTile) && this.checkCanBeSwallow(_targetTile.getEntity());

		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();
		
		if (target.getSkills().hasSkill("racial.champion") || target.getFlags().has("IsPlayerCharacter"))
			return false;
		
		return this.checkCanBeSwallow(target) && !target.getCurrentProperties().IsImmuneToKnockBackAndGrab;
	};
	obj.onBeforeUse <- function( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_swallow_quote_" + ::Math.rand(1, 4), _user.getTile());
	};
	local onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (typeof target == "instance")
			target = target.get();

		if (target.getType() != ::Const.EntityType.Serpent)
			::Tactical.getTemporaryRoster().add(target);
			
		target.setHitpoints(::Math.max(5, target.getHitpoints() - ::Math.rand(10, 20)));
		target.m.IsActingImmediately = false;

		if (!::Tactical.State.isAutoRetreat() && !target.isPlayerControlled())
			::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyDestroyed);

		local ret = onUse(_user, _targetTile);
		local effect = this.getContainer().getSkillByID("effects.swallowed_whole");

		if (effect == null)
		{
			foreach (skill in this.getContainer().m.SkillsToAdd)
			{
				if (skill.getID() != "effects.swallowed_whole")
					continue;

				effect = skill;
				break;
			}
		}

		if (effect != null)
			effect.setLink(this);

		local skill = this.getContainer().getSkillByID("actives.nacho_vomit");

		if (skill != null)
			skill.setCooldown();

		return ret;
	};
	obj.onSwallow <- function( _user )
	{
		_user.getFlags().set("has_eaten", true);
		_user.addXP(this.m.SwallowedEntity.getXPValue());
		_user.setHitpoints(::Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));
		_user.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + _user.m.Head);
		_user.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
		_user.getSprite("body").setBrush("bust_ghoulskin_body_03");
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
				this.m.SwallowedEntity.m.WorldTroop.Party.removeTroop(this.m.SwallowedEntity.m.WorldTroop);
			
			this.onSwallow(actor);
		}
		
		this.m.SwallowedEntity = null;
		this.m.IsArena = false;
		this.m.Cooldown = 0;
	};
	obj.checkCanBeSwallow <- function( _entity )
	{
		if (_entity.getFlags().has("ghoul") || _entity.getFlags().has("sand_golem"))
			return _entity.getSize() < 3;

		local type = _entity.getType();

		if (type == ::Const.EntityType.Player)
		{
			if (_entity.getFlags().has("Type"))
				type = _entity.getFlags().get("Type");
			else
				return true;
		}

		return ::Const.SwallowWholeInvalidTargets.find(type) == null;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
});