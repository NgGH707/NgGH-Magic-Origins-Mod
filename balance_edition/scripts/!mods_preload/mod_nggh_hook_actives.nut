this.getroottable().Nggh_MagicConcept.hookActives <- function ()
{
	local dismount_skills = [
		"unleash_wardog",
		"unleash_wolf",
		"legend_unleash_white_wolf",
		"legend_unleash_warbear"
	];

	foreach ( active in dismount_skills )
	{
		::mods_hookExactClass("skills/actives/" + active, function(obj) 
		{
			local onUse = ::mods_getMember(obj, "onUse");
			obj.onUse = function(_user, _targetTile)
			{
				local ret = onUse(_user, _targetTile);

				if (ret && ("isMounted" in _user.get()))
				{
					_user.m.Mount.onDismountPet();
				}

				return ret;
			}
		});
	}


	//
	::mods_hookExactClass("skills/actives/throw_holy_water", function(obj) 
	{
		obj.m.AttackerID <- null;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsAttack = false;
		};
		obj.onAdded <- function()
		{
			this.m.AttackerID = this.getContainer().getActor().getID();
		};
		local ws_onVerifyTarget = obj.onVerifyTarget;
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!ws_onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			local target = _targetTile.getEntity();

			if (target.isAlliedWith(this.getContainer().getActor()) && !target.getSkills().hasSkill("effects.ghost_possessed"))
			{
				return false;
			}

			return true;
		};
		local ws_applyEffect = obj.applyEffect;
		obj.applyEffect = function( _target )
		{
			local possess = _target.getSkills().getSkillByID("effects.ghost_possessed");

			if (possess != null)
			{
				possess.m.AttackerID = this.m.AttackerID;
				possess.setExorcised(true);
				possess.removeSelf();
				_target.getSkills().update();
			}

			ws_applyEffect(_target);
		};
	});


	//
	::mods_hookExactClass("skills/actives/legend_call_lightning", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Overlay = "lightning_square";
			this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
			this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
			this.m.MaxRange = 4;
			this.m.FatigueCost = 26;
		}
		
		local ws_isHidden = obj.isHidden;
		obj.isHidden = function()
	    {
	    	if (this.getContainer().getActor().isArmedWithMagicStaff())
			{
				return false;
			}

	        return ws_isHidden();
    	};
    	obj.getTooltip = function()
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
					icon = "ui/icons/regular_damage.png",
					text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]25[/color] - [color=" + this.Const.UI.Color.DamageValue + "]50[/color] damage that ignores armor"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text =  "[color=" + this.Const.UI.Color.PositiveValue + "]15%[/color] chance to call lightning on each unit within [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				}
			];

			return ret;
    	};
    	obj.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getAllInstancesAsArray();
			local count = 0;

			foreach (a in actors)
			{
				if (a.getFaction() == _user.getFaction())
				{
					continue;
				}

				local t = a.getTile();

				if (t.getDistanceTo(myTile) > this.getMaxRange())
				{
					continue;
				}

				if (this.Math.rand(1, 100) > 15)
				{
					continue;
				}

				this.Time.scheduleEvent(this.TimeUnit.Real, count * 30, function ( _data )
				{
					local tile = _data.Tile;

					for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, tile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
					}

					if ((tile.IsEmpty || tile.IsOccupiedByActor) && tile.Type != this.Const.Tactical.TerrainType.ShallowWater && tile.Type != this.Const.Tactical.TerrainType.DeepWater)
					{
						tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
						tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
					}
					
					local target = tile.getEntity();
					local hitInfo = clone this.Const.Tactical.HitInfo;
					hitInfo.DamageRegular = this.Math.rand(25, 50);
					hitInfo.DamageArmor = 0;
					hitInfo.DamageDirect = 1.0;
					hitInfo.BodyPart = 0;
					hitInfo.FatalityChanceMult = 0.0;
					hitInfo.Injuries = this.Const.Injury.BurningBody;
					target.onDamageReceived(_data.User, _data.Skill, hitInfo);
				}, {
					Tile = t,
					Skill = this,
					User = _user
				});

				++count;
			}
		};
	});


	//
	::mods_hookExactClass("skills/actives/lightning_storm_skill", function(obj) 
	{
		obj.getAffectedTiles = function( _targetTile )
		{
			local ret = [];
			local size = this.Tactical.getMapSize();
			local styles = [1, 2, 3, 4];
			local last_attack_style = this.Tactical.Entities.getFlags().getAsInt("LightningStrikesStyle");

			if (last_attack_style != 0)
			{
				styles.remove(styles.find(last_attack_style));
			}

			local choose = styles[this.Math.rand(0, styles.len() - 1)];
			this.Tactical.Entities.getFlags().set("LightningStrikesStyle", choose);
			switch (choose)
			{
			case 1:
				// vertical
				for( local y = 0; y < size.Y; y = ++y )
				{
					local tile = this.Tactical.getTileSquare(_targetTile.SquareCoords.X, y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.push(tile);
					}
				}
				break;

			case 2:
				// horizonal
				for( local x = 0; x < size.X; x = ++x )
				{
					local tile = this.Tactical.getTileSquare(x, _targetTile.SquareCoords.Y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.push(tile);
					}
				}
				break;

			case 3:
				// diagonal up
				local NE_tile = _targetTile.hasNextTile(this.Const.Direction.NE) ? _targetTile.getNextTile(this.Const.Direction.NE) : null;
				local SW_tile = _targetTile.hasNextTile(this.Const.Direction.SW) ? _targetTile.getNextTile(this.Const.Direction.SW) : null;

				if (NE_tile != null)
				{
					local next = _targetTile.SquareCoords.Y != NE_tile.SquareCoords.Y;
					local y = NE_tile.SquareCoords.Y;

					for( local x = NE_tile.SquareCoords.X; x >= 0; x = --x )
					{
						local tile = this.Tactical.getTileSquare(x, y);

						if (!tile.IsEmpty && !tile.IsOccupiedByActor)
						{
						}
						else
						{
							ret.push(tile);
						}

						if (next)
						{
							--y;
						}
	
						next = !next;
					}
				}

				if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
				{
					ret.push(_targetTile);
				}

				if (SW_tile != null)
				{
					local next = _targetTile.SquareCoords.Y != SW_tile.SquareCoords.Y;
					local y = SW_tile.SquareCoords.Y;

					for( local x = SW_tile.SquareCoords.X; x < size.X; x = ++x )
					{
						local tile = this.Tactical.getTileSquare(x, y);

						if (!tile.IsEmpty && !tile.IsOccupiedByActor)
						{
						}
						else
						{
							ret.push(tile);
						}

						if (next)
						{
							++y;
						}
	
						next = !next;
					}
				}
				break;

			case 4:
				// diagonal down
				local NW_tile = _targetTile.hasNextTile(this.Const.Direction.NW) ? _targetTile.getNextTile(this.Const.Direction.NW) : null;
				local SE_tile = _targetTile.hasNextTile(this.Const.Direction.SE) ? _targetTile.getNextTile(this.Const.Direction.SE) : null;

				if (NW_tile != null)
				{
					local next = _targetTile.SquareCoords.Y != NW_tile.SquareCoords.Y;
					local y = NW_tile.SquareCoords.Y;

					for( local x = NW_tile.SquareCoords.X; x >= 0; x = --x )
					{
						local tile = this.Tactical.getTileSquare(x, y);

						if (!tile.IsEmpty && !tile.IsOccupiedByActor)
						{
						}
						else
						{
							ret.push(tile);
						}

						if (!next)
						{
							++y;
						}

						next = !next;
					}
				}

				if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
				{
					ret.push(_targetTile);
				}

				if (SE_tile != null)
				{
					local next = _targetTile.SquareCoords.Y != SE_tile.SquareCoords.Y;
					local y = SE_tile.SquareCoords.Y;

					for( local x = SE_tile.SquareCoords.X; x < size.X; x = ++x )
					{
						local tile = this.Tactical.getTileSquare(x, y);

						if (!tile.IsEmpty && !tile.IsOccupiedByActor)
						{
						}
						else
						{
							ret.push(tile);
						}

						if (!next)
						{
							--y;
						}

						next = !next;
					}
				}
				break;	
			}

			return ret;
		};
		obj.onImpact = function( _tag )
		{
			this.Tactical.EventLog.log("Lightning strikes the battlefield");
			this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
			local actor = this.getContainer().getActor();

			foreach( i, t in _tag.m.AffectedTiles )
			{
				this.Time.scheduleEvent(this.TimeUnit.Real, i * 30, function ( _data )
				{
					local tile = _data.Tile;

					for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, tile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
					}

					tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
					tile.Properties.IsMarkedForImpact = false;

					if ((tile.IsEmpty || tile.IsOccupiedByActor) && tile.Type != this.Const.Tactical.TerrainType.ShallowWater && tile.Type != this.Const.Tactical.TerrainType.DeepWater)
					{
						tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
						tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
					}

					if (tile.IsOccupiedByActor)
					{
						local target = tile.getEntity();
						local isLich = _data.User.getType() == this.Const.EntityType.SkeletonLichMirrorImage || _data.User.getType() == this.Const.EntityType.SkeletonLich;
						local isTagertHexe = target.getType() == this.Const.EntityType.Hexe || target.getType() == this.Const.EntityType.LegendHexeLeader;
						local isHexe = _data.User.getType() == this.Const.EntityType.Hexe || _data.User.getType() == this.Const.EntityType.LegendHexeLeader;
						local isAllied = _data.User.isAlliedWith(target);

						if ((_data.User.getID() == target.getID()) || (isLich && isAllied) || (isAllied && isHexe && isTagertHexe))
						{
						}
						else
						{
							local mult = isAllied ? 0.5 : 1.0;
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(25, 50) * mult;
							hitInfo.DamageArmor = hitInfo.DamageRegular * 1.0;
							hitInfo.DamageDirect = 0.75;
							hitInfo.BodyPart = 0;
							hitInfo.FatalityChanceMult = 0.0;
							hitInfo.Injuries = this.Const.Injury.BurningBody;
							target.onDamageReceived(_data.User, _data.Skill, hitInfo);
						}
					}
				}, {
					Tile = t,
					Skill = this,
					User = actor
				});
			}

			_tag.m.AffectedTiles = [];

			if (_tag.m.HasCooldownAfterImpact)
			{
				_tag.m.Cooldown = 1;
			}

			this.Tactical.Entities.getFlags().set("LightningStrikesActive", this.Math.max(0, this.Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
		};
		obj.onAnySkillUsed = function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				_properties.DamageRegularMin = 25;
				_properties.DamageRegularMax = 50;
				_properties.DamageArmorMult = 1.0;
			}
		}
	});


	//
	::mods_hookExactClass("skills/actives/miasma_skill", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Release a cloud of noxious gasses that effects living beings";
			this.m.Icon = "skills/active_101.png";
			this.m.IconDisabled = "skills/active_101_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
			this.m.FatigueCost = 20;
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.ActionPointCost = 8;
				this.m.FatigueCost = 30;
				this.m.MinRange = 1;
				this.m.MaxRange = 6;
			}
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
					id = 3,
					type = "text",
					text = this.getCostString()
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/damage_received.png",
					text = "Deals 5-10 damage per turn over four turns"
				}
			];
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = _targetTile;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!ownTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = ownTile.getNextTile(i);

					if (this.Math.abs(tile.Level - ownTile.Level) <= 1)
					{
						this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
					}
				}
			}
		};
	});


	// make fallen sword saint op with this sword
	::mods_hookExactClass("skills/actives/slash_lightning", function(obj) 
	{
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().getFlags().has("isSwordSaint"))
			{
				this.m.IsUsingHitchance = false;
				this.m.ChanceDecapitate = 100;
				this.m.ChanceDisembowel = 0;
				this.m.ChanceSmash = 0;

				local bite = this.getContainer().getSkillByID("actives.zombie_bite");
			
				if (bite == null)
				{
					return;
				}

				bite.m.IsHidden = true;
			}
		};
		obj.onUse = function( _user, _targetTile )
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
			local success = this.attackEntity(_user, _targetTile.getEntity());
			local myTile = _user.getTile();

			if (success && _user.isAlive())
			{
				local selectedTargets = [];
				local potentialTargets = [];
				local potentialTiles = [];
				local target;
				local targetTile = _targetTile;

				if (this.m.SoundOnLightning.len() != 0)
				{
					this.Sound.play(this.m.SoundOnLightning[this.Math.rand(0, this.m.SoundOnLightning.len() - 1)], this.Const.Sound.Volume.Skill * 2.0, _user.getPos());
				}

				if (!targetTile.IsEmpty && targetTile.getEntity().isAlive())
				{
					target = targetTile.getEntity();
					selectedTargets.push(target.getID());
				}

				local data = {
					Skill = this,
					User = _user,
					TargetTile = targetTile,
					Target = target
				};
				this.applyEffect(data, 100);
				potentialTargets = [];
				potentialTiles = [];

				for( local i = 0; i < 6; i = ++i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = targetTile.getNextTile(i);

						if (tile.ID != myTile.ID)
						{
							potentialTiles.push(tile);
						}

						if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
						{
						}
						else
						{
							potentialTargets.push(tile);
						}
					}
				}

				if (potentialTargets.len() != 0)
				{
					target = potentialTargets[this.Math.rand(0, potentialTargets.len() - 1)].getEntity();
					selectedTargets.push(target.getID());
					targetTile = target.getTile();
				}
				else
				{
					target = null;
					targetTile = potentialTiles[this.Math.rand(0, potentialTiles.len() - 1)];
				}

				local data = {
					Skill = this,
					User = _user,
					TargetTile = targetTile,
					Target = target
				};
				this.applyEffect(data, 350);
				potentialTargets = [];
				potentialTiles = [];

				for( local i = 0; i < 6; i = ++i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = targetTile.getNextTile(i);

						if (tile.ID != myTile.ID)
						{
							potentialTiles.push(tile);
						}

						if (!tile.IsOccupiedByActor || !tile.getEntity().isAttackable() || tile.getEntity().isAlliedWith(_user) || selectedTargets.find(tile.getEntity().getID()) != null)
						{
						}
						else
						{
							potentialTargets.push(tile);
						}
					}
				}

				if (potentialTargets.len() != 0)
				{
					target = potentialTargets[this.Math.rand(0, potentialTargets.len() - 1)].getEntity();
					selectedTargets.push(target.getID());
					targetTile = target.getTile();
				}
				else
				{
					target = null;
					targetTile = potentialTiles[this.Math.rand(0, potentialTiles.len() - 1)];
				}

				local data = {
					Skill = this,
					User = _user,
					TargetTile = targetTile,
					Target = target
				};
				this.applyEffect(data, 550);
			}

			return success;
		};
	});


	// barbarian
	::mods_hookExactClass("skills/actives/barbarian_fury_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Switch places with another character directly adjacent, provided neither the target is stunned or rooted, nor the character using the skill is. Rotate the battle line to keep fresh troops in front!";
			this.m.Icon = "skills/active_175.png";
			this.m.IconDisabled = "skills/active_175_sw.png";
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 10 : 5;
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
				}
			];

			if (this.getContainer().getActor().getCurrentProperties().IsRooted)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
				});
			}
			
			if (this.m.IsSpent)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
				});
			}

			return ret;
		};
		obj.getCursorForTile <- function( _tile )
		{
			return this.Const.UI.Cursor.Rotation;
		};
	});


	// barbarian
	::mods_hookExactClass("skills/actives/drums_of_war_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Inspire your men with rhythm of war";
			this.m.Icon = "skills/active_163.png";
			this.m.IconDisabled = "skills/active_163_sw.png";
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultUtilityTooltip();
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Lowers the fatigue of every brother by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] instantly."
				}
			]);
			return ret;
		}
	});


	// barbarian
	::mods_hookExactClass("skills/actives/crack_the_whip_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Whip the air, making an astonishing sound that reminding your beasts who is the boss here.";
			this.m.Icon = "skills/active_162.png";
			this.m.IconDisabled = "skills/active_162_sw.png";
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 15 : 10;
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
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Resets the morale of the all beasts to \'Steady\' if currently below"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Removes the Sleeping status effect of allies"
				}
			];
			
			if (this.m.IsUsed)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
				});
			}

			return ret;
		};
		obj.isUsable = function()
		{
			if (this.m.IsUsed)
			{
				return false;
			}

			if (!this.skill.isUsable() || this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
			{
				return false;
			}
			
			if (this.getContainer().getActor().isPlayerControlled())
			{
				return true;
			}

			local actors = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());

			foreach( a in actors )
			{
				if (a.getType() == this.Const.EntityType.BarbarianUnhold || a.getType() == this.Const.EntityType.BarbarianUnholdFrost)
				{
					return true;
				}
			}

			return false;
		};
		obj.onUse = function( _user, _targetTile )
		{
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

			foreach( a in actors )
			{
				a.getSkills().removeByID("effects.sleeping");
				
				if ((a.getType() != this.Const.EntityType.BarbarianUnhold && a.getType() != this.Const.EntityType.BarbarianUnholdFrost) || !this.isKindOf(a, "player_beast"))
				{
					continue;
				}
				
				if (_user.isPlayerControlled())
				{
					if (a.getMoraleState() < this.Const.MoraleState.Steady)
					{
						a.setMoraleState(this.Const.MoraleState.Steady);
					}
					
					this.spawnIcon("status_effect_106", a.getTile());
					continue;
				}
				
				a.setWhipped(true);
				this.spawnIcon("status_effect_106", a.getTile());
			}

			this.m.IsUsed = true;
			return true;
		};
	});


	// nomad
	::mods_hookExactClass("skills/actives/throw_dirt_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Play nice would not grant you victory everytime, a little dirty trick can easily boost your win chance. Wild Nomad uses sand-attack!!!";
			this.m.Icon = "skills/active_215.png";
			this.m.IconDisabled = "skills/active_215_sw.png";
			this.m.IsUsingHitchance = false;
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 12 : 5;
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
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Throws dirt or sand at the enemy face"
				}
			];
			return ret;
		};
		obj.isUsable = function()
		{
			return this.skill.isUsable();
		};
		obj.onUse = function( _user, _targetTile )
		{
			if (_targetTile.getEntity().isAlliedWithPlayer())
			{
				local effect = {
					Delay = 0,
					Quantity = 20,
					LifeTimeQuantity = 20,
					SpawnRate = 400,
					Brushes = [
						"sand_dust_01"
					],
					Stages = [
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.2,
							ColorMin = this.createColor("eeeeee00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 0.5,
							ScaleMax = 0.5,
							RotationMin = 0,
							RotationMax = 359,
							VelocityMin = 60,
							VelocityMax = 100,
							DirectionMin = this.createVec(-0.7, -0.6),
							DirectionMax = this.createVec(-0.6, -0.6),
							SpawnOffsetMin = this.createVec(-35, -15),
							SpawnOffsetMax = this.createVec(35, 20)
						},
						{
							LifeTimeMin = 0.75,
							LifeTimeMax = 1.0,
							ColorMin = this.createColor("eeeeeeee"),
							ColorMax = this.createColor("ffffffff"),
							ScaleMin = 0.5,
							ScaleMax = 0.75,
							VelocityMin = 60,
							VelocityMax = 100,
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.2,
							ColorMin = this.createColor("eeeeee00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 0.75,
							ScaleMax = 1.0,
							VelocityMin = 0,
							VelocityMax = 0,
							ForceMin = this.createVec(0, -100),
							ForceMax = this.createVec(0, -100)
						}
					]
				};
				this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(30, 70));
			}
			else
			{
				local effect = {
					Delay = 0,
					Quantity = 20,
					LifeTimeQuantity = 20,
					SpawnRate = 400,
					Brushes = [
						"sand_dust_01"
					],
					Stages = [
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.2,
							ColorMin = this.createColor("eeeeee00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 0.5,
							ScaleMax = 0.5,
							RotationMin = 0,
							RotationMax = 359,
							VelocityMin = 60,
							VelocityMax = 100,
							DirectionMin = this.createVec(0.6, -0.6),
							DirectionMax = this.createVec(0.7, -0.6),
							SpawnOffsetMin = this.createVec(-35, -15),
							SpawnOffsetMax = this.createVec(35, 20)
						},
						{
							LifeTimeMin = 1.0,
							LifeTimeMax = 1.25,
							ColorMin = this.createColor("eeeeeeee"),
							ColorMax = this.createColor("ffffffff"),
							ScaleMin = 0.5,
							ScaleMax = 0.75,
							VelocityMin = 60,
							VelocityMax = 100,
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.2,
							ColorMin = this.createColor("eeeeee00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 0.75,
							ScaleMax = 1.0,
							VelocityMin = 0,
							VelocityMax = 0,
							ForceMin = this.createVec(0, -100),
							ForceMax = this.createVec(0, -100)
						}
					]
				};
				this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(-30, 70));
			}

			local s = this.new("scripts/skills/effects/distracted_effect");
			_targetTile.getEntity().getSkills().add(s);
			this.Tactical.getShaker().shake(_targetTile.getEntity(), _user.getTile(), 4);

			if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " throws dirt in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "\'s face to distract them");
			}

			return true;
		};
	});


	// orc
	::mods_hookExactClass("skills/actives/charge", function ( obj )
	{
		obj.m.rawdelete("IsSpent");

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Throw yourself at the enemies and slam at them with your hugemungus body.";
			this.m.Icon = "skills/active_52.png";
			this.m.IconDisabled = "skills/active_52_sw.png";
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 30 : 25;
			local AI = this.getContainer().getActor().getAIAgent();

			if (AI.getID() == this.Const.AI.Agent.ID.Player)
			{
				return;
			}

			AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_charge"));
			AI.m.Properties.EngageRangeMin = 1;
			AI.m.Properties.EngageRangeMax = 2;
			AI.m.Properties.EngageRangeIdeal = 2;
		};
		obj.getTooltip = function()
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
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can cause [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color]"
				}
			];
		};
		obj.isUsable = function()
		{
			return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
		};
		obj.onTurnStart = function() {};
		obj.onUse = function( _user, _targetTile )
		{
			local tag = {
				Skill = this,
				User = _user,
				OldTile = _user.getTile(),
				TargetTile = _targetTile,
				OnRepelled = this.onRepelled
			};

			if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
			{
				local myPos = _user.getPos();
				local targetPos = _targetTile.Pos;
				local distance = tag.OldTile.getDistanceTo(_targetTile);
				local Dx = (targetPos.X - myPos.X) / distance;
				local Dy = (targetPos.Y - myPos.Y) / distance;

				for( local i = 0; i < distance; i = ++i )
				{
					local x = myPos.X + Dx * i;
					local y = myPos.Y + Dy * i;
					local tile = this.Tactical.worldToTile(this.createVec(x, y));

					if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
					{
						for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
						}
					}
				}
			}

			this.Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone, tag, false, 2.0);
			return true;
		};
	});


	// orc
	::mods_hookExactClass("skills/actives/line_breaker", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Ram hard at an enemy and use your brute force to knock that target to the side.";
			this.m.Icon = "skills/active_53.png";
			this.m.IconDisabled = "skills/active_53_sw.png";
			this.m.IsAttack = false;
		};
		obj.onAdded <- function()
		{
			local AI = this.getContainer().getActor().getAIAgent();

			if (AI.getID() == this.Const.AI.Agent.ID.Player)
			{
				return;
			}

			AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_line_breaker"));
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
					id = 3,
					type = "text",
					text = this.getCostString()
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Knock a target to the side then move forward"
				}
			];
		}
	});


	// orc
	::mods_hookExactClass("skills/actives/warcry", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A deafening roar to that can easily scare the shit out of you and raise morale for your warriors.";
			this.m.Icon = "skills/active_49.png";
			this.m.IconDisabled = "skills/active_49_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.FatigueCost = 30;
				this.m.ActionPointCost = 4;
			}
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
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Affects every entity within [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles distance"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Triggers a positive morale check or rally allies"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Triggers a negative morale check to enemies"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Removes the Sleeping status effect of anyone within range"
				}
			];
			
			if (this.m.IsSpent)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
				});
			}

			return ret;
		};
		obj.onDelayedEffect = function( _tag )
		{
			local mytile = _tag.User.getTile();
			local actors = this.Tactical.Entities.getAllInstances();
			local p = _tag.User.getCurrentProperties();
			local bonus = p.Threat + this.Math.min(15, p.ThreatOnHit);
			local isPlayer = _tag.User.getFaction() == this.Const.Faction.Player;

			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() == _tag.User.getID())
					{
						continue;
					}

					local dis = a.getTile().getDistanceTo(mytile);

					if (dis > _tag.Skill.getMaxRange())
					{
						continue;
					} 

					if (a.getFaction() == _tag.User.getFaction())
					{
						local difficulty = 10 + bonus - this.Math.pow(dis, this.Const.Morale.EnemyKilledDistancePow);

						if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
						{
							a.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, difficulty);
						}
						else
						{
							a.checkMorale(1, difficulty);
						}

						if (a.getFaction() != this.Const.Faction.Player) a.setFatigue(a.getFatigue() - 20);
					}
					else if (a.getFaction() == this.Const.Faction.PlayerAnimals && isPlayer)
					{
					}
					else
					{
						local difficulty = bonus + 10 - this.Math.pow(dis, this.Const.Morale.AllyKilledDistancePow);
						a.checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
					}

					a.getSkills().removeByID("effects.sleeping");
				}
			}
		};
	});


	// goblin
	::mods_hookExactClass("skills/actives/goblin_whip", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Whip!";
			this.m.Description = "Whip your goblin troops to remind them know who is the boss here. Stand your ground!";
			this.m.Icon = "skills/active_72.png";
			this.m.IconDisabled = "skills/active_72_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
			this.m.IsWeaponSkill = false;
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 12 : 5;
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
					id = 3,
					type = "text",
					text = this.getCostString()
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Resets the morale of the targeted [color=" + this.Const.UI.Color.DamageValue + "]goblin[/color] up to \'Confident\' if currently below"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Removes the Sleeping status effect of targeted goblin"
				}
			];
		};
	});


	// goblin
	::mods_hookExactClass("skills/actives/grant_night_vision_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A simple chant to give a group of your men the ability to see through the darkness of the night.";
			this.m.Icon = "skills/active_156.png";
			this.m.IconDisabled = "skills/active_156_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
			this.m.IsTargetingActor = false;
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 15 : this.m.FatigueCost;
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
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]Removes[/color] nighttime penalties to a group of allies"
				}
			];
			
			if (this.m.IsSpent)
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
				});
			}

			return ret;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
				}
			}
		}
	});


	// goblin
	::mods_hookExactClass("skills/actives/insects_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Call a swarm of insects to swarm around a target. I hopp it\'s a cockroach swarm. Can\'t be used while engaging in melee.";
			this.m.Icon = "skills/active_69.png";
			this.m.IconDisabled = "skills/active_69_sw.png";
		};

		local ws_getTooltip = obj.getTooltip;
		obj.getTooltip = function()
		{
			local ret = ws_getTooltip();

			ret.insert(3, {
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			});

			if (this.Tactical.isActive() && this.getContainer().getActor().isEngagedInMelee())
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
				});
			}

			return ret;
		};
	});


	// goblin
	::mods_hookExactClass("skills/actives/root_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Unleash roots from the ground to ensnare your foes. Fatigue and AP costs reduced while raining and with staff mastery. ";
			this.m.Icon = "skills/active_70.png";
			this.m.IconDisabled = "skills/active_70_sw.png";
		};
		obj.onAdded <- function()
		{
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 20 : this.m.FatigueCost;
		};
		obj.getTooltip <- function()
		{
			local ret = this.skill.getDefaultUtilityTooltip();
			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 7 targets"
				},
				{
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Trapped targets in Vines"
				}
			]);
			return ret;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
				}
			}
		};
	});


	// disallow the use of footwork while mounting
	::mods_hookExactClass("skills/actives/footwork", function(obj) 
	{
	    obj.isHidden <- function()
	    {
	        local skill = this.getContainer().getSkillByID("special.goblin_rider");

	        if (skill != null)
	        {
	        	return skill.isMounted();
	        }

	        return this.m.IsHidden;
	    }
	});


	// a slight buff for goblin balls
	::mods_hookExactClass("skills/actives/throw_balls", function ( obj )
	{
		obj.onTargetHit <- function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_skill == this && _targetEntity.isAlive() && this.Math.rand(1, 100) <= 33)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " has staggered " + this.Const.UI.getColorizedEntityName(_targetEntity) + " for one turn");
			}
		}
	});


	// hexe
	::mods_hookExactClass("skills/actives/charm_skill", function ( obj )
	{
		obj.isViableTarget = function( _user, _target )
		{
			if (_target.isAlliedWith(_user))
			{
				return false;
			}

			if (_target.getMoraleState() == this.Const.MoraleState.Ignore || _target.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				return false;
			}

			if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
			{
				return false;
			}
			
			if (_target.getType() == this.Const.EntityType.Hexe || _target.getType() == this.Const.EntityType.LegendHexeLeader)
			{
				return false;
			}
			
			if (_target.isNonCombatant())
			{
				return false;
			}

			local skills = [
				"effects.fake_charmed_broken",
				"effects.charmed",
				"effects.charmed_captive",
				"effects.legend_intensely_charmed",
			];

			foreach ( id in skills ) 
			{
			    if (_target.getSkills().hasSkill(id))
			    {
			    	return false;
			    }
			}
			
			if (_target.getFlags().has("Hexe"))
			{
				return false;
			}

			return true;
		};
		obj.onDelayedEffect = function( _tag )
		{
			local _targetTile = _tag.TargetTile;
			local _user = _tag.User;
			local target = _targetTile.getEntity();
			local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
			local self = this;
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
			{
				local bonus = _targetTile.getDistanceTo(_user.getTile()) == 1 ? -5 : 0;

				if (!this.isViableTarget(_user, target) || target.getSkills().hasSkill("background.eunuch") || target.getSkills().hasSkill("trait.player"))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " can not be charmed");
					}

					return false;
				}

				if (target.checkMorale(0, -35 + bonus, this.Const.MoraleCheckType.MentalAttack))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
					}

					return false;
				}

				if (target.checkMorale(0, -35 + bonus, this.Const.MoraleCheckType.MentalAttack))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
					}

					return false;
				}

				this.m.Slaves.push(target.getID());
				local charmed = this.new("scripts/skills/effects/charmed_effect");
				charmed.setMasterFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : _user.getFaction());
				charmed.setMaster(self);
				target.getSkills().add(charmed);

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is charmed");
				}

				_user.setCharming(true);
			}.bindenv(this), this);
		};
	});


	// hexe
	::mods_hookExactClass("skills/actives/legend_intensely_charm_skill", function ( obj )
	{
		obj.isViableTarget = function( _user, _target )
		{
			if (_target.isAlliedWith(_user))
			{
				return false;
			}

			if (_target.getMoraleState() == this.Const.MoraleState.Ignore || _target.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				return false;
			}

			if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
			{
				return false;
			}
			
			if (_target.getType() == this.Const.EntityType.Hexe || _target.getType() == this.Const.EntityType.LegendHexeLeader)
			{
				return false;
			}
			
			if (_target.isNonCombatant())
			{
				return false;
			}

			local skills = [
				"effects.fake_charmed_broken",
				"effects.charmed",
				"effects.charmed_captive",
				"effects.legend_intensely_charmed",
			];

			foreach ( id in skills ) 
			{
			    if (_target.getSkills().hasSkill(id))
			    {
			    	return false;
			    }
			}
			
			if (_target.getFlags().has("Hexe"))
			{
				return false;
			}

			return true;
		};
		obj.onDelayedEffect = function( _tag )
		{
			local _targetTile = _tag.TargetTile;
			local _user = _tag.User;
			local target = _targetTile.getEntity();
			local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
			local self = this;
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
			{
				local bonus = _targetTile.getDistanceTo(_user.getTile()) == 1 ? -5 : 0;

				if (!this.isViableTarget(_user, target) || target.getSkills().hasSkill("background.eunuch") || target.getSkills().hasSkill("trait.player") || target.getSkills().hasSkill("trait.loyal"))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " cannot be charmed");
					}

					return false;
				}

				if (target.checkMorale(0, -50 + bonus, this.Const.MoraleCheckType.MentalAttack))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
					}

					return false;
				}

				if (target.checkMorale(0, -50 + bonus, this.Const.MoraleCheckType.MentalAttack))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve");
					}

					return false;
				}

				this.m.Slaves.push(target.getID());
				local charmed = this.new("scripts/skills/effects/legend_intensely_charmed_effect");
				charmed.setMasterFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : _user.getFaction());
				charmed.setMaster(self);
				target.getSkills().add(charmed);

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is intensely charmed");
				}

				_user.setCharming(true);
			}.bindenv(this), this);
		};
	});


	// ghost
	::mods_hookExactClass("skills/actives/ghastly_touch", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A touch of something doesn\'t belong to the living world. Quickly and surely draining away any piece of life your victim has.";
			this.m.KilledString = "Frightened to death";
			this.m.Icon = "skills/active_42.png";
			this.m.IconDisabled = "skills/active_42_sw.png";
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Completely ignores armor"
			});
			return ret;
		};
	});


	// ghost
	::mods_hookExactClass("skills/actives/horrific_scream", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Blare out a piercing, unworldly sound that is more than likely to distress anyone unfortunate enough to hear it within 4 tiles. Uses ranged skill";
			this.m.Icon = "skills/active_41.png";
			this.m.IconDisabled = "skills/active_41_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultUtilityTooltip();
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			});
			return ret;
		}
	});


	// stop hexe background from getting this skill
	::mods_hookExactClass("skills/actives/legend_hex_skill", function(obj) 
	{
		obj.onAdded <- function()
		{
			this.m.IsHidden = this.getContainer().getActor().getFlags().has("Hexe");
		}
	});


	// non-human players don't feel disgusting at people eating corpse
	::mods_hookExactClass("skills/actives/legend_gruesome_feast", function ( obj )
	{
		obj.hasCorpseNearby <- function()
		{
			return this.getContainer().getActor().getTile().IsCorpseSpawned && this.getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable;
		};
		obj.getCorpseInBag <- function()
		{
			local actor = this.getContainer().getActor();
			local allItems = actor.getItems().getAllItems();
			local ret = [];

			foreach (item in allItems)
			{
				if (item.isItemType(this.Const.Items.ItemType.Corpse) && item.m.IsEdible)
				{
					ret.push(item);
				}
			}

			return ret;
		}
		obj.getTooltip = function()
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
					icon = "ui/icons/days_wounded.png",
					text = "Restores [color=" + this.Const.UI.Color.PositiveValue + "]50[/color] health points"
				},
				{
					id = 5,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Instantly heal all [color=" + this.Const.UI.Color.PositiveValue + "]Injuries[/color]"
				}
			];

			local corpses = this.getCorpseInBag();

			if (corpses.len() > 0)
			{
				ret.push({
					id = 4,
					type = "text",
					icon = "ui/icons/special.png",
					text = "You have [color=" + this.Const.UI.Color.PositiveValue + "]" + corpses.len() + "[/color] corpse(s) in your bag"
				});
			}
			
			return ret;
		};
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{	
			if (_targetTile.IsEmpty)
			{
				return false;
			}

			if (_targetTile.IsCorpseSpawned && _targetTile.Properties.get("Corpse").IsConsumable)
			{
				return true;
			}

			return this.getCorpseInBag().len() > 0;
		}
		obj.onUse = function( _user, _targetTile )
		{
			_targetTile = _user.getTile();

			if (_targetTile.IsVisibleForPlayer)
			{
				if (this.Const.Tactical.GruesomeFeastParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _targetTile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
						i = ++i;
					}
				}

				if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " feasts on a corpse");
				}
			}

			if (this.hasCorpseNearby())
			{
				if (!_user.isHiddenToPlayer())
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onRemoveCorpse, _targetTile);
				}
				else
				{
					this.onRemoveCorpse(_targetTile);
				}
			}
			else
			{
				this.getCorpseInBag()[0].removeSelf();
			}

			this.spawnBloodbath(_targetTile);
			_user.setHitpoints(this.Math.min(_user.getHitpoints() + 50, _user.getHitpointsMax()));
			local skills = _user.getSkills().getAllSkillsOfType(this.Const.SkillType.Injury);

			foreach( s in skills )
			{
				s.removeSelf();
				break;
			}

			local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}

				if (this.myTile.getDistanceTo(a.getTile()) > 4)
				{
					continue;
				}

				if (a.getFaction() != _user.getFaction())
				{
					continue;
				}

				if (!a.getFlags().has("human") || a.getMoraleState() == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (a.getFlags().has("Hexe"))
				{
					continue;
				}

				a.getSkills().add(this.new("scripts/skills/effects/legend_dazed_effect"));
				a.worsenMood(2.0, "Witnessed someone eat a corpse");
			}

			_user.onUpdateInjuryLayer();
			return true;
		};
	});


	// prevent tentacles to ensnare each others
	::mods_hookExactClass("skills/actives/kraken_ensnare_skill", function(obj) 
	{
		local ws_onVerifyTarget = obj.onVerifyTarget;
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!ws_onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			if (_targetTile.getEntity().getFlags().has("kraken_tentacle"))
			{
				return false;
			}

			return true;
		}
	});


	// beast skills (alp - unhold - ijirok - lindwurm - ghoul - serpent - )
	// alp
	::mods_hookExactClass("skills/actives/alp_teleport_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Fading out your physical body then reappearing at another place.";
			this.m.Icon = "skills/active_160.png";
			this.m.IconDisabled = "skills/active_160.png";
			this.m.Overlay = "active_160";
			this.m.SoundOnUse = [
				"sounds/enemies/ghost_death_01.wav",
				"sounds/enemies/ghost_death_02.wav"
			];
			this.m.SoundOnHit = [];
			this.m.IsSerialized = false;
			this.m.Type = this.Const.SkillType.Active;
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
			this.m.IsActive = true;
			this.m.IsHidden = true;
			this.m.IsTargeted = true;
			this.m.IsTargetingActor = false;
			this.m.IsVisibleTileNeeded = false;
			this.m.IsStacking = false;
			this.m.IsAttack = false;
			this.m.IsIgnoredAsAOO = true;
			this.m.ActionPointCost = 0;
			this.m.FatigueCost = 0;
			this.m.MinRange = 1;
			this.m.MaxRange = 99;
			this.m.MaxLevelDifference = 4;
		};
		obj.onAdded <- function()
		{
			local auto_button = this.new("scripts/skills/actives/mod_auto_mode_alp_teleport");
			this.getContainer().add(auto_button);

			if (!this.getContainer().getActor().isPlayerControlled())
			{
				auto_button.onCombatStarted();
			}

			this.getContainer().add(this.new("scripts/skills/actives/mod_alp_teleport_skill"));
		};
		obj.isUsable <- function()
		{
			return true;
		}
		obj.onUse = function( _user, _targetTile )
		{
			local tag = {
				Skill = this,
				User = _user,
				TargetTile = _targetTile,
				OnDone = this.onTeleportDone,
				OnFadeIn = this.onFadeIn,
				OnFadeDone = this.onFadeDone,
				OnTeleportStart = this.onTeleportStart,
				IgnoreColors = false
			};

			if (_user.getTile().IsVisibleForPlayer)
			{
				local specialEffect = _user.isPlayerControlled() ? "alp_effect_body_player" : "alp_effect_body";
				
				local effect = {
					Delay = 0,
					Quantity = 12,
					LifeTimeQuantity = 12,
					SpawnRate = 100,
					Brushes = [
						specialEffect
					],
					Stages = [
						{
							LifeTimeMin = 0.7,
							LifeTimeMax = 0.7,
							ColorMin = this.createColor("ffffff5f"),
							ColorMax = this.createColor("ffffff5f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, -1.0),
							DirectionMax = this.createVec(1.0, 1.0),
							SpawnOffsetMin = this.createVec(-10, -10),
							SpawnOffsetMax = this.createVec(10, 10),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.7,
							LifeTimeMax = 0.7,
							ColorMin = this.createColor("ffffff2f"),
							ColorMax = this.createColor("ffffff2f"),
							ScaleMin = 0.9,
							ScaleMax = 0.9,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, -1.0),
							DirectionMax = this.createVec(1.0, 1.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.1,
							ColorMin = this.createColor("ffffff00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 0.9,
							ScaleMax = 0.9,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, -1.0),
							DirectionMax = this.createVec(1.0, 1.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						}
					]
				};
				this.Tactical.spawnParticleEffect(false, effect.Brushes, _user.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
				_user.storeSpriteColors();
				_user.fadeTo(this.createColor("ffffff00"), 0);
				this.onTeleportStart(tag);
			}
			else if (_targetTile.IsVisibleForPlayer)
			{
				_user.storeSpriteColors();
				_user.fadeTo(this.createColor("ffffff00"), 0);
				this.onTeleportStart(tag);
			}
			else
			{
				tag.IgnoreColors = true;
				this.onTeleportStart(tag);
			}

			return true;
		};
		obj.onTeleportDone = function( _entity, _tag )
		{
			if (!_entity.isHiddenToPlayer())
			{
				local specialEffect = _entity.isPlayerControlled() ? "alp_effect_body_player" : "alp_effect_body";
				
				local effect1 = {
					Delay = 0,
					Quantity = 4,
					LifeTimeQuantity = 4,
					SpawnRate = 100,
					Brushes = [
						specialEffect
					],
					Stages = [
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff5f"),
							ColorMax = this.createColor("ffffff5f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(0.0, -1.0),
							DirectionMax = this.createVec(0.0, -1.0),
							SpawnOffsetMin = this.createVec(-10, 40),
							SpawnOffsetMax = this.createVec(10, 50),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff2f"),
							ColorMax = this.createColor("ffffff2f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(0.0, -1.0),
							DirectionMax = this.createVec(0.0, -1.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.1,
							ColorMin = this.createColor("ffffff00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(0.0, -1.0),
							DirectionMax = this.createVec(0.0, -1.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						}
					]
				};
				local effect2 = {
					Delay = 0,
					Quantity = 4,
					LifeTimeQuantity = 4,
					SpawnRate = 100,
					Brushes = [
						specialEffect
					],
					Stages = [
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff5f"),
							ColorMax = this.createColor("ffffff5f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(1.0, 0.0),
							DirectionMax = this.createVec(1.0, 0.0),
							SpawnOffsetMin = this.createVec(-40, -10),
							SpawnOffsetMax = this.createVec(-50, 10),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff2f"),
							ColorMax = this.createColor("ffffff2f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(1.0, 0.0),
							DirectionMax = this.createVec(1.0, 0.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.1,
							ColorMin = this.createColor("ffffff00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(1.0, 0.0),
							DirectionMax = this.createVec(1.0, 0.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						}
					]
				};
				local effect3 = {
					Delay = 0,
					Quantity = 4,
					LifeTimeQuantity = 4,
					SpawnRate = 100,
					Brushes = [
						specialEffect
					],
					Stages = [
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff5f"),
							ColorMax = this.createColor("ffffff5f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, 0.0),
							DirectionMax = this.createVec(-1.0, 0.0),
							SpawnOffsetMin = this.createVec(40, 10),
							SpawnOffsetMax = this.createVec(50, 10),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.4,
							LifeTimeMax = 0.4,
							ColorMin = this.createColor("ffffff2f"),
							ColorMax = this.createColor("ffffff2f"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, 0.0),
							DirectionMax = this.createVec(-1.0, 0.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						},
						{
							LifeTimeMin = 0.1,
							LifeTimeMax = 0.1,
							ColorMin = this.createColor("ffffff00"),
							ColorMax = this.createColor("ffffff00"),
							ScaleMin = 1.0,
							ScaleMax = 1.0,
							RotationMin = 0,
							RotationMax = 0,
							VelocityMin = 80,
							VelocityMax = 100,
							DirectionMin = this.createVec(-1.0, 0.0),
							DirectionMax = this.createVec(-1.0, 0.0),
							ForceMin = this.createVec(0, 0),
							ForceMax = this.createVec(0, 0)
						}
					]
				};
				this.Tactical.spawnParticleEffect(false, effect1.Brushes, _entity.getTile(), effect1.Delay, effect1.Quantity, effect1.LifeTimeQuantity, effect1.SpawnRate, effect1.Stages, this.createVec(0, 40));
				this.Tactical.spawnParticleEffect(false, effect2.Brushes, _entity.getTile(), effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, this.createVec(0, 40));
				this.Tactical.spawnParticleEffect(false, effect3.Brushes, _entity.getTile(), effect3.Delay, effect3.Quantity, effect3.LifeTimeQuantity, effect3.SpawnRate, effect3.Stages, this.createVec(0, 40));
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, _tag.OnFadeIn, _tag);
			}
			else
			{
				_tag.OnFadeIn(_tag);
			}

			if (_entity.getSkills().hasSkill("perk.afterimage"))
			{
				_entity.getSkills().add(this.new("scripts/skills/effects/afterimage_effect"));
			}
		}
	});
	
	
	// alp
	::mods_hookExactClass("skills/actives/sleep_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IconDisabled = "skills/active_116_sw.png";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
			this.m.IsVisibleTileNeeded = true;
		};
		obj.getFatigueCost <- function()
		{
			local ret = this.skill.getFatigueCost();

			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return ret;
			}

			return ret * 2;
		};
		obj.getTooltip <- function()
		{
			local ret = this.skill.getDefaultUtilityTooltip();
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			});
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Puts target to [color=" + this.Const.UI.Color.PositiveValue + "]Sleep[/color]"
			});

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			if (this.getContainer().hasSkill("perk.mastery_sleep"))
			{
				this.m.ActionPointCost -= 1;
			}
		};
		obj.isViableTarget <- function( _user, _target )
		{
			if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
			{
				return false;
			}

			if (_target.getFlags().has("alp"))
			{
				return false;
			}

			local invalid = [
				this.Const.EntityType.Alp,
				this.Const.EntityType.AlpShadow,
				this.Const.EntityType.LegendDemonAlp,
			];

			return invalid.find(_target.getType()) == null;
		};
		obj.onDelayedEffect = function( _tag )
		{
			local targets = [];
			local _targetTile = _tag.TargetTile;
			local _user = _tag.User;

			if (_targetTile.IsOccupiedByActor)
			{
				local entity = _targetTile.getEntity();
				targets.push(entity);
			}

			local myTile = _user.getTile();
			local hasMastery = this.getContainer().hasSkill("perk.mastery_sleep");

			foreach( target in targets )
			{
				local chance = this.getHitchance(target);
				local attempts = target.getFlags().getAsInt("resist_sleep");
				local bonus = (this.m.MaxRange + 1 - myTile.getDistanceTo(target.getTile())) * (1.0 + 0.1 * attempts);
				local difficulty = 0;
				difficulty -= 35 * bonus + (hasMastery ? this.Math.max(1, this.Math.floor(_user.getBravery() * 0.1)) : 0);

				if (_user.isPlayerControlled())
				{
					difficulty += 25;
				}

				if (!this.isViableTarget(_user, target) || target.checkMorale(0, difficulty, this.Const.MoraleCheckType.MentalAttack))
				{
					if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists the urge to sleep thanks to his resolve (Chance: " + chance + ", Rolled: " + this.Math.rand(chance + 1, 100) + ")");
					}
					
					target.getFlags().increment("resist_sleep");
					continue;
				}

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " falls to sleep (Chance: " + chance + ", Rolled: " + this.Math.rand(1, chance) + ")");
				}

				local sleep = this.new("scripts/skills/effects/sleeping_effect");
				target.getFlags().set("resist_sleep", 0);
				target.getSkills().add(sleep);
				sleep.m.TurnsLeft += hasMastery ? 1 : 0;
			}
		};
		obj.getHitchance <- function( _targetEntity )
		{
			if (_targetEntity.getMoraleState() == this.Const.MoraleState.Ignore)
			{
				return 100;
			}

			local _user = this.getContainer().getActor();

			if (!this.isViableTarget(_user, _targetEntity))
			{
				return 0;
			}

			local _targetTile = _targetEntity.getTile();
			local _distance = _user.getTile().getDistanceTo(_targetTile);
			local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);

			local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack];
			local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
			local bonus = (this.m.MaxRange + 1 - _distance) * (1.0 + 0.1 * attempts);
			local _difficulty = 0;
			_difficulty -= 35 * bonus + (this.getContainer().hasSkill("perk.mastery_sleep") ? this.Math.max(1, this.Math.floor(properties.getBravery() * 0.1)) : 0);
			
			if (_user.isPlayerControlled())
			{
				_difficulty += 25;
			}

			_difficulty *= defenderProperties.MoraleEffectMult;

			if (bravery > 500)
			{
				return 0;
			}

			local numOpponentsAdjacent = 0;
			local numAlliesAdjacent = 0;
			local threatBonus = 0;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);

					if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
					{
						if (tile.getEntity().isAlliedWith(_targetEntity))
						{
							numOpponentsAdjacent = ++numOpponentsAdjacent;
						}
						else
						{
							numAlliesAdjacent = ++numAlliesAdjacent;
							threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
						}
					}
				}
			}

			local chance = bravery + _difficulty;
			chance -= threatBonus + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult;
			chance += numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult;
			chance = this.Math.min(95, this.Math.floor(chance));

			if (chance <= 0)
			{
				return 100;
			}

			return 100 - chance;
		};
		obj.getHitFactors <- function( _targetTile )
		{
			local ret = [];
			local user = this.getContainer().getActor();
			local myTile = user.getTile();
			local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
			
			if (targetEntity == null)
			{
				return ret;
			}
			
			local _targetEntity = targetEntity;
			local _user = this.getContainer().getActor();
			local myTile = this.getContainer().getActor().getTile();
			local isSpecialized = this.getContainer().hasSkill("perk.mastery_sleep");
			local _distance = myTile.getDistanceTo(_targetTile);

			local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
			local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack];

			if (defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0 || bravery >= 500)
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Extremely high magic resistance"
				});
				
				return ret;
			}

			if (targetEntity.isNonCombatant())
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Why?"
				});
				
				return ret;
			}
			
			if (!this.isViableTarget(_user, _targetEntity))
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Immune to sleep"
				});
				
				return ret;
			}

			if (targetEntity.getCurrentProperties().IsStunned)
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Can\'t put to sleep right now"
				});
				
				return ret;
			}
			
			if (targetEntity.isAlliedWith(this.getContainer().getActor()))
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Allied"
				});
				
				return ret;
			}
			
			if (targetEntity.getMoraleState() == this.Const.MoraleState.Ignore)
			{
				ret.push({
					icon = "ui/icons/cancel.png",
					text = "Immune to sleep"
				});
				
				return ret;
			}

			ret.extend([
				{
					icon = "ui/icons/bravery.png",
					text = "Target\'s resolve: [color=#0b0084]" + bravery + "[/color]"
				},
				{
					icon = "ui/tooltips/positive.png",
					text = "Default bonus: [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color]"
				}
			]);

			local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
			local _difficulty = 10;

			if (_distance != this.m.MaxRange)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Too close: [color=" + this.Const.UI.Color.NegativeValue + "]" + _difficulty + "%[/color]"
				});
				_difficulty -= 10;
			}

			if (attempts != 0)
			{
				local add = this.Math.floor(_difficulty * attempts * 0.1);
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Fail attempts: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
				});
				_difficulty += add;
			}

			if (isSpecialized)
			{
				local add = this.Math.floor(this.Math.max(1, properties.getBravery() * 0.1));
				ret.insert(0, 
				{
					icon = "ui/icons/bravery.png",
					text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
				});
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Overslept perk: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
				});
				_difficulty += add;
			}

			if (defenderProperties.MoraleEffectMult > 1.0)
			{
				local add = this.Math.floor(_difficulty * (defenderProperties.MoraleEffectMult - 1.0));
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Sensitive: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
				});
			}
			else if (defenderProperties.MoraleEffectMult < 1.0 && defenderProperties.MoraleEffectMult > 0)
			{
				local add = this.Math.floor(_difficulty * (1.0 - defenderProperties.MoraleEffectMult));
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Insensitive: [color=" + this.Const.UI.Color.NegativeValue + "]" + add + "%[/color]"
				});
			}

			local numOpponentsAdjacent = 0;
			local numAlliesAdjacent = 0;
			local threatBonus = 0;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);

					if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
					{
						if (tile.getEntity().isAlliedWith(_user))
						{
							numAlliesAdjacent = ++numAlliesAdjacent;
							threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
						}
						else
						{
							numOpponentsAdjacent = ++numOpponentsAdjacent;
							
						}
					}
				}
			}

			if (threatBonus != 0)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Intimidated: [color=" + this.Const.UI.Color.PositiveValue + "]" + threatBonus + "%[/color]"
				});
			}
				
			local modAllies = numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult;

			if (modAllies != 0)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Surrounded: [color=" + this.Const.UI.Color.PositiveValue + "]" + modAllies + "%[/color]"
				});
			}

			local modEnemies = numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult;

			if (modEnemies != 0)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Allies nearby: [color=" + this.Const.UI.Color.NegativeValue + "]" + modEnemies + "%[/color]"
				});
			}

			return ret;
		};
	});
	

	// alp
	::mods_hookExactClass("skills/actives/nightmare_skill", function ( obj )
	{
		obj.m.ConvertRate <- 0.15;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
			this.m.Icon = "skills/active_117.png";
			this.m.IconDisabled = "skills/active_117_sw.png";
			this.m.Overlay = "active_117";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
			this.m.DirectDamageMult = 1.0;
			this.m.ActionPointCost = 4;
			this.m.FatigueCost = 10;
			this.m.MinRange = 1;
			this.m.MaxRange = 2;
			this.m.MaxLevelDifference = 4;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "Damage is increased equal to [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ConvertRate * 100 + "%[/color] of yourself current Resolve"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Damage is reduced by target\'s [color=" + this.Const.UI.Color.NegativeValue + "]Resolve[/color]"
				}
			]);
			
			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			local isSpecialized = this.getContainer().hasSkill("perk.mastery_nightmare");
			this.m.FatigueCostMult = isSpecialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
			this.m.ConvertRate = isSpecialized ? 0.3 : 0.15;
		};
		obj.getDamage = function( _actor , _properties = null )
		{
			if (_properties == null)
			{
				_properties = _actor.getCurrentProperties();
			}

			local mult = this.getContainer().hasSkill("perk.after_wake") ? this.Math.rand(85, 95) * 0.01 : 1.0;
			return this.Math.max(5, 25 - this.Math.floor(_properties.getBravery() * mult * 0.25));
		};	
		obj.getAdditionalDamage <- function( _properties = null )
		{
			if (_properties == null)
			{
				_properties = this.getContainer().getActor().getCurrentProperties();
			}
			
			return this.Math.floor((_properties.getBravery() + _properties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * this.m.ConvertRate);
		};

		local ws_isUsable = obj.isUsable;
		obj.isUsable = function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				return this.skill.isUsable();
			}

			return ws_isUsable();
		};
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}
			
			return _targetTile.getEntity().getSkills().getSkillByID("effects.sleeping") != null;
		};
		obj.onDelayedEffect = function( _tag )
		{
			local targetTile = _tag.TargetTile;
			local user = _tag.User;
			local target = targetTile.getEntity();
			local properties = this.getContainer().buildPropertiesForUse(this, target);
			local defenderProperties = target.getSkills().buildPropertiesForDefense(user, this);

			local damage = this.getDamage(target, defenderProperties);
			local bonus_damage = this.getAdditionalDamage(properties);

			if (this.isKindOf(target, "player") && bonus_damage > 0)
			{
				bonus_damage = this.Math.max(1, bonus_damage - this.Math.floor(defenderProperties.getBravery() * 0.25));
			}

			local total_damage = this.Math.rand(damage + bonus_damage, damage + bonus_damage + 5) * properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = total_damage;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().onBeforeTargetHit(this, target, hitInfo);
			target.onDamageReceived(user, this, hitInfo);
			this.getContainer().onTargetHit(this, target, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				_properties.DamageRegularMin = 25 + this.getAdditionalDamage(_properties);
				_properties.DamageRegularMax = 30 + this.getAdditionalDamage(_properties);
				_properties.DamageArmorMult = 0;
				_properties.IsIgnoringArmorOnAttack = true;
				_properties.MeleeDamageMult = 1.0;
			}
		}
		obj.getHitFactors <- function( _targetTile )
		{
			local ret = [];
			local user = this.getContainer().getActor();
			local myTile = user.getTile();
			local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
			
			if (targetEntity == null)
			{
				return ret;
			}

			local _targetEntity = targetEntity;
			local _user = this.getContainer().getActor();
			local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
			local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
			local damMod = properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
			local defMod = defenderProperties.DamageReceivedTotalMult * defenderProperties.DamageReceivedDirectMult;

			local expectedDamage = this.getDamage(_targetEntity, defenderProperties);
			local bonusDamage = this.getAdditionalDamage(properties);
			local lossDamage = 25 - expectedDamage;
			local totaldamage = this.Math.floor((expectedDamage + bonusDamage) * damMod * defMod);
			local totaldamageMax = this.Math.floor((expectedDamage + bonusDamage + 5) * damMod * defMod);

			ret.extend([
				{
					icon = "ui/icons/bravery.png",
					text = "Target\'s resolve: [color=#0b0084]" + defenderProperties.getBravery() + "[/color]"
				},
				{
					icon = "ui/icons/regular_damage.png",
					text = "Total damage: [color=" + this.Const.UI.Color.DamageValue + "]" + totaldamage + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + totaldamageMax + "[/color]" 
				},
			]);

			if (bonusDamage != 0)
			{
				ret.insert(0, {
					icon = "ui/icons/bravery.png",
					text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
				});
				ret.push({
					icon = "ui/icons/days_wounded.png",
					text = "HP heals: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(totaldamage * 0.25) + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(totaldamageMax * 0.33) + "[/color]"
				});
			}

			return ret;

			ret.push({
				icon = "ui/icons/special.png",
				text = "[color=#0b0084]Damage modidiers[/color]:"
			});

			if (damMod > 1.0)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "From yourself: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(damMod * 100) + "%[/color]"
				});
			}
			else if (damMod > 0 && this.Math.floor(damMod * 100) != 100)
			{
			    ret.push({
					icon = "ui/tooltips/negative.png",
					text = "From yourself: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(damMod * 100) + "%[/color]"
				});
			}

			if (defMod > 1.0)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "From target: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(defMod * 100) + "%[/color]"
				});
			}
			else if (defMod > 0 && this.Math.floor(defMod * 100) != 100)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "From target: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(defMod * 100) + "%[/color]"
				});
			}

			local a = this.Math.floor(damMod * defMod * 100 - 100);

			if (a > 0)
			{
				ret.push({
					icon = "ui/icons/mood_06.png",
					text = "Sum up: [color=" + this.Const.UI.Color.PositiveValue + "]" + a + "%[/color] more damage"
				});
			}
			else if (a == 0)
			{
				ret.push({
					icon = "ui/icons/mood_04.png",
					text = "Sum up: Unchanged"
				});
			}
			else 
			{
			    ret.push({
					icon = "ui/icons/mood_02.png",
					text = "Sum up: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.abs(a) + "%[/color] less damage"
				});
			}
		}
	});


	// demon alp
	::mods_hookExactClass("skills/actives/legend_demon_shadows_skill", function(obj) 
	{
		obj.m.Tiles <- [];

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Summon the hellfire to bring out the agony pain from your foe, fueling the juicy nightmare to the inferno.";
			this.m.Icon = "skills/active_alp_hellfire.png";
			this.m.IconDisabled = "skills/active_alp_hellfire_sw.png";
			this.m.Overlay = "active_alp_hellfire";
			this.m.Order = this.Const.SkillOrder.UtilityTargeted - 1;
			this.m.IsAttack = true;
			this.m.IsRanged = true;
			this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
			this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
			this.m.DirectDamageMult = 0.35;
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.FatigueCost = 13;
				this.m.MaxRange = 8;
				this.m.IsVisibleTileNeeded = true;
			}
		};
		obj.hasTile <- function( _id )
		{
			foreach (i, t in this.m.Tiles) 
			{
			    if (t.ID == _id)
			    {
			    	return true;
			    }
			}

			return false;
		};
		obj.updateTiles <- function()
		{
			local new = [];

			foreach ( t in this.m.Tiles )
			{
				if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
				{
					new.push(t);
				}
			}

			this.m.Tiles = new;
		};
		obj.removeAllTiles <- function()
		{
			foreach ( t in this.m.Tiles )
			{
				if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
				{
					this.Tactical.Entities.removeTileEffect(t);
				}
			}
		};
		obj.onUpdate <- function( _properties )
		{
			_properties.InitiativeForTurnOrderAdditional += 999;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			local specialized = this.getContainer().hasSkill("perk.control_flame");
			this.m.FatigueCostMult = specialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Brings hellfire to the earth"
			});
			return ret;
		};
		obj.onTurnStart <- function()
		{
			this.updateTiles();
		};
		obj.onResumeTurn <- function()
		{
			this.updateTiles();
		};
		obj.onDeath <- function()
		{
			this.removeAllTiles();
		};
		obj.onUse = function( _user, _targetTile )
		{
			local targets = [];
			local self = this;
			local applyFire = self.onApplyFirefield;
			local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
			local specialized_2 = this.getContainer().hasSkill("perk.control_flame");
			local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
			local time = specialized_3 ? 2 : 4;
			targets.push(_targetTile);

			for( local i = 0; i != 6; i = i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);
					targets.push(tile);
				}

				i = ++i;
			}

			local custom = {
				Specialized_1 = specialized_1,
				Specialized_2 = specialized_2,
				Specialized_3 = specialized_3,
				UserID = _user.getID(),
			};
			local p = {
				Type = "alp_hellfire",
				Tooltip = "The inferno of nightmare, burns everything dare to go near it. Created by " + _user.getName(),
				IsAppliedAtRoundStart = false,
				IsAppliedAtTurnEnd = true,
				IsAppliedOnMovement = true,
				IsAppliedOnEnter = false,
				IsPositive = false,
				Timeout = this.Time.getRound() + time,
				IsByPlayer = _user.isPlayerControlled(),
				Callback = applyFire,
				Custom = custom,
				function Applicable( _a )
				{
					return _a;
				}
			};

			foreach( tile in targets )
			{
				if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "alp_hellfire")
				{
					tile.Properties.Effect = clone p;
					tile.Properties.Effect.Timeout = this.Time.getRound() + (time * 0.5);
				}
				else
				{
					if (tile.Properties.Effect != null)
					{
						this.Tactical.Entities.removeTileEffect(tile);
					}

					tile.Properties.Effect = clone p;
					local particles = [];

					for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = i )
					{
						particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, tile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
						i = ++i;
					}
					
					this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
				}

				if (!this.hasTile(tile.ID))
				{
					this.m.Tiles.push(tile);
				}

				if (specialized_1 && tile.IsOccupiedByActor)
				{
					this.onApplyFirefield(tile, tile.getEntity());
				}
			}

			return true;
		};
		obj.onApplyFirefield <- function( _tile, _entity )
		{
			local data = _tile.Properties.Effect;
			local custom = data.Custom;
			local damage = this.Math.rand(15, 20);
			local damageMult = 1.0;
			local injuries = null;
			local attacker = this.Tactical.getEntityByID(custom.UserID);

			if (attacker == null || !attacker.isAlive() || attacker.isDying())
			{
				attacker = null;
			}

			if (custom.Specialized_2 && _entity.getID() == custom.UserID)
			{
				return;
			}

			if (custom.Specialized_1)
			{
				damage += this.Math.rand(5, 12);
			}

			if (custom.Specialized_3)
			{
				damage += this.Math.rand(5, 20);
				injuries = this.Const.Injury.Burning;
			}

			if (_entity.getCurrentProperties().IsImmuneToFire)
			{
				damageMult *= 0.33;
			}

			if (_entity.getSkills().hasSkill("items.firearms_resistance"))
			{
				damageMult *= 0.67;
			}

			if (_entity.getSkills().hasSkill("racial.serpent"))
			{
				damageMult *= 0.67;
			}

			local types = [
				this.Const.EntityType.Schrat,
				this.Const.EntityType.SchratSmall,
				this.Const.EntityType.LegendGreenwoodSchrat,
				this.Const.EntityType.LegendGreenwoodSchratSmall,
			];

			if (types.find(_entity.getType()) != null || _entity.getFlags().has("isSmallSchrat") || _entity.getFlags().has("isSchrat"))
			{
				damageMult *= 2.0;
			}

			this.Tactical.spawnIconEffect("fire_circle", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			local sounds = [
				"sounds/combat/fire_01.wav",
				"sounds/combat/fire_02.wav",
				"sounds/combat/fire_03.wav",
				"sounds/combat/fire_04.wav",
				"sounds/combat/fire_05.wav",
				"sounds/combat/fire_06.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = damage * damageMult;
			hitInfo.DamageArmor = hitInfo.DamageRegular * 1.25;
			hitInfo.DamageDirect = 0.35;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			hitInfo.Injuries = injuries;
			hitInfo.InjuryThresholdMult = 1.15;
			hitInfo.IsPlayingArmorSound = false;
			_entity.onDamageReceived(attacker, null, hitInfo);
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
				local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
				_properties.DamageRegularMin = 15;
				_properties.DamageRegularMax = 20;
				_properties.DamageArmorMult = 1.25;
				_properties.RangedDamageMult /= 0.9;

				if (specialized_1)
				{
					_properties.DamageRegularMin += 5;
					_properties.DamageRegularMax += 12;
				}

				if (specialized_3)
				{
					_properties.DamageRegularMin += 5;
					_properties.DamageRegularMax += 20;
				}
			}
		};
		obj.onCombatStarted <- function()
		{
			this.m.Tiles = [];
		};
		obj.onCombatFinished <- function()
		{
			this.m.Tiles = [];
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);	

			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _targetTile.getNextTile(i);
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
				}
			}
		};
	});


	// white wolf
	::mods_hookExactClass("skills/actives/legend_white_wolf_howl", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A fearsome howl that boosts the fighting spirit of its herd members.";
			this.m.Icon = "skills/active_22.png";
			this.m.IconDisabled = "skills/active_22_sw.png";
		};
		obj.getTooltip = function()
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
				{
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has an effective range of [color=" + this.Const.UI.Color.PositiveValue + "]6[/color] tiles raidus"
				}
			];
		};
		obj.raiseMorale = function( _actor, _tag )
		{
			_actor.checkMorale(1, 0);
			_tag.Skill.spawnIcon("status_effect_06", _actor.getTile());
		};
		obj.onUse = function( _user, _targetTile )
		{
			local result = {
				Self = _user,
				Skill = this
			};
			
			local myTile = _user.getTile();
			local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

			foreach( a in actors )
			{
				if (a.getID() == _user.getID())
				{
					continue;
				}

				if (a.getFaction() != _user.getFaction())
				{
					continue;
				}

				if (myTile.getDistanceTo(a.getTile()) > 6)
				{
					continue;
				}
				
				a.getSkills().removeByID("effects.sleeping");
				this.raiseMorale(a, result);
			}
			return true;
		};
	});
	
	
	// unhold
	::mods_hookExactClass("skills/actives/fling_back_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Grab a target and throw to a side in order to move forward, deal fall damage to said target.";
			this.m.Icon = "skills/active_111.png";
			this.m.IconDisabled = "skills/active_111_sw.png";
			this.m.Delay = 250;
			this.m.IsAttack = false;
			this.m.IsIgnoringRiposte = true;
			this.m.IsSpearwallRelevant = false;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultUtilityTooltip();
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]Throws[/color] away an enemy and [color=" + this.Const.UI.Color.PositiveValue + "]Steps Forward[/color]"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Deal [color=" + this.Const.UI.Color.NegativeValue + "]Fall Damage[/color] depending on the [color=" + this.Const.UI.Color.NegativeValue + "]Height[/color]"
				}
			]);

			if (this.isUpgraded())
			{
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] chance to daze"
				});
			}
			
			return ret;
		};
		obj.isUpgraded <- function()
		{
			return this.getContainer().hasSkill("perk.unhold_fling");
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;

			if (_properties.IsSpecializedInThrowing)
			{
				this.m.ActionPointCost -= 1;
			}
		};
		obj.onKnockedDown = function( _entity, _tag )
		{
			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
			}

			if (_tag.HitInfo.DamageRegular != 0)
			{
				local isSpecialized = _tag.Skill.isUpgraded();

				if (isSpecialized)
				{
					_tag.HitInfo.DamageRegular *= 2;
				}

				_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
				
				if (typeof _tag.Attacker == "instance" && _tag.Attacker.isNull() || !_tag.Attacker.isAlive() || _tag.Attacker.isDying())
				{
					return;
				}
				
				_tag.Container.onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageRegular, 0);
			}

			if (isSpecialized && _entity.isAlive() && !_entity.isDying() && !_entity.getCurrentProperties().IsImmuneToStun)
			{
				_entity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.Attacker) + " has stunned " + this.Const.UI.getColorizedEntityName(_entity) + " for one turn");
			}
		};
	});


	// unhold
	::mods_hookExactClass("skills/actives/unstoppable_charge_skill", function ( obj )
	{
		obj.m.rawdelete("IsSpent");

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Charge forward with unbeleivable speed and ram at enemy formation. Can knock back or stun when charging at enemy formation. Can not be used in melee.";
			this.m.Icon = "skills/active_110.png";
			this.m.IconDisabled = "skills/active_110_sw.png";
		};
		obj.getTooltip = function()
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
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can cause [color=" + this.Const.UI.Color.PositiveValue + "]Stun[/color] or [color=" + this.Const.UI.Color.PositiveValue + "]Knock Back[/color]"
				}
			];
			
			if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this unhold is engaged in melee[/color]"
				});
			}
			
			return ret;
		};
		obj.isUsable = function()
		{
			return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
		};
		obj.onTurnStart = function() {};
		obj.onUse = function( _user, _targetTile )
		{
			this.m.TilesUsed = [];
			local tag = {
				Skill = this,
				User = _user,
				OldTile = _user.getTile(),
				TargetTile = _targetTile
			};

			if (tag.OldTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
			{
				local myPos = _user.getPos();
				local targetPos = _targetTile.Pos;
				local distance = tag.OldTile.getDistanceTo(_targetTile);
				local Dx = (targetPos.X - myPos.X) / distance;
				local Dy = (targetPos.Y - myPos.Y) / distance;

				for( local i = 0; i < distance; i = ++i )
				{
					local x = myPos.X + Dx * i;
					local y = myPos.Y + Dy * i;
					local tile = this.Tactical.worldToTile(this.createVec(x, y));

					if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
					{
						for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
						}
					}
				}
			}

			this.Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone, tag, false, 2.5);
			return true;
		};
	});


	// unhold
	::mods_hookExactClass("skills/actives/sweep_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Swing your mighty hand to the side, dealing damage to mutiple targets who are unlucky enough to get hit. May cause knock back.";
			this.m.Icon = "skills/active_112.png";
			this.m.IconDisabled = "skills/active_112_sw.png";
			this.m.Overlay = "active_112";
		};
		obj.getTooltip = function()
		{
			local ret = this.getDefaultTooltip();
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 3 targets and never hit allies"
			});

			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Can cause [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] on hit"
			});

			return ret;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = this.getContainer().getActor().getTile();
			local dir = ownTile.getDirectionTo(_targetTile);
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			local nextDir = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);

				if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
				}
			}

			nextDir = nextDir - 1 >= 0 ? nextDir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);

				if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
				}
			}
		};

		local ws_onUpdate = obj.onUpdate;
		obj.onUpdate = function( _properties )
		{
			ws_onUpdate(_properties);

			if (this.getContainer().getActor().isPlayerControlled())
			{
				_properties.DamageRegularMax -= 10;
			}
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInFists ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.getMods <- function()
		{
			local ret = {
				Min = 0,
				Max = 0,
				HasTraining = false
			};
			local actor = this.getContainer().getActor();

			if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
			{
				local average = actor.getHitpoints() * 0.05;

				ret.Min += average;
				ret.Max += average;
				ret.HasTraining = true;
			}

			ret.Min = this.Math.max(0, this.Math.floor(ret.Min));
			ret.Max = this.Math.max(0, this.Math.floor(ret.Max));
			return ret;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill != this)
			{
				return;
			}

			local mods = this.getMods();
			_properties.DamageRegularMin += mods.Min;
			_properties.DamageRegularMax += mods.Max;

			if (mods.HasTraining)
			{
				_properties.DamageArmorMult += 0.1;
			}
		};
	});


	// unhold
	::mods_hookExactClass("skills/actives/sweep_zoc_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsHidden = true;
		};
		obj.isUsable <- function()
		{
			return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
		};
		obj.getMods <- function()
		{
			local ret = {
				Min = 0,
				Max = 0,
				HasTraining = false
			};
			local actor = this.getContainer().getActor();

			if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
			{
				local average = actor.getHitpoints() * 0.05;

				ret.Min += average;
				ret.Max += average;
				ret.HasTraining = true;
			}

			ret.Min = this.Math.max(0, this.Math.floor(ret.Min));
			ret.Max = this.Math.max(0, this.Math.floor(ret.Max));
			return ret;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill != this)
			{
				return;
			}

			local mods = this.getMods();
			_properties.DamageRegularMin += mods.Min;
			_properties.DamageRegularMax += mods.Max;

			if (mods.HasTraining)
			{
				_properties.DamageArmorMult += 0.1;
			}
		};
	});


	// ghoul
	::mods_hookExactClass("skills/actives/", function ( obj )
	{
		obj.getTooltip = function()
		{
			return this.getDefaultTooltip();
		};
		obj.onBeforeUse <- function( _user , _targetTile )
		{
			if (!_user.getFlags().has("luft"))
			{
				return;
			}
			
			this.Tactical.spawnSpriteEffect("luft_claw_quote_" + this.Math.rand(1, 5), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
	});


	// ghoul
	::mods_hookExactClass("skills/actives/gruesome_feast", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Time to eat, you can\'t grow up if you can\'t get enough nutrition from corpses.";
			this.m.Icon = "skills/active_40.png";
			this.m.IconDisabled = "skills/active_40_sw.png";
		};
		obj.getTooltip = function()
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
					icon = "ui/icons/days_wounded.png",
					text = "Restores [color=" + this.Const.UI.Color.PositiveValue + "]100[/color] health points"
				},
				{
					id = 5,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Instantly heal a random [color=" + this.Const.UI.Color.PositiveValue + "]Injury[/color]"
				}
			];

			local corpses = this.getCorpseInBag();

			if (corpses.len() > 0)
			{
				ret.push({
					id = 4,
					type = "text",
					icon = "ui/icons/special.png",
					text = "You have [color=" + this.Const.UI.Color.PositiveValue + "]" + corpses.len() + "[/color] corpse(s) in your bag"
				});
			}
			
			if (this.getContainer().hasSkill("effects.swallowed_whole"))
			{
				ret.push({
					id = 4,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]So full right now, can not eat any more corpse[/color]"
				});
			}
			
			return ret;
		};
		obj.hasCorpseNearby <- function()
		{
			return this.getContainer().getActor().getTile().IsCorpseSpawned && this.getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable;
		};
		obj.getCorpseInBag <- function()
		{
			local actor = this.getContainer().getActor();
			local allItems = actor.getItems().getAllItems();
			local ret = [];

			foreach (item in allItems)
			{
				if (item.isItemType(this.Const.Items.ItemType.Corpse) && item.m.IsEdible)
				{
					ret.push(item);
				}
			}

			return ret;
		}
		obj.isUsable <- function()
		{
			if (!this.skill.isUsable())
			{
				return false;
			}

			if (!this.getContainer().getActor().isPlayerControlled())
			{
				return true;
			}

			if (!this.getContainer().hasSkill("effects.swallowed_whole"))
			{
				return false;
			}

			if (this.hasCorpseNearby())
			{
				return true;
			}
			
			return this.getCorpseInBag().len() > 0;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
		local ws_onFeasted = obj.onFeasted;
		obj.onFeasted = function( _effect )
		{
			local actor = _effect.getContainer().getActor();

			if (actor.isPlayerControlled())
			{
				_effect.addFeastStack();
				_effect.getContainer().update();
				actor.setHitpoints(this.Math.min(actor.getHitpoints() + 100, actor.getHitpointsMax()));
				local skills = _effect.getContainer().getAllSkillsOfType(this.Const.SkillType.Injury);

				if (skills.len() > 0)
				{
					skills[0].removeSelf();
				}

				actor.onUpdateInjuryLayer();
			}
			else
			{
				ws_onFeasted(_effect);
			}

			if (_effect.getContainer().hasSkill("perk.nacho_eat"))
			{
				_effect.getContainer().add(this.new("scripts/skills/effects/nacho_eat_effect"));
			}
		};
		obj.onBeforeUse <- function( _user , _targetTile )
		{
			if (!_user.getFlags().has("luft"))
			{
				return;
			}
			
			this.Tactical.spawnSpriteEffect("luft_eat_quote_" + this.Math.rand(1, 3), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		};
		obj.onUse = function( _user, _targetTile )
		{
			_targetTile = _user.getTile();

			if (_targetTile.IsVisibleForPlayer)
			{
				if (this.Const.Tactical.GruesomeFeastParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _targetTile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
					}
				}

				if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " feasts on a corpse");
				}
			}

			if (this.hasCorpseNearby())
			{
				if (!_user.isHiddenToPlayer())
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onRemoveCorpse, _targetTile);
				}
				else
				{
					this.onRemoveCorpse(_targetTile);
				}
			}
			else
			{
				this.getCorpseInBag()[0].removeSelf();
			}

			this.spawnBloodbath(_targetTile);
			local effect = _user.getSkills().getSkillByID("effects.gruesome_feast");
			
			if (effect == null)
			{
				effect = this.new("scripts/skills/effects/gruesome_feast_effect");
				this.getContainer().add(effect);
			}

			if (_user.getFlags().has("hunger"))
			{
				local count = this.Math.min(2, _user.getFlags().getAsInt("hunger") + 1);
				_user.getFlags().set("hunger", count);
			}
			else 
			{
			    _user.getFlags().set("hunger", 2);
			}

			if (!_user.isHiddenToPlayer())
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onFeasted, effect);
			}
			else
			{
				this.onFeasted(effect);
			}

			return true;
		}
	});
	

	// ghoul
	::mods_hookExactClass("skills/actives/legend_skin_ghoul_claws", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 3;
			this.m.IsIgnoredAsAOO = true;
		};
		obj.isHidden <- function()
		{
			return this.getContainer().getActor().getMainhandItem() != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
		};
		obj.onAdded <- function()
		{
			this.getContainer().add(this.new("scripts/skills/actives/ghoul_claws_zoc"));
		};
		obj.getTooltip = function()
		{
			local ret = this.getDefaultTooltip();
			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 3 targets"
				}
			]);
			return ret;
		};

		local ws_onUpdate = obj.onUpdate;
		obj.onUpdate = function( _properties )
		{
			if (!this.isHidden())
			{
				ws_onUpdate(_properties);
			}
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onBeforeUse <- function( _user , _targetTile )
		{
			if (!_user.getFlags().has("luft"))
			{
				return;
			}
			
			this.Tactical.spawnSpriteEffect("luft_claw_quote_" + this.Math.rand(1, 5), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
		};
	});


	// ghoul
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
					text = "Can be used to [color=" + this.Const.UI.Color.PositiveValue + "]Swallow[/color] an unlucky target"
				},
				{
					id = 5,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not swallow something bigger than you[/color]"
				}
			];

			if (this.m.Cooldown != 0)
			{
				ret.extend([
					{
						id = 6,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
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
				local hp = this.Math.maxf(0.05, this.m.SwallowedEntity.getHitpointsPct() - 0.05);
				this.m.SwallowedEntity.setHitpointsPct(hp);

				local b = this.m.SwallowedEntity.getBaseProperties();
				local BodyParts = [
					this.Const.BodyPart.Body,
					this.Const.BodyPart.Head
				];

				foreach ( BodyPart in BodyParts) 
				{
					local armorDamage = this.Math.rand(5, 7);
					local overflowDamage = armorDamage;

					if (b.Armor[BodyPart] != 0)
					{
						overflowDamage = overflowDamage - b.Armor[BodyPart] * b.ArmorMult[BodyPart];
						b.Armor[BodyPart] = this.Math.max(0, b.Armor[BodyPart] * b.ArmorMult[BodyPart] - armorDamage);
					}

					if (overflowDamage > 0)
					{
						this.m.SwallowedEntity.getItems().onDamageReceived(overflowDamage, this.Const.FatalityType.None, BodyPart, null);
					}
				}
			}

			this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
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
			
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			if (brothers.len() == 1 && !this.getContainer().getActor().isPlayerControlled())
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
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
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

			if (target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				target.setMoraleState(this.Const.MoraleState.Breaking);
			}
			
			this.Tactical.getTemporaryRoster().add(target);
			this.Tactical.TurnSequenceBar.removeEntity(target);
			this.m.SwallowedEntity = target;
			this.m.SwallowedEntity.getFlags().set("Devoured", true);

			if (!this.Tactical.State.isAutoRetreat() && !target.isPlayerControlled())
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}

			target.removeFromMap();
			_user.getSprite("body").setBrush("bust_ghoul_body_04");
			_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
			_user.getSprite("head").setBrush("bust_ghoul_04_head_0" + _user.m.Head);
			_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
			local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
			effect.setName(target.getName());
			effect.setLink(this);
			_user.getSkills().add(effect);

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}

			local skill = this.getContainer().getSkillByID("actives.nacho_vomiting");

			if (skill != null)
			{
				skill.setCooldown();
			}

			return true;
		};
		obj.onSwallow <- function( _user )
		{
			_user.setHitpoints(this.Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));

			if (_user.getFlags().has("hunger"))
			{
				local count = this.Math.min(2, _user.getFlags().getAsInt("hunger") + 1);
				_user.getFlags().set("hunger", count);
			}
			else 
			{
			    _user.getFlags().set("hunger", 2);
			}
		};
		obj.onCombatStarted <- function()
		{
			this.m.IsArena = this.Tactical.State.m.StrategicProperties != null && this.Tactical.State.m.StrategicProperties.IsArenaMode;
		};
		obj.onCombatFinished <- function()
		{
			local actor = this.getContainer().getActor();
			
			if (this.m.SwallowedEntity != null && this.getContainer().getActor().isPlayerControlled())
			{
				this.m.SwallowedEntity.getItems().dropAll(actor.getTile(), actor, false);
				if (!this.m.IsArena && this.m.SwallowedEntity.m.WorldTroop != null && ("Party" in this.m.SwallowedEntity.m.WorldTroop) && this.m.SwallowedEntity.m.WorldTroop.Party != null)
				{
					this.m.SwallowedEntity.m.WorldTroop.Party.removeTroop(this.m.SwallowedEntity.m.WorldTroop);
				}
				this.onSwallow(actor);
				actor.addXP(this.m.SwallowedEntity.getXPValue());
				actor.getSprite("body").setBrush("bust_ghoul_body_03");
				actor.getSprite("head").setBrush("bust_ghoul_03_head_0" + actor.m.Head);
				actor.getSprite("injury").setBrush("bust_ghoul_03_injured");
			}
			
			this.m.SwallowedEntity = null;
			this.m.IsArena = false;
			this.m.Cooldown = 0;
		};
		obj.checkCanBeSwallow <- function( _entity )
		{
			local invalid = [
				this.Const.EntityType.Mortar,
				this.Const.EntityType.Unhold,
				this.Const.EntityType.UnholdFrost,
				this.Const.EntityType.UnholdBog,
				this.Const.EntityType.BarbarianUnhold,
				this.Const.EntityType.BarbarianUnholdFrost,
				this.Const.EntityType.GoblinWolfrider,
				this.Const.EntityType.OrcWarlord,
				this.Const.EntityType.ZombieBetrayer,
				this.Const.EntityType.Ghost,
				this.Const.EntityType.SkeletonPhylactery,
				this.Const.EntityType.SkeletonLichMirrorImage,
				this.Const.EntityType.Schrat,
				this.Const.EntityType.Lindwurm,
				this.Const.EntityType.Kraken,
				this.Const.EntityType.KrakenTentacle,
				this.Const.EntityType.TricksterGod,
				this.Const.EntityType.ZombieBoss,
				this.Const.EntityType.SkeletonBoss,
				this.Const.EntityType.SkeletonLich,
				this.Const.EntityType.LegendOrcElite,
				this.Const.EntityType.LegendOrcBehemoth,
				this.Const.EntityType.LegendWhiteDirewolf,
				this.Const.EntityType.LegendStollwurm,
				this.Const.EntityType.LegendRockUnhold,
				this.Const.EntityType.LegendGreenwoodSchrat,
			];
			local type = _entity.getType();
			local ret = invalid.find(type);
			
			if (type == this.Const.EntityType.SandGolem || type == this.Const.EntityType.Ghoul || type == this.Const.EntityType.LegendSkinGhoul)
			{
				return _entity.getSize() < 3;
			}
			
			if (ret != null)
			{
				return false;
			}
			
			type = _entity.getFlags().has("bewitched") ? _entity.getFlags().get("bewitched") : null;

			if (type != null && invalid.find(type) != null)
			{
				return false;
			}
			
			return true;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
	});


	// ghoul
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
					text = "Can be used to [color=" + this.Const.UI.Color.PositiveValue + "]Swallow[/color] an unlucky target"
				},
				{
					id = 5,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not swallow something bigger than you[/color]"
				}
			];

			if (this.m.Cooldown != 0)
			{
				ret.extend([
					{
						id = 6,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
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
				local hp = this.Math.maxf(0.05, this.m.SwallowedEntity.getHitpointsPct() - 0.075);
				this.m.SwallowedEntity.setHitpointsPct(hp);

				local b = this.m.SwallowedEntity.getBaseProperties();
				local BodyParts = [
					this.Const.BodyPart.Body,
					this.Const.BodyPart.Head
				];

				foreach ( BodyPart in BodyParts) 
				{
					local armorDamage = this.Math.rand(5, 12);
					local overflowDamage = armorDamage;

					if (b.Armor[BodyPart] != 0)
					{
						overflowDamage = overflowDamage - b.Armor[BodyPart] * b.ArmorMult[BodyPart];
						b.Armor[BodyPart] = this.Math.max(0, b.Armor[BodyPart] * b.ArmorMult[BodyPart] - armorDamage);
					}

					if (overflowDamage > 0)
					{
						this.m.SwallowedEntity.getItems().onDamageReceived(overflowDamage, this.Const.FatalityType.None, BodyPart, null);
					}
				}
			}

			this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
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
			
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			if (brothers.len() == 1 && !this.getContainer().getActor().isPlayerControlled())
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
		obj.onBeforeUse <- function( _user , _targetTile )
		{
			if (!_user.getFlags().has("luft"))
			{
				return;
			}
			
			this.Tactical.spawnSpriteEffect("luft_swallow_quote_" + this.Math.rand(1, 4), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
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
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
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

			if (target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				target.setMoraleState(this.Const.MoraleState.Breaking);
			}
			
			this.Tactical.getTemporaryRoster().add(target);
			this.Tactical.TurnSequenceBar.removeEntity(target);
			this.m.SwallowedEntity = target;
			this.m.SwallowedEntity.getFlags().set("Devoured", true);

			if (!this.Tactical.State.isAutoRetreat() && !target.isPlayerControlled())
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}

			target.removeFromMap();
			_user.getSprite("body").setBrush("bust_ghoulskin_body_04");
			_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
			_user.getSprite("head").setBrush("bust_ghoulskin_04_head_0" + _user.m.Head);
			_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
			local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
			effect.setName(target.getName());
			effect.setLink(this);
			_user.getSkills().add(effect);

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}

			local skill = this.getContainer().getSkillByID("actives.nacho_vomiting");

			if (skill != null)
			{
				skill.setCooldown();
			}

			return true;
		};
		obj.onSwallow <- function( _user )
		{
			_user.setHitpoints(this.Math.min(_user.getHitpoints() + 100, _user.getHitpointsMax()));

			if (_user.getFlags().has("hunger"))
			{
				local count = this.Math.min(2, _user.getFlags().getAsInt("hunger") + 1);
				_user.getFlags().set("hunger", count);
			}
			else 
			{
			    _user.getFlags().set("hunger", 2);
			}
		};
		obj.onCombatStarted <- function()
		{
			this.m.IsArena = this.Tactical.State.m.StrategicProperties != null && this.Tactical.State.m.StrategicProperties.IsArenaMode;
		};
		obj.onCombatFinished <- function()
		{
			local actor = this.getContainer().getActor();
			
			if (this.m.SwallowedEntity != null && this.getContainer().getActor().isPlayerControlled())
			{
				this.m.SwallowedEntity.getItems().dropAll(actor.getTile(), actor, false);
				if (!this.m.IsArena && this.m.SwallowedEntity.m.WorldTroop != null && ("Party" in this.m.SwallowedEntity.m.WorldTroop) && this.m.SwallowedEntity.m.WorldTroop.Party != null)
				{
					this.m.SwallowedEntity.m.WorldTroop.Party.removeTroop(this.m.SwallowedEntity.m.WorldTroop);
				}
				this.onSwallow(actor);
				actor.addXP(this.m.SwallowedEntity.getXPValue());
				actor.getSprite("body").setBrush("bust_ghoulskin_body_03");
				actor.getSprite("head").setBrush("bust_ghoulskin_03_head_0" + actor.m.Head);
				actor.getSprite("injury").setBrush("bust_ghoulskin_03_injured");
			}
			
			this.m.SwallowedEntity = null;
			this.m.IsArena = false;
			this.m.Cooldown = 0;
		};
		obj.checkCanBeSwallow <- function( _entity )
		{
			local invalid = [
				this.Const.EntityType.Mortar,
				this.Const.EntityType.Unhold,
				this.Const.EntityType.UnholdFrost,
				this.Const.EntityType.UnholdBog,
				this.Const.EntityType.BarbarianUnhold,
				this.Const.EntityType.BarbarianUnholdFrost,
				this.Const.EntityType.GoblinWolfrider,
				this.Const.EntityType.OrcWarlord,
				this.Const.EntityType.ZombieBetrayer,
				this.Const.EntityType.Ghost,
				this.Const.EntityType.SkeletonPhylactery,
				this.Const.EntityType.SkeletonLichMirrorImage,
				this.Const.EntityType.Schrat,
				this.Const.EntityType.Lindwurm,
				this.Const.EntityType.Kraken,
				this.Const.EntityType.KrakenTentacle,
				this.Const.EntityType.TricksterGod,
				this.Const.EntityType.ZombieBoss,
				this.Const.EntityType.SkeletonBoss,
				this.Const.EntityType.SkeletonLich,
				this.Const.EntityType.LegendOrcElite,
				this.Const.EntityType.LegendOrcBehemoth,
				this.Const.EntityType.LegendWhiteDirewolf,
				this.Const.EntityType.LegendStollwurm,
				this.Const.EntityType.LegendRockUnhold,
				this.Const.EntityType.LegendGreenwoodSchrat,
			];
			local type = _entity.getType();
			local ret = invalid.find(type);
			
			if (type == this.Const.EntityType.SandGolem || type == this.Const.EntityType.Ghoul || type == this.Const.EntityType.LegendSkinGhoul)
			{
				return _entity.getSize() < 3;
			}
			
			if (ret != null)
			{
				return false;
			}
			
			type = _entity.getFlags().has("bewitched") ? _entity.getFlags().get("bewitched") : null;

			if (type != null && invalid.find(type) != null)
			{
				return false;
			}
			
			return true;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInShields ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
	});


	// ijirok
	::mods_hookExactClass("skills/actives/gore_skill", function ( obj )
	{
		obj.m.IsPlayer <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Dealing devastating damage by ramming with an incredible speed, easily punch through enemy formation.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_166.png";
			this.m.IconDisabled = "skills/active_166_sw.png";
			this.m.IsAOE = true;
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.IsVisibleTileNeeded = true;
				this.m.IsIgnoringRiposte = true;
				this.m.IsPlayer = true;
				this.m.ActionPointCost = 4;
				this.m.MinRange = 1;
				this.m.MaxRange = 6;
				this.m.ChanceDisembowel = 30;
				this.m.ChanceSmash = 30;
			};

			this.getContainer().add(this.new("scripts/skills/actives/gore_skill_zoc"));
		};
		obj.getTooltip <- function()
		{
			local ret = this.skill.getDefaultTooltip();

			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/stat_screen_dmg_dealt.png",
					text = "Always inflicts at least [color=" + this.Const.UI.Color.DamageValue + "]" + 15 + "[/color] damage to hitpoints, regardless of armor"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range within [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMinRange() + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can [color=" + this.Const.UI.Color.PositiveValue + "]Stagger[/color] and [color=" + this.Const.UI.Color.PositiveValue + "]Knock Back[/color] on a hit"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 5 targets"
				},
			]);

			return ret;
		};
		obj.onUpdate = function( _properties )
		{
			_properties.DamageMinimum += 15;
			_properties.DamageRegularMin += 100;
			_properties.DamageRegularMax += 130;
			_properties.DamageArmorMult *= 0.75;

			if (this.Tactical.isActive() && this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() == 1)
			{
				this.m.MaxRange = 10;
			}
			else
			{
				this.m.MaxRange = 6;
			}
		};
		obj.applyEffectToTarget = function( _user, _target, _targetTile )
		{
			if (_target.isNonCombatant())
			{
				return;
			}

			_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}

			if (!_target.getCurrentProperties().IsRooted)
			{
				local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

				if (knockToTile == null)
				{
					return;
				}

				this.m.TilesUsed.push(knockToTile.ID);

				if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_target));
				}

				local skills = _target.getSkills();
				skills.removeByID("effects.shieldwall");
				skills.removeByID("effects.spearwall");
				skills.removeByID("effects.riposte");
				skills.removeByID("effects.legend_vala_chant_disharmony_effect");
				skills.removeByID("effects.legend_vala_chant_fury_effect");
				skills.removeByID("effects.legend_vala_chant_senses_effect");
				skills.removeByID("effects.legend_vala_currently_chanting");
				skills.removeByID("effects.legend_vala_in_trance");
				_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
				local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

				if (damage == 0)
				{
					this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
				}
				else
				{
					local p = this.getContainer().getActor().getCurrentProperties();
					local tag = {
						Attacker = _user,
						Skill = this,
						HitInfo = clone this.Const.Tactical.HitInfo
					};
					tag.HitInfo.DamageRegular = damage;
					tag.HitInfo.DamageDirect = 1.0;
					tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
					tag.HitInfo.BodyDamageMult = 1.0;
					tag.HitInfo.FatalityChanceMult = 1.0;
					this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
				}
			}
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = _targetTile;

			for( local i = 0; i != 6; i = ++i )
			{
				if (!ownTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = ownTile.getNextTile(i);

					if (this.Math.abs(tile.Level - ownTile.Level) <= 1)
					{
						this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
					}
				}
			}
		}
	});


	// ijirok
	::mods_hookExactClass("skills/actives/teleport_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Teleport away by using unknown power at the same time causes the surrounding temperature to drop down absolute zero. ";
			this.m.Icon = "skills/active_167.png";
			this.m.IconDisabled = "skills/active_167_sw.png";
			this.m.Overlay = "active_167";
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.IsVisibleTileNeeded = true;
				this.m.ActionPointCost = 4;
				this.m.MinRange = 1;
				this.m.MaxRange = 15;
			}
		};
		obj.onUpdate <- function( _properties )
		{
			_properties.Vision += 7;
		};
		obj.getTooltip = function()
		{
			local p = this.getContainer().getActor().getCurrentProperties();
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
				{
					id = 6,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of  [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Creates snow tiles and causes chilled effect to anyone near you"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Teleport instantly"
				},
			];
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			if (_user.getCurrentProperties().IsRooted)
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " is free from ensnared");

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

			return ws_onUse(_user, _targetTile);
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/gorge_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A powerful attack that can be used at a distance.";
			this.m.Icon = "skills/active_107.png";
			this.m.IconDisabled = "skills/active_107_sw.png";
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			});
			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/tail_slam_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Tail Sweep";
			this.m.Description = "Skillfully swinging your tail in a wide arc that hits three adjacent tiles in counter-clockwise order. Never hit yourself.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_108.png";
			this.m.IconDisabled = "skills/active_108_sw.png";
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 1;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.HitChanceBonus + "%[/color] chance to hit"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a chance to [color=" + this.Const.UI.Color.NegativeValue + "]Daze[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] on a hit"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Never hit [color=" + this.Const.UI.Color.NegativeValue + "]yourself[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]your kind[/color]"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 3 targets"
				}
			]);

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			this.m.TilesUsed = [];
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			local ret = false;
			local ownTile = _user.getTile();
			local dir = ownTile.getDirectionTo(_targetTile);
			ret = this.attackEntity(_user, _targetTile.getEntity());

			if (!_user.isAlive() || _user.isDying())
			{
				return ret;
			}

			if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
			{
				this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
			}

			local nextDir = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);
				local success = false;
				local canBeHit = nextTile.IsOccupiedByActor && this.canBeHit(_user, nextTile.getEntity());

				if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - ownTile.Level) <= 1 && canBeHit)
				{
					success = this.attackEntity(_user, nextTile.getEntity());
				}

				if (!_user.isAlive() || _user.isDying())
				{
					return success;
				}

				if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying() && canBeHit)
				{
					this.applyEffectToTarget(_user, nextTile.getEntity(), nextTile);
				}

				ret = success || ret;
			}

			nextDir = nextDir - 1 >= 0 ? nextDir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);
				local success = false;
				local canBeHit = nextTile.IsOccupiedByActor && this.canBeHit(_user, nextTile.getEntity());

				if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - ownTile.Level) <= 1 && canBeHit)
				{
					success = this.attackEntity(_user, nextTile.getEntity());
				}

				if (!_user.isAlive() || _user.isDying())
				{
					return success;
				}

				if (success && nextTile.IsOccupiedByActor && nextTile.getEntity().isAlive() && !nextTile.getEntity().isDying() && canBeHit)
				{
					this.applyEffectToTarget(_user, nextTile.getEntity(), nextTile);
				}

				ret = success || ret;
			}

			this.m.TilesUsed = [];
			return ret;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = this.getContainer().getActor().getTile();
			local dir = ownTile.getDirectionTo(_targetTile);
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			local nextDir = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);

				if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
				}
			}

			nextDir = nextDir - 1 >= 0 ? nextDir - 1 : this.Const.Direction.COUNT - 1;

			if (ownTile.hasNextTile(nextDir))
			{
				local nextTile = ownTile.getNextTile(nextDir);

				if (this.Math.abs(nextTile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);
				}
			}
		};
		obj.canBeHit <- function( _user, _target )
		{
			local canBeHit = true;
			local isAllied = _target.isAlliedWith(_user);
			local isLindwurm = _target.getFlags().has("lindwurm");
			
			if (isLindwurm)
			{
				canBeHit = false;
				
				if (!isAllied)
				{
					canBeHit = true;
				}
			}
			
			return canBeHit;
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/tail_slam_big_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Tail Thresh";
			this.m.Description = "Skillfully using your tail to tresh all the targets around you, foe and friend alike, with a reckless round swing, of course you will not hit yourself. Has a chance to stun targets hit for one turn.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_108.png";
			this.m.IconDisabled = "skills/active_108_sw.png";
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 2;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.HitChanceBonus + "%[/color] chance to hit"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a chance to [color=" + this.Const.UI.Color.NegativeValue + "]Daze[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] on a hit"
				},
				{
					id = 8,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Never hit [color=" + this.Const.UI.Color.NegativeValue + "]yourself[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]your kind[/color]"
				},
				{
					id = 9,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 6 targets"
				}
			]);
			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			local ret = false;
			local ownTile = this.getContainer().getActor().getTile();
			local soundBackup = [];
			this.m.TilesUsed = [];
			this.spawnAttackEffect(ownTile, this.Const.Tactical.AttackEffectThresh);

			for( local i = 5; i >= 0; i = --i )
			{
				if (!ownTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = ownTile.getNextTile(i);
					local canbeHit = tile.IsOccupiedByActor && this.canBeHit(_user, tile.getEntity());

					if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && this.Math.abs(tile.Level - ownTile.Level) <= 1 && canbeHit)
					{
						if (ret && soundBackup.len() == 0)
						{
							soundBackup = this.m.SoundOnHit;
							this.m.SoundOnHit = [];
						}

						local success = this.attackEntity(_user, tile.getEntity());

						if (success && !tile.IsEmpty && tile.getEntity().isAlive() && !tile.getEntity().isDying() && canbeHit)
						{
							this.applyEffectToTarget(_user, tile.getEntity(), tile);
						}

						ret = success || ret;

						if (!_user.isAlive() || _user.isDying())
						{
							break;
						}
					}
				}
			}

			if (ret && this.m.SoundOnHit.len() == 0)
			{
				this.m.SoundOnHit = soundBackup;
			}

			this.m.TilesUsed = [];
			return ret;
		};
		obj.canBeHit <- function( _user, _target )
		{
			local canBeHit = true;
			local isAllied = _target.isAlliedWith(_user);
			local isLindwurm = _target.getFlags().has("lindwurm");
			
			if (isLindwurm)
			{
				canBeHit = false;
				
				if (!isAllied)
				{
					canBeHit = true;
				}
			}
			
			return canBeHit;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = this.getContainer().getActor().getTile();

			for( local i = 0; i != 6; i = ++i )
			{
				if (!ownTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = ownTile.getNextTile(i);

					if (!tile.IsEmpty && tile.getEntity().isAttackable() && this.Math.abs(tile.Level - ownTile.Level) <= 1)
					{
						this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
					}
				}
			}
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/tail_slam_split_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Tail Split";
			this.m.Description = "A wide-swinging overhead attack with your tail performed for maximum reach rather than force that can hit two tiles in a straight line.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_108.png";
			this.m.IconDisabled = "skills/active_108_sw.png";
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a chance to [color=" + this.Const.UI.Color.NegativeValue + "]Daze[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Stun[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Knock Back[/color] on a hit"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Never hit [color=" + this.Const.UI.Color.NegativeValue + "]yourself[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]your kind[/color]"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Can hit up to 2 targets"
				}
			]);

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplit);
			local ret = this.attackEntity(_user, _targetTile.getEntity());

			if (!_user.isAlive() || _user.isDying())
			{
				return ret;
			}

			if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
			{
				this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
			}

			local ownTile = _user.getTile();
			local dir = ownTile.getDirectionTo(_targetTile);

			if (_targetTile.hasNextTile(dir))
			{
				local forwardTile = _targetTile.getNextTile(dir);
				local canbeHit = forwardTile.IsOccupiedByActor && this.canBeHit(_user, forwardTile.getEntity());

				if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && this.Math.abs(forwardTile.Level - ownTile.Level) <= 1 && canbeHit)
				{
					ret = this.attackEntity(_user, forwardTile.getEntity()) || ret;
				}

				if (ret && forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAlive() && !forwardTile.getEntity().isDying() && canbeHit)
				{
					this.applyEffectToTarget(_user, forwardTile.getEntity(), forwardTile);
				}
			}

			return ret;
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			local ownTile = this.getContainer().getActor().getTile();
			local dir = ownTile.getDirectionTo(_targetTile);

			if (_targetTile.hasNextTile(dir))
			{
				local forwardTile = _targetTile.getNextTile(dir);

				if (this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
				}
			}
		};
		obj.canBeHit <- function( _user, _target )
		{
			local canBeHit = true;
			local isAllied = _target.isAlliedWith(_user);
			local isLindwurm = _target.getFlags().has("lindwurm");
			
			if (isLindwurm)
			{
				canBeHit = false;
				
				if (!isAllied)
				{
					canBeHit = true;
				}
			}
			
			return canBeHit;
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/tail_slam_zoc_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsHidden = true;
		};
		obj.isUsable <- function()
		{
			return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/move_tail_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Move the tail closer to the body";
			this.m.Icon = "skills/active_109.png";
			this.m.IconDisabled = "skills/active_109_sw.png";
		};
		obj.onAdded <- function()
		{	
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.ActionPointCost = 5;
			}
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultUtilityTooltip();
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/legend_stollwurm_move_tail_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.ID = "actives.move_tail";
			this.m.Name = "Burrow Tail";
			this.m.Description = "Digging your way through the underground to reach you destination.";
			this.m.Icon = "skills/active_149.png";
			this.m.IconDisabled = "skills/active_149_sw.png";
			this.m.Overlay = "active_149";
		};
		obj.onAdded <- function()
		{	
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.ActionPointCost = 5;
			}
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultUtilityTooltip();
		};
	});


	// lindwurm
	::mods_hookExactClass("skills/actives/legend_stollwurm_move_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Digging your way through the underground to reach you destination.";
			this.m.Icon = "skills/active_149.png";
			this.m.IconDisabled = "skills/active_149_sw.png";
			this.m.Overlay = "active_149";
		};
		obj.onAdded <- function()
		{
			this.m.IsVisibleTileNeeded = this.getContainer().getActor().isPlayerControlled();
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/grow_shield_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Grow Shield";
			this.m.Description = "Regrow your bark, producing a protective shield";
			this.m.Icon = "skills/active_121.png";
			this.m.IconDisabled = "skills/active_121_sw.png";
			this.m.Overlay = "active_121";
			this.m.Order = this.Const.SkillOrder.NonTargeted + 1;
		};
		obj.getTooltip <- function()
		{
			local ret = this.skill.getDefaultUtilityTooltip();
			local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers;

			ret.push({
				id = 4,
				type = "text",
				icon = "/ui/icons/melee_defense.png",
				text = "Grants a [color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Melee and Ranged Defense shield, with [color=" + this.Const.UI.Color.PositiveValue + "]32[/color] durability"
			});

			if (isSpecialized)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Gains [color=" + this.Const.UI.Color.PositiveValue + "]Shieldwall[/color] effect for free when growing a new shield"
				});
			}

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			local actor = this.getContainer().getActor();
			local isSpecialized = this.getContainer().hasSkill("perk.grow_shield");
			
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, function ( _idk )
			{
				actor.getItems().equip(this.new("scripts/items/shields/beasts/schrat_shield"));
				actor.getSprite("shield_icon").Alpha = 0;
				actor.getSprite("shield_icon").fadeIn(1500);

				if (isSpecialized)
				{
					actor.getSkills().add(this.new("scripts/skills/effects/shieldwall_effect"));
				}
			}, null);
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/legend_grow_greenwood_shield_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Grow Greenwood Shield";
			this.m.Description = "Regrow your bark, producing a protective shield";
			this.m.Icon = "skills/active_121.png";
			this.m.IconDisabled = "skills/active_121_sw.png";
			this.m.Overlay = "active_121";
			this.m.Order = this.Const.SkillOrder.NonTargeted + 1;
		};
		obj.onAdded <- function()
		{
			if (this.getContainer().getActor().isPlayerControlled())
			{
				this.m.FatigueCost = 50;
			}
		}
		obj.getTooltip <- function()
		{
			local ret = this.skill.getDefaultUtilityTooltip();
			local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers;

			ret.push({
				id = 4,
				type = "text",
				icon = "/ui/icons/melee_defense.png",
				text = "Grants a [color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] Melee and Ranged Defense shield, with [color=" + this.Const.UI.Color.PositiveValue + "]64[/color] durability"
			});

			if (isSpecialized)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Gains [color=" + this.Const.UI.Color.PositiveValue + "]Shieldwall[/color] effect for free when growing a new shield"
				});
			}

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			local actor = this.getContainer().getActor();
			local isSpecialized = this.getContainer().hasSkill("perk.grow_shield");

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, function ( _idk )
			{
				actor.getItems().equip(this.new("scripts/items/shields/beasts/legend_greenwood_schrat_shield"));
				actor.getSprite("shield_icon").Alpha = 0;
				actor.getSprite("shield_icon").fadeIn(1500);

				if (isSpecialized)
				{
					actor.getSkills().add(this.new("scripts/skills/effects/shieldwall_effect"));
				}
			}, null);
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/uproot_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Send out roots to hold and damage enemies in a straight line.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_122.png";
			this.m.IconDisabled = "skills/active_122_sw.png";
			this.m.Overlay = "active_122";
		};
		obj.getTooltip = function()
		{
			local ret = this.getDefaultTooltip();
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can target the ground and hits up to 3 tiles in a line"
			});
			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;

			if (_properties.IsSpecializedInSpears)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 15;
				_properties.DamageArmorMult += 0.1;
			}
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local ownTile = this.getContainer().getActor().getTile();
			local dir = ownTile.getDirectionTo(_targetTile);
			
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
			
			if (_targetTile.hasNextTile(dir))
			{
				local forwardTile = _targetTile.getNextTile(dir);
					
				if (forwardTile.IsOccupiedByActor || forwardTile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
				}
				
				if (forwardTile.hasNextTile(dir))
				{
					local followupTile = forwardTile.getNextTile(dir);
					
					if (followupTile.IsOccupiedByActor || followupTile.IsEmpty)
					{
						this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, followupTile, followupTile.Pos.X, followupTile.Pos.Y);
					}
				}
			}
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/uproot_small_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Send out roots to hold and damage an enemy.";
			this.m.KilledString = "Crushed";
			this.m.Icon = "skills/active_122.png";
			this.m.IconDisabled = "skills/active_122_sw.png";
			this.m.Overlay = "active_122";
			this.m.IsAOE = false;
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;

			if (_properties.IsSpecializedInSpears)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 15;
			}
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/uproot_zoc_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsHidden = true;
		};
		obj.isUsable <- function()
		{
			return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
		};
	});


	// schrat
	::mods_hookExactClass("skills/actives/uproot_small_zoc_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.IsHidden = true;
		};
		obj.isUsable <- function()
		{
			return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
		};
	});


	// spider
	::mods_hookExactClass("skills/actives/web_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Send a web of silk out to ensnare an opponent, rooting them in place halving their damage, defenses and initiative. Does no damage.";
			this.m.Icon = "skills/active_114.png";
			this.m.IconDisabled = "skills/active_114_sw.png";
		};
		obj.getTooltip = function()
		{
			local ret = this.getDefaultUtilityTooltip();
			
			if (this.m.Cooldown != 0)
			{
				ret.push({
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
				});
			}
			
			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_web") ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};

		local ws_onVerifyTarget = obj.onVerifyTarget;
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!ws_onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			return !_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot;
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			local ret = ws_onUse(_user, _targetTile);
			local specialization = this.getContainer().getSkillByID("perk.spider_web");

			if (specialization != null)
			{
				local breakFree = _targetTile.getEntity().getSkills().getSkillByID("actives.break_free");

				if (breakFree != null)
				{
					breakFree.setChanceBonus(specialization.getPenalty());
				}

				this.m.Cooldown = 0;
			}

			return ret;
		};
		obj.onCombatStarted <- function()
		{
			this.m.Cooldown = 0;
		}
	});


	// spider
	::mods_hookExactClass("skills/actives/spider_bite_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A spider bite that can leave nasty wounds. Deal more damage to target get entangled in web or any kind of ensnare.";
			this.m.KilledString = "Ripped to shreds";
			this.m.Icon = "skills/active_115.png";
			this.m.IconDisabled = "skills/active_115_sw.png";
			this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
			this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
		};
		obj.onAdded <- function()
		{
			local actor = this.getContainer().getActor();

			if (!actor.isPlayerControlled() || actor.isSummoned())
			{
				return;
			}

			this.m.ActionPointCost = 5;
			this.m.DirectDamageMult += 0.1;
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_bite") ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
	});


	// spider
	::mods_hookExactClass("skills/actives/legend_redback_spider_bite_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A spider bite that can leave nasty wounds. Deal more damage to target get entangled in web or any kind of ensnare.";
			this.m.KilledString = "Ripped to shreds";
			this.m.Icon = "skills/active_115.png";
			this.m.IconDisabled = "skills/active_115_sw.png";
			this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
			this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
		};
		obj.onAdded <- function()
		{
			local actor = this.getContainer().getActor();

			if (!actor.isPlayerControlled() || actor.isSummoned())
			{
				return;
			}

			this.m.ActionPointCost = 5;
			this.m.DirectDamageMult += 0.1;
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_bite") ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
	});


	// serpent
	::mods_hookExactClass("skills/actives/serpent_bite_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "A bite from a giant snake can be a little painful";
			this.m.KilledString = "Bitten to bits";
			this.m.Icon = "skills/active_196.png";
			this.m.IconDisabled = "skills/active_196_sw.png";
			this.m.ChanceDisembowel = 25;
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();

			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
			{
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
				});
			}

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.MaxRange = _properties.IsSpecializedInShields ? 2 : 1;
			
			if (_properties.IsSpecializedInPolearms)
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 18;
				_properties.DamageArmorMult += 0.10;
				this.m.ActionPointCost -= 1;
			}
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
		    if (_skill == this && _targetEntity != null)
		    {
		    	local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

		    	if (d > 1)
		    	{
		    		_properties.MeleeSkill -= 7 * (d - 1);
		    		_properties.MeleeDamageMult *= 0.75;
		    	}
		    }
		}
	});


	// serpent
	::mods_hookExactClass("skills/actives/serpent_hook_skill", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Drag";
			this.m.Description = "Constrict a target and drag them closer to you. Will break any defensive stance that target had before being dragged.";
			this.m.Icon = "skills/active_192.png";
			this.m.IconDisabled = "skills/active_192_sw.png";
			this.m.Delay = 500;
			this.m.Order = this.Const.SkillOrder.UtilityTargeted - 1;
			this.m.IsWeaponSkill = false;
			this.m.IsAttack = false;
			this.m.DirectDamageMult = 0.2;
		};
		obj.isImprovedDrag <- function() 
		{
		    return this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields;
		};
		obj.isUpgradeDrag <- function()
		{
			return this.getContainer().getActor().getCurrentProperties().IsSpecializedInThrowing;
		};
		obj.onAdded <- function()
		{
			this.setFatigueCost(this.getContainer().getActor().isPlayerControlled() ? 30 : 20);
		};
		function getTooltip()
		{
			local p = this.getContainer().getActor().getCurrentProperties();
			local chance = this.Math.max(10, this.Math.floor(p.getMeleeSkill() * 0.5));
			local ret = (this.isImprovedDrag() || this.isUpgradeDrag()) ? this.getDefaultTooltip() : [
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

			ret.extend([
				{
					id = 7,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] chance to stagger on a hit"
				},
			]);

			if (p.IsSpecializedInShields)
			{
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] chance to disarm on a hit"
				});
			}

			return ret;
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.MaxRange = _properties.IsSpecializedInThrowing ? 4 : 3;
			this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? 0.75 : 1.0;
		};
		obj.getHitchance <- function( _targetEntity )
		{
			if (!_targetEntity.isAttackable() && !_targetEntity.isRock() && !_targetEntity.isTree() && !_targetEntity.isBush() && !_targetEntity.isSupplies())
			{
				return 0;
			}

			if (this.isImprovedDrag() && _targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab)
			{
				return 50;
			}

			return 100;
		};
		obj.getPulledToTiles = function( _userTile, _targetTile )
		{
			local tiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!_userTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _userTile.getNextTile(i);

					if (tile.Level <= _userTile.Level && tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.getMaxRange())
					{
						tiles.push(tile);
					}
				}
			}

			if (tiles.len() <= 1)
			{
				return tiles;
			}

			return this.smartFilter(_userTile, _targetTile, tiles);
		};
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			local target = _targetTile.getEntity();

			if (target.getCurrentProperties().IsRooted)
			{
				return false;
			}
			
			if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !target.isAlliedWith(this.getContainer().getActor()))
			{
				if (!this.isImprovedDrag() || !this.isViableTarget(_originTile.getEntity(), _targetTile.getEntity()))
				{
					return false;
				}
			}

			return this.getPulledToTile(_originTile, _targetTile) != null;
		};
		obj.isViableTarget <- function( _user, _target )
		{
			if (_target.isAlliedWith(_user))
			{
				return true;
			}

			if (_target.isNonCombatant())
			{
				return false;
			}

			local type = _target.getType();
			local invalid = [
				this.Const.EntityType.Mortar,
				this.Const.EntityType.Ghost,
				this.Const.EntityType.SkeletonPhylactery,
				this.Const.EntityType.SkeletonLichMirrorImage,
				this.Const.EntityType.Schrat,
				this.Const.EntityType.Lindwurm,
				this.Const.EntityType.Kraken,
				this.Const.EntityType.KrakenTentacle,
				this.Const.EntityType.TricksterGod,
				this.Const.EntityType.LegendOrcBehemoth,
				this.Const.EntityType.LegendWhiteDirewolf,
				this.Const.EntityType.LegendStollwurm,
				this.Const.EntityType.LegendRockUnhold,
				this.Const.EntityType.LegendGreenwoodSchrat,
			];

			return invalid.find(type) == null;
		};
		obj.onUse = function( _user, _targetTile )
		{
			local target = _targetTile.getEntity();
			local distance = _user.getTile().getDistanceTo(_targetTile);
			local pullToTile;

			if (this.m.DestinationTile != null)
			{
				pullToTile = this.m.DestinationTile;
				this.m.DestinationTile = null;
			}
			else
			{
				pullToTile = this.getPulledToTile(_user.getTile(), _targetTile);
			}

			if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !target.isAlliedWith(_user))
			{
				local r = this.Math.rand(1, 100);

				if (!this.isImprovedDrag())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to drag in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
					return false;
				}
				else if (r > 50)
				{
				    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to drag in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " (Chance: 50, Rolled: " + r + ")");
					return false;
				}
			}

			if (pullToTile == null)
			{
				return false;
			}

			if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " drags in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
			}

			if (!_user.isHiddenToPlayer() || !target.isHiddenToPlayer())
			{
				local variant = _user.m.Variant;
				local scaleBackup = target.getSprite("status_rooted").Scale;
				_user.fadeOut(50);
				local rooted_front = target.getSprite("status_rooted");
				rooted_front.Scale = 1.0;
				rooted_front.setBrush("snake_ensnare_front_0" + variant);
				rooted_front.Visible = true;
				rooted_front.Alpha = 0;
				rooted_front.fadeIn(50);
				local rooted_back = target.getSprite("status_rooted_back");
				rooted_back.Scale = 1.0;
				rooted_back.setBrush("snake_ensnare_back_0" + variant);
				rooted_back.Visible = true;
				rooted_back.Alpha = 0;
				rooted_back.fadeIn(50);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, this.onDone, {
					User = _user,
					Target = target,
					ScaleBackup = scaleBackup,
					Skill = this
				});
			}

			local skills = _targetTile.getEntity().getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			skills.removeByID("effects.legend_vala_chant_disharmony_effect");
			skills.removeByID("effects.legend_vala_chant_fury_effect");
			skills.removeByID("effects.legend_vala_chant_senses_effect");
			skills.removeByID("effects.legend_vala_currently_chanting");
			skills.removeByID("effects.legend_vala_in_trance");
			target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);

			local properties = this.getContainer().buildPropertiesForUse(this, target);
			local damage = properties.IsSpecializedInThrowing ? this.Math.rand(5, 15) : 0;
			damage = properties.IsSpecializedInShields ? damage + this.Math.rand(10, 15) : damage;
			local total_damage = damage * properties.DamageRegularMult;
			local damage_mult = properties.DamageTotalMult * properties.MeleeDamageMult;
			local damageArmor = damage * properties.DamageArmorMult;
			damageArmor = this.Math.max(0, damageArmor + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
			total_damage = this.Math.max(0, total_damage + distance * properties.DamageAdditionalWithEachTile) * damage_mult;
			total_damage = this.Math.max(0, this.Math.abs(pullToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage + total_damage;
			local damageDirect = this.Math.minf(1.0, properties.DamageDirectMult * (this.m.DirectDamageMult + properties.DamageDirectAdd));

			if (target.isAlliedWith(_user) || damage == 0)
			{
				this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, null, null, true);
			}
			else
			{
				local tag = {
					Attacker = _user,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = total_damage;
				tag.HitInfo.DamageArmor = damageArmor;
				tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
				tag.HitInfo.DamageDirect = damageDirect;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, this.onPulledDown, tag, true);
			}
			
			if (!target.isAlliedWith(_user) || this.Math.rand(1, 100) <= 50)
			{
				target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
				
				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
				}
			}

			return true;
		};

		local ws_onPulledDown = obj.onPulledDown;
		obj.onPulledDown = function( _entity, _tag )
		{
			ws_onPulledDown(_entity, _tag);
			_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageInflictedHitpoints, _tag.HitInfo.DamageInflictedArmor);
		};
		obj.onDone = function( _data )
		{
			_data.User.fadeIn(50);

			if (_data.Target.isAlive() && !_data.Target.isDying())
			{
				local rooted_front = _data.Target.getSprite("status_rooted");
				rooted_front.fadeOutAndHide(50);
				rooted_front.Scale = _data.ScaleBackup;
				local rooted_back = _data.Target.getSprite("status_rooted_back");
				rooted_back.fadeOutAndHide(50);
				rooted_back.Scale = _data.ScaleBackup;
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, _data.Skill.onAfterDone, _data);
		};

		local ws_onAfterDone = obj.onAfterDone;
		obj.onAfterDone = function( _data )
		{
			if (!_data.Target.isAlive() || _data.Target.isDying())
			{
				return;
			}

			if (_data.User.getCurrentProperties().IsSpecializedInShields && !_data.Target.isAlliedWith(_data.User))
			{
				local target = _data.Target;
				local chance = this.Math.max(10, this.Math.floor(_data.User.getCurrentProperties().getMeleeSkill() * 0.45));
				
				if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm && this.Math.rand(1, 100) <= chance)
				{
					target.getSkills().add(this.new("scripts/skills/effects/disarmed_effect"));
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_data.User) + " has disarmed " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
				}
			}
			
			ws_onAfterDone(_data);
		};
		obj.onTargetSelected <- function( _targetTile )
		{
			local pulledTo = this.getPulledToTile(this.getContainer().getActor().getTile(), _targetTile);

			if (pulledTo != null)
			{
				this.Tactical.getHighlighter().addOverlayIcon("mortar_target_02", pulledTo, pulledTo.Pos.X, pulledTo.Pos.Y);
			}
		};
		obj.smartFilter <- function( _userTile, _targetTile , _tilesArray ) 
		{
			local ret = [];
		    local _user = this.getContainer().getActor();
			local _target = _targetTile.getEntity();
			local BestScore = 0;
			local BestTarget = null;

			foreach (i, t in _tilesArray) 
			{
			    local score = 0;

			    if (!_target.isAlliedWith(_user))
			    {
			    	if (t.Level < _userTile.Level)
			    	{
			    		score += _userTile.Level - t.Level;
			    	}

			    	if (t.Type == this.Const.Tactical.TerrainType.Swamp)
			    	{
			    		score += 5;
			    	}

			    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
					{
						score += 3;
			    	}

			    	if (t.IsHidingEntity)
			    	{
			    		score -= 3;
			    	}

					for( local i = 0; i != 6; i = ++i )
					{
						if (!t.hasNextTile(i))
						{
						}
						else
						{
							local tile = t.getNextTile(i);

							if (tile.IsOccupiedByActor)
							{
								local entity = tile.getEntity();

								if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
								{
									continue;
								}

								if (entity.isAlliedWith(_user))
								{
									if (!entity.getCurrentProperties().IsStunned)
									{
										score += this.scoreTheEntity(entity);
									}
									else 
									{
										score -= 4;
									}
									
									score += 2
								}
								else
								{
									score -= 2;
								}
							}
						}
					}
			    }
			    else
			    {
			    	if (t.Type == this.Const.Tactical.TerrainType.Swamp)
			    	{
			    		score -= 5;
			    	}

			    	if (t.Properties.Effect != null && !t.Properties.Effect.IsPositive)
					{
						score -= 3;
			    	}

			    	if (t.IsHidingEntity)
			    	{
			    		score += 3;
			    	}

					for( local i = 0; i != 6; i = ++i )
					{
						if (!t.hasNextTile(i))
						{
						}
						else
						{
							local tile = t.getNextTile(i);

							if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
							{
								local entity = tile.getEntity();
								score += this.scoreDistanceToTheNearestEnemies(tile, _target);

								if (tile.isSameTileAs(_targetTile) || tile.isSameTileAs(_userTile))
								{
									continue;
								}

								if (entity.isAlliedWith(_user))
								{
									score += 2;
								}
								else
								{
									if (entity.getCurrentProperties().IsStunned)
									{
										score += 1;
										continue;
									}

									score -= this.scoreTheEntity(entity);
									score -= 2;
								}
							}
						}
					}
			    }

			   if (score > BestScore)
				{
					BestScore = score;
					BestTarget = t;
				}
			}

			if (BestTarget != null)
			{
				return [BestTarget];
			}

			if (_tilesArray.len() != 0)
			{
				return _tilesArray;
			}

			return [];
		};
		obj.scoreTheEntity <- function( _entity ) 
		{
		    local score = 0;
		    local isAllied = _entity.isAlliedWith(this.getContainer().getActor());
		    local mult = 1.0;

		    if (isAllied)
		    {
		    	mult = _entity.getHitpointsPct();

		    	if (_entity.getHitpointsMax() < 250)
		    	{
		    		if (mult <= 0.5)
		    		{
		    			mult *= 0.67;
		    		}
		    	}
		    	else
		    	{
		    		if (mult > 0.5)
		    		{
		    			mult *= 1.25;
		    		}
		    	}
		    }

		    local meleeSkill =  _entity.getCurrentProperties().getMeleeSkill();
		    local meleeDefense = _entity.getCurrentProperties().getMeleeDefense();

			if (!_entity.isTurnDone() && _entity.getActionPoints() >= 5)
			{
				score += 2;
			}

			if (meleeSkill >= 85)
			{
				score += 1;
			}
			else if (meleeSkill >= 50)
		    {
				score = score + meleeDefense * 0.02;
			}
			else
			{
				score = score - meleeDefense * 0.02;
			}

			if (meleeDefense >= 50)
			{
				score += 1;
			}
			else if (meleeDefense >= 30)
		    {
				score = score + meleeDefense * 0.02;
			}
			else
			{
				score = score - meleeDefense * 0.02;
			}

			score = _entity.getMoraleState() == 0 ? 0 : score + _entity.getMoraleState() * 0.1;
			score = score * mult;

			if (_entity.isArmedWithRangedWeapon())
			{
				score = score + (isAllied ? -10 : 5);
			}

			if (isAllied && _entity.getCurrentProperties().TargetAttractionMult > 1.0)
			{
				score = score - _entity.getCurrentProperties().TargetAttractionMult * 1.25; 
			}

			local injuries = _entity.getSkills().query(this.Const.SkillType.Injury);
			score = score - (isAllied ? 1.35 * injuries.len() : 0);

			return score;
		};
		obj.scoreDistanceToTheNearestEnemies <- function( _tile , _target ) 
		{
			local _user = this.getContainer().getActor();
			local score = 0;
			local distance = 9999;
			local danger = 0;
		    local allEntities = this.Tactical.Entities.getAllInstancesAsArray();

			foreach( e in allEntities )
			{
				if (e.getID() == _user.getID() || e.getID() == _target.getID() || e.isAlliedWith(_user))
				{
					continue;
				}

				local d = _tile.getDistanceTo(e.getTile());

				if (d < distance)
				{
					distance = d;
					danger = this.Math.max(1, this.scoreTheEntity(e));
				}
			}

			if (distance <= 0 || danger == 0)
			{
				return 0;
			}

			score += -(danger / distance);
		    return score;
		};
		obj.onSortScoreByDescend <- function( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return 1;
			}
			else if (_a.Score < _b.Score)
			{
				return -1;
			}

			return 0;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				_properties.DamageRegularMin = 0;
				_properties.DamageRegularMax = 0;

				if (this.isUpgradeDrag())
				{
					_properties.DamageRegularMin +=  5;
					_properties.DamageRegularMax += 15;
				}

				if (this.isImprovedDrag())
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 15;
				}
			}
		};
	});


	// hyena
	::mods_hookExactClass("skills/actives/hyena_bite_skill", function ( obj )
	{
		obj.m.IsRestrained <- false;
		obj.m.IsSpent <- false;
		obj.m.IsFrenzied <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Ripping off your enemy face with your powerful hyena jaw. Can easily cause bleeding.";
			this.m.Icon = "skills/active_197.png";
			this.m.IconDisabled = "skills/active_197_sw.png";
		};
		obj.setRestrained <- function( _f )
		{
			this.m.IsRestrained = _f;
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.isUsable <- function()
		{
			return this.skill.isUsable() && !this.m.IsSpent;
		};
		obj.onTurnStart <- function()
		{
			this.m.IsSpent = false;
		};
		obj.onAdded <- function()
		{
			this.m.IsFrenzied = this.getContainer().getActor().getFlags().has("frenzy");
		};
		obj.getTooltip <- function()
		{
			local ret = this.getDefaultTooltip();
			local actor = this.getContainer().getActor().get();
			local isHigh = this.m.IsFrenzied || (("isHigh" in actor) && actor.isHigh());
			local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers;
			local damage = 5;
			if (isHigh) damage += 5;
			if (isSpecialized) damage += 5;
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts additional stacking [color=" + this.Const.UI.Color.DamageValue + "]" + damage + "[/color] bleeding damage per turn, for 2 turns"
			});
			return ret;
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onUse = function( _user, _targetTile )
		{
			if (this.m.IsRestrained)
			{
				this.m.IsSpent = true;
			}

			local target = _targetTile.getEntity();
			local hp = target.getHitpoints();
			local success = this.attackEntity(_user, _targetTile.getEntity());

			if (!_user.isAlive() || _user.isDying())
			{
				return;
			}

			if (success && target.isAlive() && !target.isDying() && !target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= this.Const.Combat.MinDamageToApplyBleeding)
			{
				_user = _user.get();
				local isHigh = this.m.IsFrenzied || (("isHigh" in _user) && _user.isHigh());
				local damage = isHigh ? 10 : 5;
				damage = _user.getCurrentProperties().IsSpecializedInCleavers ? damage + 5 : damage;
				local effect = this.new("scripts/skills/effects/bleeding_effect");
				effect.setDamage(damage);

				if (_user.getFaction() == this.Const.Faction.Player)
				{
					effect.setActor(_user);
				}

				target.getSkills().add(effect);
			}

			return success;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}

				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 35;
				_properties.DamageArmorMult *= 1.0;

				if (_properties.IsSpecializedInCleavers && !this.m.IsRestrained)
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
					_properties.DamageArmorMult += 0.1;
				}

				if (this.m.IsFrenzied && this.m.IsRestrained)
				{
					_properties.DamageTotalMult *= 1.25;
				}

				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
		obj.onUpdate = function( _properties ) {};
	});


	// white wolf
	::mods_hookExactClass("skills/actives/legend_white_wolf_bite", function ( obj )
	{
		obj.m.IsRestrained <- false;
		obj.m.IsSpent <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Ripping off your enemy face with your powerful white wolf jaw.";
			this.m.Icon = "skills/active_71.png";
			this.m.IconDisabled = "skills/active_71_sw.png";
		};
		obj.setRestrained <- function( _f )
		{
			this.m.IsRestrained = _f;
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.isUsable <- function()
		{
			return this.skill.isUsable() && !this.m.IsSpent;
		};
		obj.onTurnStart <- function()
		{
			this.m.IsSpent = false;
		};
		obj.isHidden <- function()
		{
			return this.getContainer().hasSkill("actives.werewolf_bite");
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.onAdded <- function()
		{
			this.m.ActionPointCost = this.getContainer().getActor().isPlayerControlled() ? 4 : 6;
			this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 10 : 20;
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};

		local ws_onUpdate = obj.onUpdate;
		obj.onUpdate = function( _properties )
		{
			if (!this.m.IsRestrained)
			{
				ws_onUpdate(_properties);
			}
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			if (this.m.IsRestrained) this.m.IsSpent = true;
			return ws_onUse(_user, _targetTile);
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this && this.m.IsRestrained)
			{
				_properties.DamageRegularMin += 45;
				_properties.DamageRegularMax += 75;
				_properties.DamageArmorMult += 0.8;

				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}
				
				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
	});


	// wardog
	::mods_hookExactClass("skills/actives/wardog_bite", function ( obj )
	{
		obj.m.IsRestrained <- false;
		obj.m.IsSpent <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Wardog Bite";
			this.m.Description = "Ripping off your enemy face with your powerful dog jaw. Do poorly against armor.";
			this.m.Icon = "skills/active_84.png";
			this.m.IconDisabled = "skills/active_84_sw.png";
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 5;
		};
		obj.setRestrained <- function( _f )
		{
			this.m.IsRestrained = _f;
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.isUsable <- function()
		{
			return this.skill.isUsable() && !this.m.IsSpent;
		};
		obj.onTurnStart <- function()
		{
			this.m.IsSpent = false;
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			if (this.m.IsRestrained) this.m.IsSpent = true;
			return ws_onUse(_user, _targetTile);
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}

				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 35;
				_properties.DamageArmorMult *= 0.4;
				
				if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
					_properties.DamageArmorMult *= 1.1;
				}
				
				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
		obj.onUpdate = function( _properties ) {};
	});


	// warhound
	::mods_hookExactClass("skills/actives/warhound_bite", function ( obj )
	{
		obj.m.IsRestrained <- false;
		obj.m.IsSpent <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Warhound Bite";
			this.m.Description = "Ripping off your enemy face with your powerful hound jaw. Do poorly against armor.";
			this.m.Icon = "skills/active_164.png";
			this.m.IconDisabled = "skills/active_164_sw.png";
			this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 5;
		};
		obj.setRestrained <- function( _f )
		{
			this.m.IsRestrained = _f;
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.isUsable <- function()
		{
			return this.skill.isUsable() && !this.m.IsSpent;
		};
		obj.onTurnStart <- function()
		{
			this.m.IsSpent = false;
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			if (this.m.IsRestrained) this.m.IsSpent = true;
			return ws_onUse(_user, _targetTile);
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}

				_properties.DamageRegularMin += 25;
				_properties.DamageRegularMax += 40;
				_properties.DamageArmorMult *= 0.4;
				
				if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
					_properties.DamageArmorMult *= 1.1;
				}
				
				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
		obj.onUpdate = function( _properties ) {};
	});


	// wolf
	::mods_hookExactClass("skills/actives/wolf_bite", function ( obj )
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Name = "Wolf Bite";
			this.m.Description = "Ripping off your enemy face with your powerful wolf jaw. Do poorly against armor.";
			this.m.KilledString = "Mangled";
			this.m.Icon = "skills/active_71.png";
			this.m.IconDisabled = "skills/active_71_sw.png";
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAfterUpdate <- function( _properties )
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}

				_properties.DamageRegularMin += 20;
				_properties.DamageRegularMax += 40;
				_properties.DamageArmorMult *= 0.4;
				
				if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
					_properties.DamageArmorMult *= 1.1;
				}
				
				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
		obj.onUpdate = function( _properties ) {};
	});


	// direwolf
	::mods_hookExactClass("skills/actives/werewolf_bite", function ( obj )
	{
		obj.m.IsRestrained <- false;
		obj.m.IsSpent <- false;
		obj.m.IsFrenzied <- false;

		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.Description = "Tear an enemy assunder with your teeth";
			this.m.Icon = "skills/active_71.png";
			this.m.IconDisabled = "skills/active_71_bw.png";
		};
		obj.setRestrained <- function( _f )
		{
			this.m.IsRestrained = _f;
		};
		obj.isIgnoredAsAOO <- function()
		{
			if (!this.m.IsRestrained)
			{
				return this.m.IsIgnoredAsAOO;
			}

			return !this.getContainer().getActor().isArmedWithRangedWeapon();
		};
		obj.onAdded <- function()
		{
			this.m.IsFrenzied = this.getContainer().getActor().getFlags().has("frenzy");
		};
		obj.isUsable <- function()
		{
			return this.skill.isUsable() && !this.m.IsSpent;
		};
		obj.onTurnStart <- function()
		{
			this.m.IsSpent = false;
		};

		local ws_onUse = obj.onUse;
		obj.onUse = function( _user, _targetTile )
		{
			if (this.m.IsRestrained) this.m.IsSpent = true;
			return ws_onUse(_user, _targetTile);
		};
		obj.canDoubleGrip <- function()
		{
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			return main != null && off == null && main.isDoubleGrippable();
		};
		obj.getTooltip <- function()
		{
			return this.getDefaultTooltip();
		};
		obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
		{
			if (_skill == this)
			{
				local items = this.getContainer().getActor().getItems();
				local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mhand != null)
				{
					_properties.DamageRegularMin -= mhand.m.RegularDamage;
					_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
					_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
					_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
				}

				_properties.DamageRegularMin += 30;
				_properties.DamageRegularMax += 50;
				_properties.DamageArmorMult *= 0.7;

				if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
				{
					_properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
					_properties.DamageArmorMult += 0.1;
				}

				if (this.m.IsFrenzied && this.m.IsRestrained)
				{
					_properties.DamageTotalMult *= 1.25;
				}

				if (this.canDoubleGrip())
				{
					_properties.DamageTotalMult /= 1.25;
				}
			}
		};
		obj.onUpdate = function( _properties ) {};
	});

	delete this.Nggh_MagicConcept.hookActives;
}