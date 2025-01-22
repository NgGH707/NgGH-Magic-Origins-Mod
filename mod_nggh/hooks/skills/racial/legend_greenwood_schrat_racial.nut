::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/legend_greenwood_schrat_racial", function(q) 
{
	//obj.m.DamRec <- 0.3;
	q.m.IsPlayer <- false;
	q.m.HPThresholdToProc <- 0.067;
	q.m.ChanceToSpawn <- 25;
	q.m.Script <- "enemies/legend_greenwood_schrat_small";

	q.getDamageRec <- function()
	{
		return !m.IsPlayer || !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 0.3 : 0.85;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Name = "Living Heartwood";
		m.Description = "As guardians of the forest, a Heartwood Schrat has an incredibly resilient body that no other wood can match. Any part of its broken body part could grow into a living schrat too.";
		m.Icon = "skills/status_effect_86.png";
		m.IconMini = "status_effect_86_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
		//m.DamRec = !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 0.3 : 0.85;
	}

	q.onAdded <- function()
	{
		m.IsPlayer = ::MSU.isKindOf(getContainer().getActor(), "player");

		if (m.IsPlayer)
			m.Script = "minions/nggh_mod_legend_greenwood_schrat_small_minion";
	}

	q.getTooltip <- function()
	{
		local actor = getContainer().getActor();
		local perk = getContainer().getSkillByID("perk.sapling");
		local chance = m.ChanceToSpawn + (perk != null ? perk.getBonus() : 0);
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.round((1.0 - getDamageRec()) * 100) + "%[/color] less damage if is equipped with a shield"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]" + chance + "%[/color] to spawn a \'Greenwood Sapling\' after taking at least [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(actor.getHitpointsMax() * m.HPThresholdToProc) + "[/color] hitpoint damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is [color=" + ::Const.UI.Color.PositiveValue + "]resistant[/color] against ranged or piercing Damage"
			},
		];
	}

	q.isHidden = @(__original) function()
	{
		return !::Tactical.isActive() ? false : __original();
	}

	q.onUpdate = @() function( _properties )
	{
		if (getContainer().getActor().isArmedWithShield())
			_properties.DamageReceivedTotalMult *= getDamageRec();
	}

	q.onDamageReceived = @() function( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = getContainer().getActor();
		local mult = m.IsPlayer ? m.HPThresholdToProc : 0.01;

		if (_damageHitpoints >= actor.getHitpointsMax() * mult) {
			local candidates = [];
			local myTile = actor.getTile();

			for( local i = 0; i < 6; ++i )
			{
				if (!myTile.hasNextTile(i))
					continue;

				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsEmpty && ::Math.abs(myTile.Level - nextTile.Level) <= 1)
					candidates.push(nextTile);
			}

			if (candidates.len() != 0) {
				local perk = getContainer().getSkillByID("perk.sapling");
				local bonus = perk != null ? perk.getBonus() : 0;

				if (m.IsPlayer && ::Math.rand(1, 100) > m.ChanceToSpawn + bonus) return;

				local sapling = ::Tactical.spawnEntity("scripts/entity/tactical/" + m.Script, ::MSU.Array.rand(candidates).Coords);
				sapling.setFaction(m.IsPlayer ? ::Const.Faction.PlayerAnimals : actor.getFaction());

				if (m.IsPlayer && perk) {
					sapling.setMaster(actor);
					sapling.makeControllable();
				}

				sapling.riseFromGround();
			}
		}
	};
});