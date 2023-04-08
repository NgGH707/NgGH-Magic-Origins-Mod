this.nggh_mod_nacho_vomit_skill <- ::inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0
	},
	function setCooldown()
	{
		this.m.Cooldown = 1;
	}

	function create()
	{
		this.m.ID = "actives.nacho_vomit";
		this.m.Name = "Throw Up";
		this.m.Description = "Time to look back what i ate this morning. Uwwwww Owhwhwhwh! Looks better than i thought.";
		this.m.Icon = "skills/active_nacho_vomit.png";
		this.m.IconDisabled = "skills/active_nacho_vomit_sw.png";
		this.m.Overlay = "active_nacho_vomit";
		this.m.SoundOnHit = [
			"sounds/enemies/swallow_whole_01.wav",
			"sounds/enemies/swallow_whole_02.wav",
			"sounds/enemies/swallow_whole_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/swallow_whole_miss_01.wav",
			"sounds/enemies/swallow_whole_miss_02.wav",
			"sounds/enemies/swallow_whole_miss_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
		];

		if (!this.getContainer().hasSkill("effects.swallowed_whole"))
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Don\'t have anything inside your belly[/color]"
				}
			]);
		}

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
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0 && this.getContainer().hasSkill("effects.swallowed_whole");
	}
	
	function isHidden()
	{
		return this.getContainer().getActor().getSize() != 3 || this.skill.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile.IsEmpty;
	}

	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_eat_quote_" + ::Math.rand(1, 5), _user.getTile());
	}

	function onUse( _user, _targetTile )
	{
		this.getContainer().removeByID("effects.swallowed_whole");

		if (this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _user.getPos());
		}

		local e = _user.onAfterDeath(_targetTile);

		if (e == null)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " throws up " + ::Const.UI.getColorizedEntityName(e) + " out.");
		}

		local skill = this.getContainer().getSkillByID("actives.swallow_whole");

		if (skill == null)
		{
			skill = this.getContainer().getSkillByID("actives.legend_skin_ghoul_swallow_whole");
			
			if (skill == null)
			{
				return true;
			}
			else
			{
				_user.getSprite("body").setBrush("bust_ghoulskin_body_03");
				_user.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + _user.m.Head);
				_user.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
			}
		}
		else
		{
			_user.getSprite("body").setBrush("bust_ghoul_body_03");
			_user.getSprite("head").setBrush("bust_ghoul_03_head_0" + _user.m.Head);
			_user.getSprite("injury").setBrush("bust_ghoul_03_injured");
		}

		skill.setCooldown();
		_user.onUpdateInjuryLayer();
		return true;
	}

	function onTurnStart()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}
	
	function onCombatFinished()
	{
		this.m.Cooldown = 0;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

});

