this.getroottable().Nggh_MagicConcept.hookWorldScenarios <- function ()
{
	::mods_hookNewObject("scenarios/scenario_manager", function ( obj )
	{
		local s = this.new("scripts/entity/tactical/minions/special/dev_files/nggh_dev_scenario");
		obj.m.Scenarios.push(s);
	});


	//
	::mods_hookExactClass("scenarios/world/legends_risen_legion_scenario", function(obj) 
	{
		local ws_create = obj.create;
		obj.create = function()
		{
			ws_create();
			this.m.StartingRosterTier = this.Const.Roster.getTierForSize(13);
		};
		local ws_onSpawnAssets = obj.onSpawnAssets;
		obj.onSpawnAssets = function()
		{
			ws_onSpawnAssets();
			local roster = this.World.getPlayerRoster()
			local lich = roster.create("scripts/entity/tactical/undead_player");
			lich.setStartAsBoss(this.Const.Necro.UndeadBossType.SkeletonLich);
			lich.m.HireTime = this.Time.getVirtualTimeF();
			lich.setVeteranPerks(2);
		};
	});


	//
	::mods_hookExactClass("scenarios/world/legends_necro_scenario", function(obj) 
	{
		local ws_onSpawnAssets = obj.onSpawnAssets;
		obj.onSpawnAssets = function()
		{
			ws_onSpawnAssets();
			local roster = this.World.getPlayerRoster();
			local bro;

			foreach ( b in roster.getAll() )
			{
				if (b.getSkills().hasSkill("trait.legend_rotten_flesh"))
				{
					bro = b;
					break;
				}
			}

			if (bro != null)
			{
				roster.remove(bro);
			}
			
			bro = roster.create("scripts/entity/tactical/undead_player");
			bro.setStartValuesEx();
			bro.getBackground().m.RawDescription = "Once a proud necromancer, %name% took three pupils under their wing to train the next generation of great necromancers. What %name% did not seeing coming is a heart attack - one that left them like a corpse like they used to command. With this macabre irony in mind, they now serve their students in unlife as little more than fodder.";
			bro.getBackground().buildDescription(true);
			bro.setPlaceInFormation(12);
			bro.setVeteranPerks(2);

			if (this.Math.rand(1, 100) <= 40)
			{
				bro = roster.create("scripts/entity/tactical/ghost_player");
				bro.setStartValuesEx();
				bro.getBackground().m.RawDescription = "Once a proud necromancer, %name% took three pupils under their wing to train the next generation of great necromancers. What %name% did not seeing coming is a heart attack - one that left them like a corpse like they used to command. With this macabre irony in mind, they now serve their students in unlife as little more than fodder.";
				bro.getBackground().buildDescription(true);
				bro.setPlaceInFormation(13);
				bro.setVeteranPerks(2);
				this.World.Assets.getStash().add(this.new("scripts/items/misc/petrified_scream_item"));
			}
		}

		local ws_onUpdateDraftList = obj.onUpdateDraftList;
		obj.onUpdateDraftList = function( _list, _gender = null )
		{
			ws_onUpdateDraftList(_list, _gender);

			while(_list.find("legend_puppet_background") != null)
			{
				_list.remove(_list.find("legend_puppet_background"));
			}
		};

		local ws_onHiredByScenario = obj.onHiredByScenario;
		obj.onHiredByScenario = function( bro )
		{
			if (bro.getFlags().has("undead"))
			{
				bro.getSprite("socket").setBrush("bust_base_undead");
			}
			else
			{
				ws_onHiredByScenario(bro);
			}
		};

		local ws_onUpdateHiringRoster = obj.onUpdateHiringRoster;
		obj.onUpdateHiringRoster = function( _roster )
		{
			ws_onUpdateHiringRoster(_roster);
			local chance = 20;

			for (local i = 0; i < 3; ++i)
			{
				if (this.Math.rand(1, 100) <= chance)
				{
					local undead = _roster.create("scripts/entity/tactical/undead_player");
					undead.setStartValuesEx();
					chance -= 5;
				}
			}
		};
	});

	delete this.Nggh_MagicConcept.hookWorldScenarios;
}