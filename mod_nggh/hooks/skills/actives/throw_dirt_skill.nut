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
						ColorMin = ::createColor("eeeeee00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = ::createVec(-0.7, -0.6),
						DirectionMax = ::createVec(-0.6, -0.6),
						SpawnOffsetMin = ::createVec(-35, -15),
						SpawnOffsetMax = ::createVec(35, 20)
					},
					{
						LifeTimeMin = 0.75,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("eeeeeeee"),
						ColorMax = ::createColor("ffffffff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = ::createColor("eeeeee00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = ::createVec(0, -100),
						ForceMax = ::createVec(0, -100)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(30, 70));
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
						ColorMin = ::createColor("eeeeee00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = ::createVec(0.6, -0.6),
						DirectionMax = ::createVec(0.7, -0.6),
						SpawnOffsetMin = ::createVec(-35, -15),
						SpawnOffsetMax = ::createVec(35, 20)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.25,
						ColorMin = ::createColor("eeeeeeee"),
						ColorMax = ::createColor("ffffffff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = ::createColor("eeeeee00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = ::createVec(0, -100),
						ForceMax = ::createVec(0, -100)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(-30, 70));
		}

		_targetTile.getEntity().getSkills().add(::new("scripts/skills/effects/distracted_effect"));
		::Tactical.getShaker().shake(_targetTile.getEntity(), _user.getTile(), 4);

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " throws dirt in " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "\'s face to distract them");
		}

		return true;
	};
});