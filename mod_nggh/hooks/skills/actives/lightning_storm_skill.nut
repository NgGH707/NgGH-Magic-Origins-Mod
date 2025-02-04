::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/lightning_storm_skill", function(q) 
{
	q.getAffectedTiles = function( _targetTile )
	{
		local ret = [], size = ::Tactical.getMapSize(), styles = [1, 2, 3, 4];
		local last_attack_style = ::Tactical.Entities.getFlags().getAsInt("LightningStrikesStyle");

		if (last_attack_style != 0)
			styles.remove(styles.find(last_attack_style));

		local choose = ::MSU.Array.rand(styles);
		::Tactical.Entities.getFlags().set("LightningStrikesStyle", choose);
		switch (choose)
		{
		case 1:
			// vertical
			for( local y = 0; y < size.Y; ++y )
			{
				local tile = ::Tactical.getTileSquare(_targetTile.SquareCoords.X, y);

				if (tile.IsEmpty || tile.IsOccupiedByActor)
					ret.push(tile);
			}
			break;

		case 2:
			// horizonal
			for( local x = 0; x < size.X; ++x )
			{
				local tile = ::Tactical.getTileSquare(x, _targetTile.SquareCoords.Y);

				if (tile.IsEmpty || tile.IsOccupiedByActor)
					ret.push(tile);

				ret.push(tile);
			}
			break;

		case 3:
			// diagonal up
			local NE_tile = _targetTile.hasNextTile(::Const.Direction.NE) ? _targetTile.getNextTile(::Const.Direction.NE) : null;
			local SW_tile = _targetTile.hasNextTile(::Const.Direction.SW) ? _targetTile.getNextTile(::Const.Direction.SW) : null;

			if (NE_tile != null) {
				local next = _targetTile.SquareCoords.Y != NE_tile.SquareCoords.Y;
				local y = NE_tile.SquareCoords.Y;

				for( local x = NE_tile.SquareCoords.X; x >= 0; --x )
				{
					local tile = ::Tactical.getTileSquare(x, y);

					if (tile.IsEmpty || tile.IsOccupiedByActor)
						ret.push(tile);

					if (next) --y;

					next = !next;
				}
			}

			if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
				ret.push(_targetTile);

			if (SW_tile != null) {
				local next = _targetTile.SquareCoords.Y != SW_tile.SquareCoords.Y;
				local y = SW_tile.SquareCoords.Y;

				for( local x = SW_tile.SquareCoords.X; x < size.X; ++x )
				{
					local tile = ::Tactical.getTileSquare(x, y);

					if (tile.IsEmpty || tile.IsOccupiedByActor)
						ret.push(tile);

					if (next) ++y;

					next = !next;
				}
			}
			break;

		case 4:
			// diagonal down
			local NW_tile = _targetTile.hasNextTile(::Const.Direction.NW) ? _targetTile.getNextTile(::Const.Direction.NW) : null;
			local SE_tile = _targetTile.hasNextTile(::Const.Direction.SE) ? _targetTile.getNextTile(::Const.Direction.SE) : null;

			if (NW_tile != null) {
				local next = _targetTile.SquareCoords.Y != NW_tile.SquareCoords.Y;
				local y = NW_tile.SquareCoords.Y;

				for( local x = NW_tile.SquareCoords.X; x >= 0; --x )
				{
					local tile = ::Tactical.getTileSquare(x, y);

					if (tile.IsEmpty || tile.IsOccupiedByActor)
						ret.push(tile);

					if (!next) ++y;

					next = !next;
				}
			}

			if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
				ret.push(_targetTile);

			if (SE_tile != null) {
				local next = _targetTile.SquareCoords.Y != SE_tile.SquareCoords.Y;
				local y = SE_tile.SquareCoords.Y;

				for( local x = SE_tile.SquareCoords.X; x < size.X; ++x )
				{
					local tile = ::Tactical.getTileSquare(x, y);

					if (tile.IsEmpty || tile.IsOccupiedByActor)
						ret.push(tile);

					if (!next) --y;

					next = !next;
				}
			}

			break;	
		}

		return ret;
	}

	q.onImpact = function( _tag )
	{
		::Tactical.EventLog.log("Lightning strikes the battlefield");
		::Tactical.getCamera().quake(::createVec(0, -1.0), 6.0, 0.16, 0.35);
		local actor = getContainer().getActor();

		foreach( i, t in _tag.m.AffectedTiles )
		{
			::Time.scheduleEvent(::TimeUnit.Real, i * 30, function ( _data ) {
				for( local i = 0; i < ::Const.Tactical.LightningParticles.len(); i = ++i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.LightningParticles[i].Brushes, _data.Tile, ::Const.Tactical.LightningParticles[i].Delay, ::Const.Tactical.LightningParticles[i].Quantity, ::Const.Tactical.LightningParticles[i].LifeTimeQuantity, ::Const.Tactical.LightningParticles[i].SpawnRate, ::Const.Tactical.LightningParticles[i].Stages);
				}

				_data.Tile.clear(::Const.Tactical.DetailFlag.SpecialOverlay);
				_data.Tile.Properties.IsMarkedForImpact = false;

				if ((_data.Tile.IsEmpty || _data.Tile.IsOccupiedByActor) && _data.Tile.Type != ::Const.Tactical.TerrainType.ShallowWater && _data.Tile.Type != ::Const.Tactical.TerrainType.DeepWater) {
					_data.Tile.clear(::Const.Tactical.DetailFlag.Scorchmark);
					_data.Tile.spawnDetail("impact_decal", ::Const.Tactical.DetailFlag.Scorchmark, false, true);
				}

				if (_data.Tile.IsOccupiedByActor) {
					local target = _data.Tile.getEntity();
					local isLich = _data.User.getType() == ::Const.EntityType.SkeletonLichMirrorImage || _data.User.getType() == ::Const.EntityType.SkeletonLich;
					local isTargetHexe = target.getType() == ::Const.EntityType.Hexe || target.getType() == ::Const.EntityType.LegendHexeLeader;
					local isHexe = _data.User.getType() == ::Const.EntityType.Hexe || _data.User.getType() == ::Const.EntityType.LegendHexeLeader;
					local isAllied = _data.User.isAlliedWith(target);

					if ((_data.User.getID() == target.getID()) || (isLich && isAllied) || (isAllied && isHexe && isTargetHexe))
						return;

					local hitInfo = clone ::Const.Tactical.HitInfo;
					hitInfo.DamageRegular = ::Math.rand(25, 50) * (isAllied ? 0.5 : 1.0);
					hitInfo.DamageArmor = hitInfo.DamageRegular;
					hitInfo.DamageDirect = 0.75;
					hitInfo.BodyPart = 0;
					hitInfo.FatalityChanceMult = 0.0;
					hitInfo.Injuries = ::Const.Injury.BurningBody;
					target.onDamageReceived(_data.User, _data.Skill, hitInfo);
				}
			}, {
				Tile = t,
				Skill = this,
				User = actor
			});
		}

		if (_tag.m.HasCooldownAfterImpact)
			_tag.m.Cooldown = 1;

		_tag.m.AffectedTiles = [];
		::Tactical.Entities.getFlags().set("LightningStrikesActive", ::Math.max(0, ::Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
	}

	q.onAnySkillUsed = function( _skill, _targetEntity, _properties )
	{
		if (_skill == this) {
			_properties.DamageRegularMin = 25;
			_properties.DamageRegularMax = 50;
			_properties.DamageArmorMult = 1.0;
		}
	}
});