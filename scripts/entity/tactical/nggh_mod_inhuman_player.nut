this.nggh_mod_inhuman_player <- ::inherit("scripts/entity/tactical/player", {
	m = {
		Variant = 1,
		HitpointsPerVeteranLevel = 2,
		BonusHealthRecoverMult = 0.0,
		AttributesLevelUp = null,
		ExcludedTraits = [],
		SignaturePerks = [],

		// dumb shit to go around the fucking setFaction in player.nut
		IsOnInitiating = false,
	},
	function getVariant()
	{
		return this.m.Variant;
	}

	function setVariant( _v )
	{
		this.m.Variant = _v;
		this.updateVariant();
	}

	function getHitpointsPerVeteranLevel()
	{
		return this.m.HitpointsPerVeteranLevel;
	}

	function getBonusHealthRecoverMult()
	{
		return this.m.BonusHealthRecoverMult;
	}

	function getAttributesLevelUp()
	{
		return this.m.AttributesLevelUp;
	}

	function getExcludedTraits()
	{
		return this.m.ExcludedTraits;
	}

	function getSignaturePerks()
	{
		return this.m.SignaturePerks;
	}
	
	function getStrengthMult()
	{
		return 1.0;
	}

	function getHealthRecoverMult()
	{
		return 1.0 + this.getBonusHealthRecoverMult();
	}
	
	function getDaysWounded()
	{
		if (this.getHitpoints() < this.getHitpointsMax())
		{
			return ::Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / (::Const.World.Assets.HitpointsPerHour * this.getHealthRecoverMult() * (("State" in ::World) && ::World.State != null ? ::World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);
		}
		else
		{
			return 0;
		}
	}

	function restoreArmor()
	{
		local b = this.m.BaseProperties;
		local c = this.m.CurrentProperties;
		
		for ( local i = 0; i < 2; i = i + 1 )
		{
			local add = ::Math.min(5, b.ArmorMax[i] - b.Armor[i]);
			
			if (add == 0)
			{
				continue;
			}
			
			b.Armor[i] += add;
			c.Armor[i] += add;
		}
	}

	function create()
	{
		this.player.create();
		// important flags for many crucial mechanisms
		this.m.Flags.add("nggh_character");
		this.m.Flags.remove("human");
	}

	function onFactionChanged()
	{
		if (this.m.IsOnInitiating)
		{
			return;
		}

		this.actor.onFactionChanged();
		this.onAfterFactionChanged();
	}

	function onAfterFactionChanged()
	{
	}

	function onInit()
	{
		this.m.IsOnInitiating = true;
		this.player.onInit();
		this.m.IsOnInitiating = false;
	}

	function onAfterInit()
	{
		this.player.onAfterInit();
		this.onFactionChanged();
	}

	function onTurnStart()
	{
		this.player.onTurnStart();
		this.playIdleSound();
	}

	function onTurnResumed()
	{
		this.player.onTurnResumed();
		this.playIdleSound();
	}
	
	function getRosterTooltip()
	{
		// all of this function just to make sure the 'days till full health' tooltip to display the corrected info
		local tooltip = this.player.getRosterTooltip();
		local find;

		// check if that 'days till full health' tooltip is existed
		foreach(i, t in tooltip )
		{
			if (t.id == 133)
			{
				find = i;
				break
			}
		}

		// replace its text with a corrected one or just straight up removing it if the recalculated one is 0 
		if (find != null)
		{
			local ht = this.getDaysWounded();

			if (ht == 0)
			{
				tooltip.remove(find);
			}
			else
			{
				tooltip[find].text = "Light Wounds (" + ht + " day" + (ht > 1 ? "s" : "") + ")";
			}
		}

		return tooltip;
	}

	function isReallyKilled( _fatalityType )
	{
		// can never raise as undead
		this.m.CurrentProperties.SurvivesAsUndead = false;
		return this.player.isReallyKilled(_fatalityType);
	}

	function onDeath( _killer, _skill , _tile , _fatalityType )
	{
		if (!::Tactical.State.isScenarioMode() && _fatalityType != ::Const.FatalityType.Unconscious)
		{
			if (this.getLevel() >= 11 && ::World.Assets.isIronman())
			{
				::updateAchievement("ToughFarewell", 1, 1);
			}
			else
			{
				::updateAchievement("BloodyToll", 1, 1);
			}

			if (_killer != null && ::isKindOf(_killer, "player") && _killer.getSkills().hasSkill("effects.charmed"))
			{
				::updateAchievement("NothingPersonal", 1, 1);
			}
		}
		
		if (_fatalityType != ::Const.FatalityType.Unconscious)
		{
			this.getItems().dropAll(_tile, _killer, this.m.IsCorpseFlipped);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);

		if (!this.m.IsGuest && !::Tactical.State.isScenarioMode())
		{
			::World.Assets.addScore(-5 * this.getLevel());
		}

		if (!this.m.IsGuest && !::Tactical.State.isScenarioMode() && _fatalityType != ::Const.FatalityType.Unconscious && (_skill != null && _killer != null || _fatalityType == ::Const.FatalityType.Devoured))
		{
			local killedBy;

			if (_fatalityType == ::Const.FatalityType.Devoured)
			{
				killedBy = "Devoured by a Nachzehrer";
			}
			else if (_fatalityType == ::Const.FatalityType.Suicide)
			{
				killedBy = "Committed Suicide";
			}
			else if (_skill.isType(::Const.SkillType.StatusEffect))
			{
				killedBy = _skill.getKilledString();
			}
			else if (_killer.getID() == this.getID())
			{
				killedBy = "Killed in battle";
			}
			else
			{
				if (_fatalityType == ::Const.FatalityType.Decapitated)
				{
					killedBy = "Beheaded";
				}
				else if (_fatalityType == ::Const.FatalityType.Disemboweled)
				{
					if (::Math.rand(1, 2) == 1)
					{
						killedBy = "Disemboweled";
					}
					else
					{
						killedBy = "Gutted";
					}
				}
				else
				{
					killedBy = _skill.getKilledString();
				}

				killedBy = killedBy + (" by " + _killer.getKilledName());
			}

			::World.Statistics.addFallen(this, killedBy);
		}
	}

	function addDefaultBackground( _type )
	{
		local background = ::new("scripts/skills/backgrounds/nggh_mod_charmed_background");
		background.setTempDataByType(_type);
		this.m.Skills.add(background);
		background.setup();
		background.buildDescription();
	}

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();
	}

	function isAbleToEquip( _item )
	{
		return true;
	}

	function isAbleToUnequip( _item )
	{
		return true;
	}

	function onAfterEquip( _item )
	{
		// do stuffs
	}

	function onAfterUnequip( _item )
	{
		// do stuffs
	}

	function canEnterBarber()
	{
		return true;
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
		];
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [];

	    case "head":
	        return [];   
		}

		return [];
	}

	function updateVariant()
	{
		// do nothing but its children will
	}

	function setGender( _v, _reroll = true)
	{
		// don't need for beasts
	}

	function updateInjuryVisuals( _setDirty = true )
	{
		// don't need for beasts
		this.setDirty(_setDirty);
	}

	function onSerialize( _out )
	{
		this.player.onSerialize(_out);
		_out.writeU8(this.m.Variant);
	}

	function onDeserialize( _in )
	{
		this.player.onDeserialize(_in);
		this.m.Variant = _in.readU8();

		// update stuffs
		this.updateVariant();
		this.getItems().updateAppearance();
		this.getSkills().update();
	}

});

