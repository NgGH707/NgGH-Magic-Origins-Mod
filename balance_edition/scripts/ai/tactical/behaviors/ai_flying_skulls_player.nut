this.ai_flying_skulls_player <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		Tiles = [],
		Skulls = 0,
		Skill = null,
		PossibleSkills = [
			"actives.flying_skulls"
		],
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.FlyingSkulls;
		this.m.Order = this.Const.AI.Behavior.Order.FlyingSkulls;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Tiles = [];
		this.m.Skill = null;
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		this.m.Skill = _entity.getSkills().getSkillByID(this.m.PossibleSkills[0]);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local faction = _entity.getFaction();
		local entities = this.Tactical.Entities.getInstancesOfFaction(faction == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : faction);
		local skulls = 0;
		local phylacteries = 3; // spawn 10 skulls per wave
		//phylacteries = 2; spawn 11 skulls per wave
		//phylacteries = 1; spawn 12 skulls per wave

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.FlyingSkull)
			{
				skulls = ++skulls;
			}
		}

		if (skulls >= 12)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		this.m.Skulls = this.Math.min(12, this.Math.min(4 + this.Math.max(0, 9 - phylacteries), 12 + this.Math.max(0, 9 - phylacteries) * 2 - skulls));
		
		if (this.m.Skulls <= 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();
		local tiles = [];
		local mapSize = this.Tactical.getMapSize();

		for( local x = 1; x < mapSize.X - 1; x = ++x )
		{
			for( local y = 1; y < mapSize.Y - 1; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					tiles.push({
						Tile = tile,
						Score = 0.0
					});
				}
			}
		}

		if (tiles.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local opponents = this.getAgent().getKnownOpponents();

		foreach( t in tiles )
		{
			local tile = t.Tile;
			local score = 0.0;
			local farthest = 9000;

			foreach( target in opponents )
			{
				local targetTile = target.Actor.getTile();
				local d = t.Tile.getDistanceTo(targetTile);

				if (d <= 4)
				{
					score = score - 10.0;
				}

				if (d < farthest)
				{
					farthest = d;
				}
			}

			if (farthest > 6)
			{
				score = score - farthest;
			}

			t.Score = score;
		}

		tiles.sort(this.onSortByScore);

		if (tiles[0].Score <= -10.0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Tiles = tiles;
		//return this.Const.AI.Behavior.Score.MirrorImage * scoreMult;
		return this.Const.AI.Behavior.Score.Zero * scoreMult;
	}

	function onExecute( _entity )
	{
		if (this.m.Tiles.len() != 0 && this.m.Skulls > 0)
		{
			local originalFaction = _entity.getFaction()
			local faction = originalFaction == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : originalFaction;

			for(local i = 0; i < this.m.Skulls;)
			{
				local tile = this.m.Tiles.remove(0).Tile;
				tile.addVisibilityForFaction(originalFaction);
				tile.addVisibilityForCurrentEntity();
				local tag = {
					User = _entity,
					Tile = tile
				};
				this.Tactical.CameraDirector.pushMoveToTileEvent(100 + i * 300, tile, -1, function(_tag) 
				{
					local skull = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/flying_skull", _tag.Tile.Coords.X, _tag.Tile.Coords.Y);
					skull.getFlags().set("creator", _tag.User.getID());
					skull.setFaction(faction);
					skull.addMoreHP(_entity);
				}.bindenv(this), tag, 200, this.Const.Tactical.Settings.CameraNextEventDelay + 100);
				this.Tactical.CameraDirector.addDelay(0.2);

				if (this.m.Tiles.len() == 0)
				{
					break;
				}

				i = ++i;
			}

			this.m.Tiles = [];
			return true;
		}

		return false
	}

	function onSortByScore( _a, _b )
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
	}

});

