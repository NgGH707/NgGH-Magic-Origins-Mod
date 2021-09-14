this.mc_BAT_teleportation <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Decal = "",
		StunChance = 25,
		IsTrapped = false,
		IsUsingEnergy = false,
	},
	
	function setDecal( _d )
	{
		this.m.Decal = _d;
	}
	
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_teleportation";
		this.m.Name = "Teleport";
		this.m.Description = "One second you was there, now you are here. Amazing, though it has a drawback. Can be used to escape from net, ensnare at an increased fatigue cost. Gain additional ranged at high enough resolve. Require a magic staff.";
		this.m.Icon = "skills/active_mc_03.png";
		this.m.IconDisabled = "skills/active_mc_03_sw.png";
		this.m.Overlay = "active_mc_03";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_hex_01.wav",
			"sounds/enemies/dlc2/hexe_hex_02.wav",
			"sounds/enemies/dlc2/hexe_hex_03.wav",
			"sounds/enemies/dlc2/hexe_hex_04.wav",
			"sounds/enemies/dlc2/hexe_hex_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav",
		];
		this.m.SoundVolume = 0.66;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 4;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsUtility = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local chance = this.getContainer().hasSkill("special.mc_focus") ? 25 : this.m.StunChance;
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if casting downhill"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StunChance + "%" + "[/color] chance to be dazed"
			}
		]);

		local e = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (e != null)
		{
			local a = [];
			local data = e.expectedEnergyUsage();
			a.extend(e.getEnergyTooltips(false));
			a.insert(0, {
				id = 3,
				type = "text",
				text = "[u][size=14]Absorbed Energy[/size][/u]"
			});	
			a.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Will spend [color=" + this.Const.UI.Color.PositiveValue + "]" + data.Energy + "[/color] energy to refund [color=" + this.Const.UI.Color.DamageValue + "]2[/color]-[color=" + this.Const.UI.Color.DamageValue + "]5[/color] fatigue after used"
			});
			ret.extend(a);
		}
		
		if (this.getContainer().hasSkill("effects.distracted") || this.getContainer().hasSkill("effects.dazed"))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because of the dizziness[/color]"
			});
		}
		
		return ret;
	}

	function getFatigueCost()
	{
		local ret = this.skill.getFatigueCost();

		if (this.getContainer() != null && this.getContainer().getActor() != null && this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret = this.Math.ceil(ret * 1.5);
		}

		return ret;
	}
	
	function isUsable()
	{
		return this.skill.isUsable() && this.hasStaff() && !this.getContainer().hasSkill("effects.dazed") && !this.getContainer().hasSkill("effects.distracted");
	}
	
	function onAfterUpdate( _properties )
	{
		this.mc_magic_skill.onAfterUpdate(_properties);
		this.m.MaxRange = 3 + this.bonusRange(_properties);
	}

	function bonusRange( _properties )
	{
		local resolve = _properties.getBravery() + _properties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack];
		local r = resolve - 30;

		if (r <= 0)
		{
			return 0;
		}

		return this.Math.floor(r / 50);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local e = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (e != null)
		{
			local data = e.useEnergy();
			local refund = this.Math.floor(data.Energy / 3);
			_user.setFatigue(_user.getFatigue() - refund);
		}

		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};
		
		if (_user.getCurrentProperties().IsRooted)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " breaks free from ensnared");

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.Pos);
			}

			_user.getSprite("status_rooted").Visible = false;
			_user.getSprite("status_rooted_back").Visible = false;
			
			local free = _user.getEntity().getSkills().getSkillByID("actives.break_free");
			
			if (free != null)
			{
				if (free.m.Decal != "")
				{
					local ourTile = this.getContainer().getActor().getTile();
					local candidates = [];

					if (ourTile.Properties.has("IsItemSpawned") || ourTile.IsCorpseSpawned)
					{
						for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
						{
							if (!ourTile.hasNextTile(i))
							{
							}
							else
							{
								local tile = ourTile.getNextTile(i);

								if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
								{
									candidates.push(tile);
								}
							}
						}
					}
					else
					{
						candidates.push(ourTile);
					}

					if (candidates.len() != 0)
					{
						local tileToSpawnAt = candidates[this.Math.rand(0, candidates.len() - 1)];
						tileToSpawnAt.spawnDetail(free.m.Decal);
						tileToSpawnAt.Properties.add("IsItemSpawned");
					}
				}
			}

			_user.setDirty(true);
			this.getContainer().removeByID("effects.net");
			this.getContainer().removeByID("effects.rooted");
			this.getContainer().removeByID("effects.web");
			this.getContainer().removeByID("effects.kraken_ensnare");
			this.getContainer().removeByID("effects.serpent_ensnare");
			this.getContainer().removeByID("actives.break_free");
		}

		if (_user.getTile().IsVisibleForPlayer)
		{
			_user.sinkIntoGround(0.75);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, this.onTeleportStart, tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			_tag.User.storeSpriteColors();
			_tag.User.fadeTo(this.createColor("ffffff00"), 0);
		}

		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 1000.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_tag.IgnoreColors)
		{
			_entity.restoreSpriteColors();
		}

		if (!_entity.isHiddenToPlayer())
		{
			_entity.riseFromGround(0.75);
		}

		if (_tag.Skill.m.SoundOnHit.len() > 0)
		{
			this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
		}
		
		local applyEffect = this.Math.rand(1, 100);
		local chance = _tag.Skill.m.StunChance;

		if (_tag.Skill.m.IsEnhanced)
		{
			chance = 25;
		}
		
		if (applyEffect <= chance)
		{
			_tag.Skill.m.StunChance = 25;
			_tag.User.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.User) + " teleports away and feels dizzy afterward");
		}
		else
		{
			_tag.Skill.m.StunChance = this.Math.min(95, _tag.Skill.m.StunChance + 25);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.User) + " teleports away");
		}

		_tag.Skill.m.IsEnhanced = false;
	}

	function onTurnStart()
	{
		this.m.StunChance = this.Math.max(25, this.m.StunChance - 10);
	}
	
	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Boot;
	}
	
});

