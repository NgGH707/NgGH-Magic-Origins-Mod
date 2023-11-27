::mods_hookExactClass("skills/actives/legend_chain_lightning", function(obj) 
{
	obj.m.MinBaseDamage <- 15;
	obj.m.MaxBaseDamage <- 40;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		//this.m.IsMagicSkill = true;
		//this.m.MagicPointsCost = 3;
		//this.m.IsRequireStaff = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 2;
		this.m.MaxRange = 5;
	}

	obj.getTooltip = function()
	{
		local ret = this.getDefaultUtilityTooltip();

		local rangeBonus = ", more";
		if (this.m.MaxRangeBonus == 0)
			rangeBonus = " or";
		else if (this.m.MaxRangeBonus < 0)
			rangeBonus = ", less";

		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + this.m.MinBaseDamage + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + this.m.MaxBaseDamage + "[/color] damage that ignores armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground" + rangeBonus + " if shooting downhill"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Chains up to 2 more additional targets"
			}
		]);

		if (!this.getContainer().getActor().isArmedWithMagicStaff())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character must be equipped with a magic staff[/color]"
			});
		}
		else if (::Tactical.isActive() && this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	// this skill is so mess up so i fix this with a cleaner code
	obj.applyEffect = function( _data, _delay )
	{
		this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay, function ( _data )
		{
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); ++i )
			{
				this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, _data.TargetTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
		}, _data);

		if (_data.Target == null)
			return;

		this.Time.scheduleEvent(this.TimeUnit.Virtual, _delay + 200, function ( _data )
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = ::Math.rand(this.m.MinBaseDamage, this.m.MaxBaseDamage);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_data.Target.onDamageReceived(_data.User, _data.Skill, hitInfo);
		}.bindenv(this), _data);
	}
	obj.onUse = function( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local selectedTargets = [];
		local targetTile = _targetTile;
		local target = targetTile.getEntity();
		selectedTargets.push(target.getID());

		if (this.m.SoundOnLightning.len() != 0)
			::Sound.play(::MSU.Array.rand(this.m.SoundOnLightning), ::Const.Sound.Volume.Skill * 2.0, _user.getPos());

		this.applyEffect({
			Skill = this,
			User = _user,
			TargetTile = targetTile,
			Target = target
		}, 100);
		
		local potentialTiles, potentialTargets;

		for (local i = 1; i <= 2; ++i)
		{
			potentialTiles = this.searchTiles(targetTile, myTile);
			potentialTargets = this.searchTargets(_user , potentialTiles, selectedTargets);

			if (potentialTargets.len() != 0)
			{
				target = ::MSU.Array.rand(potentialTargets).getEntity();
				selectedTargets.push(target.getID());
				targetTile = target.getTile();
			}
			else
			{
				target = null;
				targetTile = ::MSU.Array.rand(potentialTiles);
			}

			this.applyEffect({
				Skill = this,
				User = _user,
				TargetTile = targetTile,
				Target = target
			}, i * 200 + 150);
		}

		return true;
	}
	obj.searchTiles <- function( _tile, _originTile )
	{
		local ret = [];

		for( local i = 0; i < 6; ++i )
		{
			if (!_tile.hasNextTile(i))
				continue;

			local tile = _tile.getNextTile(i);

			if (!_originTile.isSameTileAs(tile))
				ret.push(tile);
		}

		return ret;
	}
	obj.searchTargets <- function( _user , _tiles , _excluded )
	{
		local ret = [];

		foreach( tile in _tiles )
		{
			if (!tile.IsOccupiedByActor ||
				!tile.getEntity().isAttackable() ||
				tile.getEntity().isAlliedWith(_user) ||
				_excluded.find(tile.getEntity().getID()) != null)
				continue;
			
			ret.push(tile);
		}

		return ret;
	}
});