::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_skin_ghoul_swallow_whole_skill", function ( q )
{
	q.m.IsArena <- false;
	q.m.Cooldown <- 0;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "\"Deepthroat\" your foe into your belly. Yum! tasty right?";
		m.Icon = "skills/active_103.png";
		m.IconDisabled = "skills/active_103_sw.png";
		m.IsUsingHitchance = false;
	}

	q.setCooldown <- function()
	{
		m.SwallowedEntity = null;
		m.Cooldown = 3;
	}

	q.isFull <- function()
	{
		return !::MSU.isNull(m.SwallowedEntity);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can be used to [color=" + ::Const.UI.Color.PositiveValue + "]Swallow[/color] a target"
			}
		]);

		if (m.Cooldown > 0)
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used in " + m.Cooldown + " turn(s)[/color]"
			});

		return ret;
	}

	q.isUsable = @(__original) function()
	{
		return __original() && m.Cooldown == 0;
	}

	q.isHidden <- function()
	{
		return getContainer().getActor().getSize() < 3 || skill.isHidden();
	}

	q.onTurnStart <- function()
	{
		m.Cooldown = ::Math.max(0, m.Cooldown - 1);

		if (!isFull()) return;
		
		m.SwallowedEntity.setHitpointsPct(::Math.maxf(0.05, m.SwallowedEntity.getHitpointsPct() - 0.075));
		local b = m.SwallowedEntity.getBaseProperties();

		foreach ( BodyPart in [
			::Const.BodyPart.Body,
			::Const.BodyPart.Head
		]) 
		{
			local armorDamage = ::Math.rand(5, 12);
			local overflowDamage = armorDamage;

			if (b.Armor[BodyPart] != 0)
				overflowDamage = overflowDamage - b.Armor[BodyPart] * b.ArmorMult[BodyPart];
				b.Armor[BodyPart] = ::Math.max(0, b.Armor[BodyPart] * b.ArmorMult[BodyPart] - armorDamage);

			if (overflowDamage > 0)
				m.SwallowedEntity.getItems().onDamageReceived(overflowDamage, ::Const.FatalityType.None, BodyPart, null);
		}
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (!getContainer().getActor().isPlayerControlled())
			return __original(_originTile, _targetTile) && checkCanBeSwallow(_targetTile.getEntity());

		if (!skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();
		
		if (target.getSkills().hasSkill("racial.champion") || target.getFlags().has("IsPlayerCharacter"))
			return false;
		
		return checkCanBeSwallow(target) && !target.getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}

	q.use <- function( _targetTile, _forFree = false )
	{
		if (getContainer().getActor().getFlags().has("luft"))
			::Nggh_MagicConcept.spawnQuote("luft_swallow_quote_" + ::Math.rand(1, 4), getContainer().getActor().getTile());

		return skill.use(_targetTile, _forFree);
	}

	q.onUse = @(__original) function( _user, _targetTile )
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

		local ret = __original(_user, _targetTile);
		local effect = getContainer().getSkillByID("effects.swallowed_whole");

		if (effect == null)
		{
			foreach (skill in getContainer().m.SkillsToAdd)
			{
				if (skill.getID() != "effects.swallowed_whole")
					continue;

				effect = skill;
				break;
			}
		}

		if (effect != null)
			effect.setLink(this);

		local skill = getContainer().getSkillByID("actives.nacho_vomit");

		if (skill != null)
			skill.setCooldown();

		return ret;
	}

	q.onSwallow <- function( _user )
	{
		_user.getFlags().set("has_eaten", true);
		_user.addXP(m.SwallowedEntity.getXPValue());
		_user.setHitpoints(::Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));
		_user.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + _user.m.Head);
		_user.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
		_user.getSprite("body").setBrush("bust_ghoulskin_body_03");
	}

	q.onCombatStarted <- function()
	{
		m.IsArena = ::Tactical.State.m.StrategicProperties != null && ::Tactical.State.m.StrategicProperties.IsArenaMode;
	}

	q.onCombatFinished <- function()
	{
		local actor = getContainer().getActor();
		
		if (isFull() && ::MSU.isKindOf(actor, "player")) {
			//m.SwallowedEntity.getItems().dropAll(actor.getTile(), actor, false);
			if (!m.IsArena && m.SwallowedEntity.m.WorldTroop != null && ("Party" in m.SwallowedEntity.m.WorldTroop) && m.SwallowedEntity.m.WorldTroop.Party != null)
				m.SwallowedEntity.m.WorldTroop.Party.removeTroop(m.SwallowedEntity.m.WorldTroop);
			
			onSwallow(actor);
		}
		
		m.SwallowedEntity = null;
		m.IsArena = false;
		m.Cooldown = 0;
	}

	q.checkCanBeSwallow <- function( _entity )
	{
		if (::MSU.isIn("getSize", _entity, true))
			return _entity.getSize() < 3;

		local type = _entity.getType();

		if (type == ::Const.EntityType.Player) {
			if (_entity.getFlags().has("Type"))
				type = _entity.getFlags().get("Type");
			else
				return true;
		}

		return ::Const.SwallowWholeInvalidTargets.find(type) == null;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
});