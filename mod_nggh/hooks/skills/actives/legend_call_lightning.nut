::mods_hookExactClass("skills/actives/legend_call_lightning", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Overlay = "lightning_square";
		this.m.InjuriesOnBody = ::Const.Injury.BurningBody;
		this.m.InjuriesOnHead = ::Const.Injury.BurningHead;
		this.m.MaxRange = 4;
		this.m.FatigueCost = 26;
		//this.m.IsMagicSkill = true;
		//this.m.MagicPointsCost = 3;
		//this.m.IsRequireStaff = true
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
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]25[/color] - [color=" + ::Const.UI.Color.DamageValue + "]50[/color] damage that ignores armor"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text =  "[color=" + ::Const.UI.Color.PositiveValue + "]15%[/color] chance to call lightning on each unit within [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			}
		];

		return ret;
	};
	obj.onUse = function( _user, _targetTile )
	{
		foreach (a in ::Tactical.Entities.getHostileActors(_user.getFaction(), _user.getTile(), this.getMaxRange()))
		{
			// spinkle a bit rng with 2 rand XD
			if (::Math.rand(1, 100) > ::Math.rand(15, 25))
			{
				continue;
			}

			::Time.scheduleEvent(::TimeUnit.Real, count * 30, function ( _data )
			{
				local tile = _data.Tile;

				for( local i = 0; i < ::Const.Tactical.LightningParticles.len(); i = ++i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.LightningParticles[i].Brushes, tile, ::Const.Tactical.LightningParticles[i].Delay, ::Const.Tactical.LightningParticles[i].Quantity, ::Const.Tactical.LightningParticles[i].LifeTimeQuantity, ::Const.Tactical.LightningParticles[i].SpawnRate, ::Const.Tactical.LightningParticles[i].Stages);
				}

				if ((tile.IsEmpty || tile.IsOccupiedByActor) && tile.Type != ::Const.Tactical.TerrainType.ShallowWater && tile.Type != ::Const.Tactical.TerrainType.DeepWater)
				{
					tile.clear(::Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", ::Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
				
				local target = tile.getEntity();
				local hitInfo = clone ::Const.Tactical.HitInfo;
				hitInfo.DamageRegular = ::Math.rand(25, 50);
				hitInfo.DamageArmor = 0;
				hitInfo.DamageDirect = 1.0;
				hitInfo.BodyPart = 0;
				hitInfo.FatalityChanceMult = 0.0;
				hitInfo.Injuries = ::Const.Injury.BurningBody;
				target.onDamageReceived(_data.User, _data.Skill, hitInfo);
			}, {
				Tile = t,
				Skill = this,
				User = _user
			});
		}
	};
});