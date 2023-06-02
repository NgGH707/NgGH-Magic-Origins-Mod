this.nggh_mod_hexe_origin_witch_hunter_event <- ::inherit("scripts/events/event", {
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
		this.m.Cooldown = 21.0 * ::World.getTime().SecondsPerDay;

		this.m.Screens.push({
			ID = "Encounter",
			Text = "[img]gfx/ui/events/event_07.png[/img]A man steps out onto the road. More start to materialize behind him. Well-armed with eyes focus on you. %SPEECH_ON%Foul witch! Your tricks can\'t fool us who serve as the Lord Hammer. Good men from %townname% have spoken about your devious deeds. Gossip or truth, everything is cleared now.%SPEECH_OFF%Dogs of the Church, such flith are corrupted no differ than myself dare to challenge me. The man speaks more.%SPEECH_ON%In the name of the Lord, we shall smite you heretics. Prepare to receive your divine jugdment.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You will regret for crossing my path.",
					function getResult( _event )
					{
						local playerTile = ::World.State.getPlayer().getTile();
						local spawnTile;
						local tries = 0;

						while (++tries < 250)
						{
							local x = ::Math.rand(playerTile.SquareCoords.X - 3, playerTile.SquareCoords.X + 3);
							local y = ::Math.rand(playerTile.SquareCoords.Y - 3, playerTile.SquareCoords.Y + 3);

							if (!::World.isValidTileSquare(x, y))
							{
								continue;
							}

							local tile = ::World.getTileSquare(x, y);

							if (tile.Type == ::Const.World.TerrainType.Impassable || tile.Type == ::Const.World.TerrainType.Ocean)
							{
								continue;
							}

							spawnTile = tile; 
							break;
						}

						if (spawnTile == null)
						{
							spawnTile = playerTile;
						}
						
						_event.spawnWitchHunterParty(spawnTile);
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
						_event.spawnWitchHunterParty(::World.State.getPlayer().getTile());
						return 0;
					}

				},
			],
			function start( _event )
			{
				local _i = [];
				_i.extend(::Const.Injury.PiercingBody);
				_i.extend(::Const.Injury.PiercingHead);

				if (::Math.rand(1, 80) > _event.m.Hexe.getCurrentProperties().getRangedDefense())
				{
					local injury = _event.m.Hexe.addInjury(_i);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Hexe.getName() + " is hit by arrow, suffers " + injury.getNameOnly()
					});
					_event.m.Hexe.worsenMood(1.0, "Injured by an ambush");
					this.Characters.push(_event.m.Hexe.getImagePath());
				}
				
				local brothers = ::World.getPlayerRoster().getAll();

				if (brothers.len() == 1) return;

				local bro = ::MSU.Array.rand(brothers);

				while (bro.getID() == _event.m.Hexe.getID())
				{
					bro = ::MSU.Array.rand(brothers);
				}

				if (::Math.rand(1, 80) > bro.getCurrentProperties().getRangedDefense())
				{
					local injury = bro.addInjury(_i);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " is hit by arrow, suffers " + injury.getNameOnly()
					});
					bro.worsenMood(1.0, "Injured by an ambush");
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (::World.getTime().Days < 25)
		{
			return;
		}

		local Hexe = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
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

		local playerTile = ::World.State.getPlayer().getTile();
		local towns = ::World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || ::isKindOf(t, "city_state"))
			{
				continue;
			}

			local faction = t.getFactionOfType(::Const.FactionType.Settlement);

			if (faction == null)
			{
				continue;
			}
			else if (faction.getPlayerRelation() >= 90.0)
			{
				continue;
			}

			if (playerTile.getDistanceTo(t.getTile()) <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Score = 22 * Hexe;
	}

	function onDetermineStartScreen()
	{
		if (!::World.getTime().IsDaytime)
		{
			return "Ambush";
		}

		if ([
			::Const.World.TerrainType.Swamp,
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.SnowyForest,
			::Const.World.TerrainType.Mountains,
		].find(::World.State.getPlayer().getTile().Type) != null)
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
		local playerTile = ::World.State.getPlayer().getTile();
		local towns = ::World.EntityManager.getSettlements();
		local nearest = 9999;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || ::isKindOf(t, "city_state"))
			{
				continue;
			}

			local faction = t.getFactionOfType(::Const.FactionType.Settlement);

			if (faction != null)
			{
				if (faction.getPlayerRelation() >= 90.0)
				{
					continue;
				}
			}
			else
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < nearest)
			{
				nearest = d;
				town = t;
			}
		}

		this.m.Town = town;

		foreach (b in ::World.getPlayerRoster().getAll())
		{
			if (b.getFlags().has("Hexe"))
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

	function spawnWitchHunterParty( _tile )
	{
		::World.State.setPause(true);
		local faction = this.m.Town.getFactionOfType(::Const.FactionType.Settlement);
		
		if (faction == null)
		{
			faction = ::World.FactionManager.getFaction(this.m.Town.getFaction());
		}

		local party = faction.spawnEntity(_tile, "Witch Hunters", false, null, 0);
		local template = ::Const.World.Common.buildDynamicTroopList(::Const.World.Spawn.Nggh_WitchHunter, this.getResources());
		local troopMbMap = {};

		party.getSprite("banner").setBrush(this.m.Town.getBanner());
		party.getSprite("body").setBrush(template.Body);
		party.setMovementSpeed(::Const.World.MovementSettings.Speed * template.MovementSpeedMult);
		party.setVisibilityMult(template.VisibilityMult);
		party.setVisionRadius(::Const.World.Settings.Vision * template.VisionMult);
		party.setDescription("Brave men sent from [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Town.getName() + "[/color] to vanquish heretics.");
		party.setFootprintType(::Const.World.FootprintsType.Militia);
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.setUsingGlobalVision(true);
		party.getFlags().set("WitchHunters", true);
		party.getLoot().Money = ::Math.rand(100, 200);
		party.getLoot().ArmorParts = ::Math.rand(0, 25);
		party.getLoot().Medicine = ::Math.rand(0, 5);
		party.getLoot().Ammo = ::Math.rand(0, 30);

		foreach( troop in template.Troops )
		{
			local key = "Enemy" + troop.Type.ID;
			if (!(key in troopMbMap))
			{
				troopMbMap[key] <- ::Const.LegendMod.GetFavEnemyBossChance(troop.Type.ID);
			}

			local mb = troopMbMap[key];

			for( local i = 0; i != troop.Num; i = ++i )
			{
				::Const.World.Common.addTroop(party, troop, false, this.m.ChampionChance + mb);
			}
		}

		faction.addPlayerRelation(-faction.getPlayerRelation() + 10, "Heretics");
		party.updatePlayerRelation();
		party.updateStrength();
		local c = party.getController();
		c.getBehavior(::Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local attack = ::new("scripts/ai/world/orders/intercept_order");
		attack.setTarget(::World.State.getPlayer());
		c.addOrder(attack);
	}

	function calcDifficultyMult()
	{
		local r;

		if (::World.getTime().Days < 20)
		{
			r = ::Math.rand(1, 30);
		}
		else if (::World.getTime().Days < 40)
		{
			r = ::Math.rand(1, 80);
		}
		else
		{
			r = ::Math.rand(1, 100);
		}

		if (r <= 30)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = ::Math.rand(75, 90) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.ChampionChance = 1;
			this.m.DifficultyMult = ::Math.rand(100, 115) * 0.01;
		}
		else
		{
			this.m.ChampionChance = 4;
			this.m.DifficultyMult = ::Math.rand(125, 140) * 0.01;
		}

		this.m.ChampionChance += this.getAdditionalChampionChance();
	}

	function getAdditionalChampionChance()
	{
		if (::World.getTime().Days < 50)
		{
			return 0;
		}
		else if (::World.getTime().Days < 90)
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
		return ::Math.minf(5.0, ::Math.maxf(0.75, ::Math.pow(0.01 * ::World.State.getPlayer().getStrength(), 0.85))) * ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
	}

	function getResources()
	{
		return (100 + this.m.ResourceBoost) * this.m.DifficultyMult * this.m.DifficultyMultScale;
	}

	function calcResourceBoost()
	{
		local defaultBoost = 25;
		local dayModifier = ::Math.min(::World.getTime().Days / 5, 50);
		return defaultBoost + dayModifier;
	}

});

