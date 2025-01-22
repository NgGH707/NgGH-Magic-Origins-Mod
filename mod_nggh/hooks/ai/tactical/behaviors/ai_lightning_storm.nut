// fix lightning storm can only be used by lich
::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/behaviors/ai_lightning_storm", function ( q )
{
	q.selectBestTarget = @() function( _entity, _targets )
	{
		local scores = [], size = ::Tactical.getMapSize()
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
				scores[skill.getTiles()[0].SquareCoords.X].Score = -999999.0;
		}

		foreach( target in _targets )
		{
			if (target.Actor.getType() == ::Const.EntityType.Wardog || target.Actor.getType() == ::Const.EntityType.ArmoredWardog || target.Actor.getType() == ::Const.EntityType.Warhound)
				continue;

			local x = target.Actor.getTile().SquareCoords.X;
			local score = queryTargetValue(_entity, target.Actor, m.Skill);

			if (target.Actor.getCurrentProperties().IsStunned || target.Actor.getCurrentProperties().IsRooted)
				score *= ::Const.AI.Behavior.LightningStormStunnedTargetMult;

			if (target.Actor.getTile().hasZoneOfControlOtherThan(target.Actor.getAlliedFactions()))
				score *= ::Const.AI.Behavior.LightningStormTargetInZOCMult;

			scores[x].Score += score;
		}

		scores.sort(@ (_a, _b) _a.Score <=> _b.Score)
		return scores[0].Score > 0 ? ::Tactical.getTileSquare(scores[0].X, 15) : null;
	}
	
});