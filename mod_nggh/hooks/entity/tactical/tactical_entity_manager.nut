::mods_hookNewObject("entity/tactical/tactical_entity_manager", function (obj) 
{
	obj.m.RandomizedFactor <- null;

	local ws_spawn = obj.spawn;
	obj.spawn = function( _properties )
	{
		local all_players = _properties.IsUsingSetPlayers ? _properties.Players : ::World.getPlayerRoster().getAll();

		foreach(p in all_players)
		{
			p.onBeforeCombatStarted();
		}

		ws_spawn(_properties);
	}

	local ws_setupEntity = obj.setupEntity;
	obj.setupEntity = function( _e, _t )
	{
		ws_setupEntity(_e, _t);
		local isChanged = false;

		if (::Nggh_MagicConcept.RandomizedStatsMode.IsEnabled && !_e.isNonCombatant() && ::Math.rand(1, 100) <= ::Nggh_MagicConcept.RandomizedStatsMode.Chance)
		{
			local b = _e.m.BaseProperties;
			
			foreach(key in ::Const.StatsToRandomized)
			{
				b[key] = ::Math.ceil(b[key] * ::Math.rand(this.m.RandomizedFactor.Min, this.m.RandomizedFactor.Max) * 0.01);
			}

			isChanged = true;
		}

		_e.getItems().onCombatStarted();
		_e.getSkills().onCombatStarted();
		_e.getSkills().update();

		if (isChanged)
		{
			_e.setHitpointsPct(1.0);
		}
	}

	obj.calculateRandomizedStatsScaling <- function()
	{
		local days = ::World.getTime().Days;
		local ret = {
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

		this.m.RandomizedFactor = ret;
	}
});