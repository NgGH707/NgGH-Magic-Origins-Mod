this.nggh_mod_kraken_ensnare_skill <- ::inherit("scripts/skills/skill", {
	m = {
		DamageMult = 1.0,
	},
	function create()
	{
		this.m.ID = "actives.kraken_ensnare";
		this.m.Name = "Ensnare";
		this.m.Description = "Binding your frey with an unbearable grip and then slowy drag it to your mouth.";
		this.m.Icon = "skills/active_147.png";
		this.m.IconDisabled = "skills/active_147_sw.png";
		this.m.Overlay = "active_147";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/tentacle_disappear_01.wav",
			"sounds/enemies/dlc2/tentacle_disappear_02.wav",
			"sounds/enemies/dlc2/tentacle_disappear_03.wav",
			"sounds/enemies/dlc2/tentacle_disappear_04.wav",
			"sounds/enemies/dlc2/tentacle_disappear_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/krake_snare_01.wav",
			"sounds/enemies/dlc2/krake_snare_02.wav",
			"sounds/enemies/dlc2/krake_snare_03.wav",
			"sounds/enemies/dlc2/krake_snare_04.wav",
			"sounds/enemies/dlc2/krake_snare_05.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/dlc2/krake_break_free_fail_01.wav",
			"sounds/enemies/dlc2/krake_break_free_fail_02.wav",
			"sounds/enemies/dlc2/krake_break_free_fail_03.wav",
			"sounds/enemies/dlc2/krake_break_free_fail_04.wav",
			"sounds/enemies/dlc2/krake_break_free_fail_05.wav"
		];
		this.m.SoundOnHitArmor = [
			"sounds/enemies/dlc2/krake_break_free_success_01.wav",
			"sounds/enemies/dlc2/krake_break_free_success_02.wav",
			"sounds/enemies/dlc2/krake_break_free_success_03.wav",
			"sounds/enemies/dlc2/krake_break_free_success_04.wav",
			"sounds/enemies/dlc2/krake_break_free_success_05.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingHitchance = false;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local damage_regular_min = ::Math.floor(15 * this.m.DamageMult);
		local damage_regular_max = ::Math.floor(20 * this.m.DamageMult);
		local damage_direct_min = ::Math.floor(damage_regular_min * 0.3);
		local damage_direct_max = ::Math.floor(damage_regular_max * 0.3);
		local damage_armor_min = ::Math.floor(damage_regular_min * 1.25);
		local damage_armor_max = ::Math.floor(damage_regular_max * 1.25);

		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] damage to hitpoints, of which [color=" + ::Const.UI.Color.DamageValue + "]0[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] can ignore armor"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]" + damage_armor_min + "[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + damage_armor_max + "[/color] damage to armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			}
		]);
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && ::Tactical.TurnSequenceBar.getActiveEntity() != null && ::Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID() && !::Tactical.TurnSequenceBar.isLastEntityActive();
	}

	function onAfterUpdate( _properties )
	{
		this.m.DamageMult = _properties.IsSpecializedInNets ? 1.35 : 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToRoot)
		{
			return false;
		}

		if (_targetTile.getEntity().getType() == ::Const.EntityType.KrakenTentacle)
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local actor = this.getContainer().getActor();

		if (!actor.m.IsControlledByPlayer)
		{
			return actor.getMode() == ::Const.KrakenTentacleMode.Ensnaring;
		}
		
		return true;
	}

	function onUse( _user, _targetTile )
	{
		_user.sinkIntoGround(0.75);
		_user.getSkills().setBusy(true);
		_user.m.IsAbleToDie = false;

		::Time.scheduleEvent(::TimeUnit.Real, 800, this.onNetSpawn.bindenv(this), {
			User = _user,
			TargetEntity = _targetTile.getEntity(),
			LoseHitpoints = true,
		});
		return true;
	}

	function onNetSpawn( _data )
	{
		if (this.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _data.TargetEntity.getPos());
		}

		local ensnare = ::new("scripts/skills/effects/nggh_mod_kraken_ensnare_effect");
		ensnare.setDamageMult(this.m.DamageMult);
		ensnare.setMode(_data.User.getMode());
		ensnare.setParentID(_data.User.getParent() != null && !_data.User.getParent().isNull() ? _data.User.getParent().getID() : null);
		ensnare.setOnRemoveCallback(function ( _data )
		{
			local targetTile = _data.TargetEntity.getTile();
			local tile;
			local n = _data.User.m.BloodType;

			for( local i = 0; i < ::Const.Tactical.BloodEffects[n].len(); ++i )
			{
				::Tactical.spawnParticleEffect(false, ::Const.Tactical.BloodEffects[n][i].Brushes, targetTile, ::Const.Tactical.BloodEffects[n][i].Delay, ::Const.Tactical.BloodEffects[n][i].Quantity, ::Const.Tactical.BloodEffects[n][i].LifeTimeQuantity, ::Const.Tactical.BloodEffects[n][i].SpawnRate, ::Const.Tactical.BloodEffects[n][i].Stages);
			}

			if (_data.User.getParent() != null)
			{
				for( local i = 0; i < 6; i = ++i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local t = targetTile.getNextTile(i);

						if (t.IsEmpty)
						{
							tile = t;
							break;
						}
					}
				}

				if (tile == null)
				{
					local mapSize = ::Tactical.getMapSize();

					for( local attempts = 0; attempts < 500; ++attempts )
					{
						local x = ::Math.rand(5, mapSize.X - 5);
						local y = ::Math.rand(5, mapSize.Y - 5);
						local t = ::Tactical.getTileSquare(x, y);

						if (t.IsEmpty)
						{
							tile = t;
							break;
						}
					}
				}

				if (tile != null)
				{
					::Tactical.addEntityToMap(_data.User, tile.Coords.X, tile.Coords.Y);
					_data.User.updateVisibilityForFaction();

					if (_data.LoseHitpoints)
					{
						_data.User.setHitpoints(::Math.max(25, _data.User.getHitpoints() - ::Math.rand(15, 30)));
						_data.User.spawnBloodDecals(targetTile);
					}

					_data.User.m.IsAbleToDie = true;
					_data.User.riseFromGround(0.1);
					_data.User.updateMode();
				}
			}
		}, _data);
		_data.TargetEntity.getSkills().add(ensnare);
		local penalty = ::Math.max(1, _data.User.getHitpoints() * 0.1);
		local breakFree = ::new("scripts/skills/actives/break_free_skill");
		breakFree.m.Icon = "skills/active_148.png";
		breakFree.m.IconDisabled = "skills/active_148_sw.png";
		breakFree.m.Overlay = "active_148";
		breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
		breakFree.setDecal(::MSU.Array.rand(::Const.BloodDecals[::Const.BloodType.Red]));
		breakFree.setChanceBonus(-penalty);
		_data.TargetEntity.getSkills().add(breakFree);
		_data.TargetEntity.raiseRootsFromGround(_data.User.getHitpointsPct() > 0.5 ? "kraken_ensnare_front" : "kraken_ensnare_front_injured", _data.User.getMode() == 0 ? "kraken_ensnare_back" : "kraken_ensnare_back_2");
		_data.User.getSkills().setBusy(false);
		_data.User.removeFromMap();
	}

});

