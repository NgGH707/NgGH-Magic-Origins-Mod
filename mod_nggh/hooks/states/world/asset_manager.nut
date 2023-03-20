::mods_hookNewObject("states/world/asset_manager", function ( obj )
{	
	local ws_update = obj.update;
	obj.update = function( _worldState )
	{
		if (::World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
		{
			foreach( bro in ::World.getPlayerRoster().getAll() )
			{
				local NineLives = bro.getSkills().getSkillByID("perk.nine_lives");

				if (NineLives != null && ::World.getTime().Hours % 16 == 0)
				{
					NineLives.restoreLife();
				}

				// certain characters can have better hp regeneration
				if (bro.getHitpoints() < bro.getHitpointsMax() && bro.getFlags().has("bonus_regen") && bro.getBonusHealthRecoverMult() > 0.0)
				{
					bro.setHitpoints(::Math.minf(bro.getHitpointsMax(), bro.getHitpoints() + ::Const.World.Assets.HitpointsPerHour * bro.getBonusHealthRecoverMult() * ::Const.Difficulty.HealMult[::World.Assets.getEconomicDifficulty()] * this.m.HitpointsPerHourMult));
				}
				
				// for character with natural armor
				if (bro.getFlags().has("regen_armor"))
				{
					bro.restoreArmor();
				}
			}

			if (::World.getTime().Hours % 4 == 0 && this.getOrigin().getID() == "scenario.hexe")
			{
				this.checkSuicide();
			}
		}

		ws_update(_worldState);
	};
	
	obj.checkSuicide <- function()
	{
		if (!::World.Events.canFireEvent())
		{
			return;
		}

		local deserting_chance = ::World.Flags.get("isExposed") ? 75 : 10;
		local roster = ::World.getPlayerRoster().getAll();
		local candidates = [];
		local deserters = [];

		foreach( bro in roster )
		{
			if (bro.getFlags().has("IsPlayerCharacter"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("effects.fake_charmed_broken") && ::Math.rand(1, 100) <= deserting_chance)
			{
				deserters.push(bro);
			}

			if (bro.getMood() < 1.0 && ::Math.rand(1, 100) <= (1.0 - bro.getMood()) * 115)
			{
				candidates.push(bro);
			}
		}

		if (deserters.len() != 0) 
		{
			local bro = ::MSU.Array.rand(deserters);

			if (::World.getPlayerRoster().getSize() > 1)
			{
				local event = ::World.Events.getEvent("event.desertion");
				event.setDeserter(bro);
				::World.Events.fire("event.desertion", false);
			}
			else
			{
				::World.State.showGameFinishScreen(false);
			}
		}
		else if (candidates.len() != 0)
		{
			local bro = ::MSU.Array.rand(candidates);

			if (::World.getPlayerRoster().getSize() > 1)
			{
				local event = ::World.Events.getEvent("event.suicide");
				event.setSuicider(bro);
				::World.Events.fire("event.suicide", false);
			}
			else
			{
				::World.State.showGameFinishScreen(false);
			}
		}
	}
	
});