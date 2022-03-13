this.mod_RSW_lucky <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSW_lucky";
		this.m.Name = "Rune Sigil: Lucky";
		this.m.Description = "Rune Sigil: Lucky";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null || _targetEntity.getXPValue() <= 0)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local chance = this.Math.floor(_targetEntity.getXPValue() / this.Const.MC_Combat.LuckyRuneChanceModifier);
		local rolled = this.Math.rand(1, 100);
		
		if (rolled > chance)
		{
			this.Tactical.EventLog.log("Hope you get lucky next time " + " (Chance: " + chance + ", Rolled: " + rolled + ")");
		}
		else
		{
			local tile = _targetEntity.getTile();
			local index = this.LegendsMod.Configs().LegendArmorsEnabled() ? 1 : 0;
			local luck_table = this.Const.LuckyRuneLootTable[index];
			this.MSU.Array.shuffle(luck_table); // more randomness

			local pick = this.Const.World.Common.pickItem(luck_table);
			this.MSU.Array.shuffle(pick); // more randomness

			local item = this.new("scripts/items/" + this.MSU.Array.getRandom(pick));
			local name = item.getName();

			for( local i = 0; i < this.Const.Tactical.DazeParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DazeParticles[i].Brushes, tile, this.Const.Tactical.DazeParticles[i].Delay, this.Const.Tactical.DazeParticles[i].Quantity, this.Const.Tactical.DazeParticles[i].LifeTimeQuantity, this.Const.Tactical.DazeParticles[i].SpawnRate, this.Const.Tactical.DazeParticles[i].Stages);
			}

			//item.drop(tile);
			tile.Items.push(item);
			tile.IsContainingItems = true;
			item.m.Tile = tile;
			this.Tactical.EventLog.logEx("[color=" + this.Const.UI.Color.NegativeValue + "]Wow!!![/color] you get [color=#0b0084]" + name + "[/color] as bonus loot due to " + this.Const.UI.getColorizedEntityName(actor) + "\'s Lucky rune");
		}
	}

});

