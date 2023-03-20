// fix lightning storm can only be used by lich
::mods_hookExactClass("ai/tactical/behaviors/ai_lightning_storm", function ( obj )
{
	obj.selectBestTarget = function( _entity, _targets )
	{
		local size = ::Tactical.getMapSize();
		local scores = [];
		scores.resize(size.X);

		for( local i = 0; i < scores.len(); i = ++i )
		{
			scores[i] = {
				Score = 0.0,
				X = i
			};
		}

		local entities = ::Tactical.Entities.getInstancesOfFaction(_entity.getFaction());

		foreach( e in entities )
		{
			local skill = e.getSkills().getSkillByID("actives.lightning_storm");

			if (skill != null && skill.getTiles().len() != 0)
			{
				scores[skill.getTiles()[0].SquareCoords.X].Score = -999999.0;
			}
		}

		foreach( target in _targets )
		{
			if (target.Actor.getType() == ::Const.EntityType.Wardog || target.Actor.getType() == ::Const.EntityType.ArmoredWardog || target.Actor.getType() == ::Const.EntityType.Warhound)
			{
				continue;
			}

			local x = target.Actor.getTile().SquareCoords.X;
			local score = this.queryTargetValue(_entity, target.Actor, this.m.Skill);

			if (target.Actor.getCurrentProperties().IsStunned || target.Actor.getCurrentProperties().IsRooted)
			{
				score = score * ::Const.AI.Behavior.LightningStormStunnedTargetMult;
			}

			if (target.Actor.getTile().hasZoneOfControlOtherThan(target.Actor.getAlliedFactions()))
			{
				score = score * ::Const.AI.Behavior.LightningStormTargetInZOCMult;
			}

			scores[x].Score += score;
		}

		scores.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});

		if (scores[0].Score > 0)
		{
			return ::Tactical.getTileSquare(scores[0].X, 15);
		}
		else
		{
			return null;
		}
	};
});