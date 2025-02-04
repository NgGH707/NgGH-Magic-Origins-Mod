::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_call_lightning_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Overlay = "lightning_square";
		m.InjuriesOnBody = ::Const.Injury.BurningBody;
		m.InjuriesOnHead = ::Const.Injury.BurningHead;
		m.MaxRange = 4;
		m.FatigueCost = 30;
		//m.IsMagicSkill = true;
		//m.MagicPointsCost = 3;
		//m.IsRequireStaff = true
	}

	q.isHidden = @() function()
	{
		return skill.isHidden();
	}

	q.getTooltip = @() function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]25[/color] - [color=" + ::Const.UI.Color.DamageValue + "]50[/color] damage that ignores armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text =  "Each enemy within [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles radius has a [color=" + ::Const.UI.Color.PositiveValue + "]15%[/color] chance to to be struck by lightning"
			}
		]);
		return ret;
	}

	q.onUse = @() function( _user, _targetTile )
	{
		local count = 0;

		foreach (a in ::Tactical.Entities.getHostileActors(_user.getFaction(), _user.getTile(), getMaxRange()))
		{
			// spinkle a bit rng with 2 rand XD
			if (::Math.rand(1, 100) > ::Math.rand(15, 20))
				continue;

			++count;
			::Time.scheduleEvent(::TimeUnit.Real, count * 30, function ( _data ) {
				for( local i = 0; i < ::Const.Tactical.LightningParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.LightningParticles[i].Brushes, _data.Tile, ::Const.Tactical.LightningParticles[i].Delay, ::Const.Tactical.LightningParticles[i].Quantity, ::Const.Tactical.LightningParticles[i].LifeTimeQuantity, ::Const.Tactical.LightningParticles[i].SpawnRate, ::Const.Tactical.LightningParticles[i].Stages);
				}

				if ((_data.Tile.IsEmpty || _data.Tile.IsOccupiedByActor) && _data.Tile.Type != ::Const.Tactical.TerrainType.ShallowWater && _data.Tile.Type != ::Const.Tactical.TerrainType.DeepWater) {
					_data.Tile.clear(::Const.Tactical.DetailFlag.Scorchmark);
					_data.Tile.spawnDetail("impact_decal", ::Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
				
				local hitInfo = clone ::Const.Tactical.HitInfo;
				hitInfo.DamageRegular = ::Math.rand(25, 50);
				hitInfo.DamageArmor = 0;
				hitInfo.DamageDirect = 1.0;
				hitInfo.BodyPart = 0;
				hitInfo.FatalityChanceMult = 0.0;
				hitInfo.Injuries = ::Const.Injury.BurningBody;
				_data.Tile.getEntity().onDamageReceived(_data.User, _data.Skill, hitInfo);
			}, {
				Tile = t,
				Skill = this,
				User = _user
			});
		}
	}

});