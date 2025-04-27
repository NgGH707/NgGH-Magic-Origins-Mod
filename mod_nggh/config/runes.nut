// rune effects
local effectsDefs = [];

::Legends.Effect.NgGHRswCorrosion <- null;
effectsDefs.push({
	ID = "special.mod_RSW_corrosion",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_corrosion",
	Name = "Rune Sigil: Corrosion",
	Const = "NgGHRswCorrosion"
});

::Legends.Effect.NgGHRswLucky <- null;
effectsDefs.push({
	ID = "special.mod_RSW_lucky",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_lucky",
	Name = "Rune Sigil: Lucky",
	Const = "NgGHRswLucky"
});

::Legends.Effect.NgGHRswUnstable <- null;
effectsDefs.push({
	ID = "special.mod_RSW_unstable",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_unstable",
	Name = "Rune Sigil: Unstable",
	Const = "NgGHRswUnstable"
});

::Legends.Effect.NgGHRshNightVision <- null;
effectsDefs.push({
	ID = "special.mod_RSH_night_vision",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSH_night_vision",
	Name = "Rune Sigil: Night Vision",
	Const = "NgGHRshNightVision"
});

::Legends.Effect.NgGHRsaRepulsion <- null;
effectsDefs.push({
	ID = "special.mod_RSA_repulsion",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSA_repulsion",
	Name = "Rune Sigil: Repulsion",
	Const = "NgGHRsaRepulsion"
});

::Legends.Effect.NgGHRshShielding <- null;
effectsDefs.push({
	ID = "special.magic_shield",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSH_shielding",
	Name = "Magic Barrier",
	Const = "NgGHRshShielding"
});

::Legends.Effect.NgGHRsaThorns <- null;
effectsDefs.push({
	ID = "special.mod_RSA_thorns",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSA_thorns",
	Name = "Rune Sigil: Thorns",
	Const = "NgGHRsaThorns"
});

::Legends.Effect.NgGHRssBrimstone <- null;
effectsDefs.push({
	ID = "effects.mod_RSS_brimstone",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSS_brimstone",
	Name = "Rune Sigil: Brimstone",
	Const = "NgGHRssBrimstone"
});

::Legends.Effects.addEffectDefObjects(effectsDefs);


// rune defs
::Legends.Rune.NgGHRswCorrosion <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Weapon Rune Sigil: Corrosion",
	Description = "An inscribed rock that can be attached to a character\'s weapon.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswCorrosion,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Corrosion:\n[color=" + ::Const.UI.Color.PositiveValue + "]1 to 2[/color] turn(s) of acid applied, which capable of destroying [color=" + ::Const.UI.Color.NegativeValue + "]10%[/color] of affected target\'s armor per turn.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Corrosion:\n[color=" + ::Const.UI.Color.PositiveValue + "]1 to 2[/color] turn(s) of acid applied, which capable of destroying [color=" + ::Const.UI.Color.NegativeValue + "]10%[/color] of affected target\'s armor per turn.";
	}
});

::Legends.Rune.NgGHRswLucky <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Weapon Rune Sigil: Fortune",
	Description = "An inscribed rock that can be attached to a character\'s weapon.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswLucky,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Fortune:\nKilled enemy has [color=" + ::Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] to drop a random item, you may get a free named item if you are super lucky!";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Fortune:\nKilled enemy has [color=" + ::Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] to drop a random item, you may get a free named item if you are super lucky!";
	}
});

::Legends.Rune.NgGHRswUnstable <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Weapon Rune Sigil: Unstable",
	Description = "An inscribed rock that can be attached to a character\'s weapon.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswUnstable,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Unstable:\nAttacks have [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] to either deal triple or a third of the original damage.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Unstable:\nAttacks have [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] to either deal triple or a third of the original damage.";
	}
});

::Legends.Rune.NgGHRshNightVision <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Helmet,
	Name = "Helmet Rune Sigil: Night Vision",
	Description = "An inscribed rock that can be attached to a character\'s helmet.",
	Icon = "rune_sigils/rune_stone_2.png",
	IconLarge = "rune_sigils/rune_stone_2.png",
	Effect = ::Legends.Effect.NgGHRshNightVision,
	Script = "scripts/items/legend_helmets/runes/nggh_mod_rune_night_vision",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Night Vision:\nNot affected by [color=" + ::Const.UI.Color.PositiveValue + "]Nighttime[/color] effect.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Night Vision:\nNot affected by [color=" + ::Const.UI.Color.PositiveValue + "]Nighttime[/color] effect";
	}
});

::Legends.Rune.NgGHRshShielding <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Helmet,
	Name = "Helmet Rune Sigil: Shielding",
	Description = "An inscribed rock that can be attached to a character\'s helmet.",
	Icon = "rune_sigils/rune_stone_2.png",
	IconLarge = "rune_sigils/rune_stone_2.png",
	Effect = ::Legends.Effect.NgGHRshShielding,
	Script = "scripts/items/legend_helmets/runes/nggh_mod_rune_shielding",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + ::Const.UI.Color.PositiveValue + "]Protective Barrier[/color] that can repel physical attacks.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + ::Const.UI.Color.PositiveValue + "]Protective Barrier[/color] that can repel physical attacks.";
	}
});

::Legends.Rune.NgGHRsaRepulsion <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Armor,
	Name = "Armor Rune Sigil: Repulsion",
	Description = "An inscribed rock that can be attached to a character\'s armor.",
	Icon = "rune_sigils/rune_stone_3.png",
	IconLarge = "rune_sigils/rune_stone_3.png",
	Effect = ::Legends.Effect.NgGHRsaRepulsion,
	Script = "scripts/items/legend_armor/runes/nggh_mod_rune_repulsion",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";
	}
});

::Legends.Rune.NgGHRsaThorns <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Armor,
	Name = "Armor Rune Sigil: Thorns",
	Description = "An inscribed rock that can be attached to a character\'s armor.",
	Icon = "rune_sigils/rune_stone_3.png",
	IconLarge = "rune_sigils/rune_stone_3.png",
	Effect = ::Legends.Effect.NgGHRsaThorns,
	Script = "scripts/items/legend_armor/runes/nggh_mod_rune_thorns",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to your armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
	}
});

::Legends.Rune.NgGHRssBrimstone <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Shield,
	Name = "Shield Rune Sigil: Brimstone",
	Description = "An inscribed rock that can be attached to a character\'s shield.",
	Icon = "rune_sigils/rune_stone_4.png",
	IconLarge = "rune_sigils/rune_stone_4.png",
	Effect = ::Legends.Effect.NgGHRssBrimstone,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "This item has the power of the rune sigil of Brimstone:\n[color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to fire, gain [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] Fatigue recovery per turn and a slight damage reduction while standing on fire.";
	}
	getRuneTooltip = function (_item) {
		return "This item has the power of the rune sigil of Brimstone:\n[color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to fire, gain [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] Fatigue recovery per turn and a slight damage reduction while standing on fire.";
	}
});