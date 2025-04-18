nggh_mod_RSW_lucky <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRswLucky);
		m.Description = "Rune Sigil: Lucky";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!m.IsForceEnabled && (this.getItem() == null || _targetEntity.getXPValue() <= 0))
			return;

		local actor = this.getContainer().getActor();
		local chance = ::Math.min(100, ::Math.floor(_targetEntity.getXPValue() / ::Const.LuckyRuneChanceModifier));
		local rolled = ::Math.rand(1, 100);
		
		if (rolled > chance) {
			::Tactical.EventLog.log("Hope you get lucky next time " + " (Chance: " + chance + ", Rolled: " + rolled + ")");
			return;
		}
		
		local tile = _targetEntity.getTile();
		//local weight_container_name = ::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() ? "_Vanilla" : "";
		local pick = ::Const.LuckyRuneLootWeightContainer_Legends.roll();
		local item = ::new("scripts/items/" + ::MSU.Array.rand(pick));

		for( local i = 0; i < ::Const.Tactical.DazeParticles.len(); ++i )
		{
			::Tactical.spawnParticleEffect(false, ::Const.Tactical.DazeParticles[i].Brushes, tile, ::Const.Tactical.DazeParticles[i].Delay, ::Const.Tactical.DazeParticles[i].Quantity, ::Const.Tactical.DazeParticles[i].LifeTimeQuantity, ::Const.Tactical.DazeParticles[i].SpawnRate, ::Const.Tactical.DazeParticles[i].Stages);
		}

		//item.drop(tile);
		tile.Items.push(item);
		tile.IsContainingItems = true;
		item.m.Tile = tile;
		::Tactical.EventLog.logEx("[color=" + ::Const.UI.Color.NegativeValue + "]Wow!!![/color] you get [color=#0b0084]" + item.getName() + "[/color] as a drop from " + ::Const.UI.getColorizedEntityName(actor) + "\'s Lucky rune");
	}

});

