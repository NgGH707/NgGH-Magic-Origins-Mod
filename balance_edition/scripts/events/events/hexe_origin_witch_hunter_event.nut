this.hexe_origin_witch_hunter_event <- this.inherit("scripts/events/event", {
	m = {
		DifficultyMult = 0.0,
		DifficultyMultScale = 0.0,
		ChampionChance = 0,
		ResourceBoost = 0,
		Town = null,
		Hexe = null,
	},
	function create()
	{
		this.m.ID = "event.witch_hunter";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;

		this.m.Screens.push({
			ID = "Encounter",
			Text = "[img]gfx/ui/events/event_07.png[/img]A man steps out onto the road. More start to materialize behind him. Well-armed with eyes focus on you. %SPEECH_ON%Foul witch! Your tricks can\'t fool us who serve as the Lord Hammer. Good men from %townname% have spoken about your devious deeds. Gossip or truth, everything is cleared now.%SPEECH_OFF%Dogs of the Church, such flith are corrupted no differ than myself dare to challenge me. The man speaks more.%SPEECH_ON%In the name of the Lord, we shall smite you heretics. Prepare to receive your jugdment.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You will regret for crossing my path.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded purge");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Auto;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Auto;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.MC_WitchHunter, (100 + _event.m.ResourceBoost) * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy, _event.m.ChampionChance);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Text = "[img]gfx/ui/events/event_12.png[/img]Arrows suddenly rain from nowhere. A band of men surround you from all side. They are screaming out.%SPEECH_ON%Kill the witch! Burn that heretic!%SPEECH_OFF%%SPEECH_START%For the safety of %townname%, let that witch be purged.%SPEECH_OFF%This is no doubt an ambush from witch hunters.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You evaded purge");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.MC_WitchHunter, (100 + _event.m.ResourceBoost) * _event.m.DifficultyMult * _event.m.DifficultyMultScale, this.Const.Faction.Enemy, _event.m.ChampionChance);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
			],
			function start( _event )
			{
				if (this.Math.rand(1, 80) > _event.m.Hexe.getCurrentProperties().getRangedDefense())
				{
					local _i = this.Const.Injury.PiercingBody;
					_i.extend(this.Const.Injury.PiercingHead);
					local injury = _event.m.Hexe.addInjury(_i);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Hexe.getName() + " is hit by arrow, suffers " + injury.getNameOnly()
					});
					_event.m.Hexe.worsenMood(1.0, "Injured by ambush");
					this.Characters.push(_event.m.Hexe.getImagePath());
				}
				
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

				while (bro.getID() == _event.m.Hexe.getID())
				{
					bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				}

				if (this.Math.rand(1, 80) > bro.getCurrentProperties().getRangedDefense())
				{
					local _i = this.Const.Injury.PiercingBody;
					_i.extend(this.Const.Injury.PiercingHead);
					local injury = bro.addInjury(_i);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " is hit by arrow, suffers " + injury.getNameOnly()
					});
					bro.worsenMood(1.0, "Injured by ambush");
				}
			}

		});
	}

	function onUpdateScore()
	{
		//return;

		if (this.World.getTime().Days < 30)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local Hexe = 0;

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("Hexe"))
			{
				++Hexe;
			}
		}

		if (Hexe == 0)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary())
			{
				continue;
			}

			local faction = t.getFactionOfType(this.Const.FactionType.Settlement);

			if (faction != null && faction.isAlliedWithPlayer())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 9)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Score = 15 * (Hexe + 1);
	}

	function onDetermineStartScreen()
	{
		local currentTile = this.World.State.getPlayer().getTile();
		local terrain = [
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.Mountains,
		];

		if (!this.World.getTime().IsDaytime)
		{
			return "Ambush";
		}

		if (terrain.find(currentTile.Type) != null)
		{
			return "Ambush";
		}

		return "Encounter";
	}

	function onPrepare()
	{
		this.calcDifficultyMult();
		this.m.ResourceBoost = this.calcResourceBoost();
		this.m.DifficultyMultScale = this.getScaledDifficultyMult();
		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearest = 9999;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary())
			{
				continue;
			}

			local faction = t.getFactionOfType(this.Const.FactionType.Settlement);

			if (faction != null && faction.isAlliedWithPlayer())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= nearest)
			{
				nearest = d;
				town = t;
			}
		}

		this.m.Town = town;

		local brothers = this.World.getPlayerRoster().getAll();

		foreach (b in brothers)
		{
			if (!b.getFlags().has("isBonus") && (b.getBackground().getID() == "background.hexen_commander" || b.getFlags().has("Hexe")))
			{
				this.m.Hexe = b;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.DifficultyMult = 0.0;
		this.m.DifficultyMultScale = 0.0;
		this.m.ResourceBoost = 0;
		this.m.Town = null;
	}

	function calcDifficultyMult()
	{
		local r;

		if (this.World.getTime().Days < 20)
		{
			r = this.Math.rand(1, 30);
		}
		else if (this.World.getTime().Days < 40)
		{
			r = this.Math.rand(1, 80);
		}
		else
		{
			r = this.Math.rand(1, 100);
		}

		if (r <= 30)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.ChampionChance = 1;
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.ChampionChance += this.getAdditionalChampionChance() + this.World.Assets.m.ChampionChanceAdditional;
	}

	function getAdditionalChampionChance()
	{
		if (this.World.getTime().Days < 50)
		{
			return 0;
		}
		else if (this.World.getTime().Days < 90)
		{
			return 1;
		}
		else
		{
			return 3;
		}
	}

	function getScaledDifficultyMult()
	{
		local s = this.Math.maxf(0.75, 0.9 * this.Math.pow(0.01 * this.World.State.getPlayer().getStrength(), 0.85));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function calcResourceBoost()
	{
		local defaultBoost = -10;
		local dayModifier = this.Math.min(this.World.getTime().Days / 5, 30);
		return defaultBoost + dayModifier;
	}

});

