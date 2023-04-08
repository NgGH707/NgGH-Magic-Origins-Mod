this.nggh_mod_patting_skill <- ::inherit("scripts/skills/skill", {
	m = {
		StunChance = 33,
		Count = 0,
		Hit = 0,
		Kill = 0,
	},
	function setStunChance( _c )
	{
		this.m.StunChance = _c;
	}

	function create()
	{
		this.m.ID = "actives.patting";
		this.m.Name = "Petting";
		this.m.Description = "An indescribable nice pat, you can feel the love deep inside and want to be petted more and more. Just kidding!!! This is a dangerous mental attack that can distract or incapacitate anyone unlucky enough to fall for its trick unless your head is crushed by its memetic power first.";
		this.m.Icon = "skills/patting_skill.png";
		this.m.IconDisabled = "skills/patting_skill_sw.png";
		this.m.Overlay = "patting_skill";
		this.m.SoundOnUse = ::Const.Sound.JesterImpact;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 2;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 100;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		
		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to hit the head"
		});
		
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] chance to distract on a hit"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.StunChance + "%[/color] chance to distract on a hit"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_pet_quote_" + ::Math.rand(1, 5), _user.getTile());
	}

	function onUse( _user, _targetTile )
	{
		++this.m.Count;
		this.spawnAttackEffect(_targetTile, ::Const.AttackEffectPetting);
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive())
		{
			local target = _targetTile.getEntity();
			local chance = _user.getCurrentProperties().IsSpecializedInHammers ? 50 : this.m.StunChance;
			target.checkMorale(1, 0, ::Const.MoraleCheckType.Default);

			if (::Math.rand(1, 100) <= chance)
			{
				target.getSkills().add(::new("scripts/skills/effects/distracted_effect"));

				if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer))
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " is distracted due to the pet");
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local size = this.getContainer().getActor().getSize();
			_properties.DamageRegularMin = 10 + 15 * size;
			_properties.DamageRegularMax = 20 + 15 * size;
			_properties.DamageArmorMult = 0.5;
			_properties.DamageDirectAdd += 0.2;
			_properties.HitChance[::Const.BodyPart.Head] += 100.0;
			
			if (_properties.IsSpecializedInHammers)
			{
				_properties.DamageTotalMult *= 1.5;
			}
		}
	}

	function onCombatStarted()
	{
		this.m.Count = 0;
		this.m.Hit = 0;
		this.m.Kill = 0;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (this.m.Hit == 0 && this.m.Count > 0)
		{
			actor.worsenMood(1.0, "They dodged all my head pats");
		}
		else if (this.m.Hit == 0)
		{
			actor.worsenMood(0.2, "Can\'t give any head pat in this battle");
		}
		else
		{
			actor.improveMood(0.2, "Just pet someone in last ballte");
		}

		if (this.m.Kill != 0)
		{
			actor.improveMood(0.2, "I just killed someone with my head pat");
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this)
		{
			++this.m.Hit;
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_skill = this)
		{
			++this.m.Kill;
		}
	}

});

