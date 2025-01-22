::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) 
{
	q.m.RandomizedFactor <- null;

	q.spawn = @(__original) function( _properties )
	{
		local all_players = _properties.IsUsingSetPlayers ? _properties.Players : ::World.getPlayerRoster().getAll();

		foreach(p in all_players)
		{
			p.onBeforeCombatStarted();
		}

		__original(_properties);
	}

	q.setupEntity = @(__original) function( _e, _t )
	{
		__original(_e, _t);
		local update = false;

		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("randomize_stats_is_enabled").getValue() && !_e.isNonCombatant() && ::Math.rand(1, 100) <= ::Nggh_MagicConcept.RandomizedStatsMode.Chance) {
			local b = _e.m.BaseProperties;
			foreach(key in ::Const.StatsToRandomized)
			{
				b[key] = ::Math.ceil(b[key] * ::Math.rand(m.RandomizedFactor.Min, m.RandomizedFactor.Max) * 0.01);
			}

			update = true;
		}

		_e.getItems().onCombatStarted();
		_e.getSkills().onCombatStarted();

		if (update)
			_e.setHitpointsPct(1.0);
	}

	q.calculateRandomizedStatsScaling <- function()
	{
		local days = ::World.getTime().Days, ret = {
			Min = ::Nggh_MagicConcept.RandomizedStatsMode.Min,
			Max = ::Nggh_MagicConcept.RandomizedStatsMode.Max,
		};

		switch(true)
		{
		case days <= 50:
			break;

		case days <= 110:
			ret.Max += 3;
			break

		case days <= 170:
			ret.Max += 5;
			break;

		case days <= 230:
			ret.Min += 3;
			ret.Max += 8;
			break;

		default:
			ret.Min += 5;
			ret.Max += 10;
		}

		m.RandomizedFactor = ret;
	}
	
});