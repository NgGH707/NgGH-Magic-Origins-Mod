::Nggh_MagicConcept.HooksMod.hook("scripts/items/weapons/weapon", function(q) 
{
  	q.onEquipRuneSigil <- function()
	{
		item.onEquipRuneSigil();

		switch(m.RuneVariant)
		{
		case 100:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSH_shielding"));
			break;

		case 101:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSW_unstable"));
			break;

		case 102:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSA_thorns"));
			break;

		case 103:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSA_repulsion"));
			break;

		case 104:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSW_corrosion"));
			break;

		case 105:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSW_lucky"));
			break;

		case 106:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSS_brimstone"));
			break;

		case 107:
			addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSH_night_vision"));
			break;

		default:
			break;
		}
	}

	q.getRuneSigilTooltip <- function()
	{
		switch(m.RuneVariant)
		{
		case 100:
			return "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + ::Const.UI.Color.PositiveValue + "]Protective Barrier[/color] that can repel physical attacks.";
		
		case 101:
			return "This item has the power of the rune sigil of Unstable:\nAttacks have [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] to either deal triple or a third of the original damage.";
		
		case 102:
			return "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to your armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
		
		case 103:
			return "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";

		case 104:
			return "This item has the power of the rune sigil of Corrosion:\n[color=" + ::Const.UI.Color.PositiveValue + "]1 to 2[/color] turn(s) of acid applied, which capable of destroying [color=" + ::Const.UI.Color.NegativeValue + "]10%[/color] of affected target\'s armor per turn.";
		
		case 105:
			return "This item has the power of the rune sigil of Lucky:\nKilled enemy has [color=" + ::Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] to drop a random item, you may get a free named item if you are super lucky!";
		
		case 106:
			return "This item has the power of the rune sigil of Brimstone:\n[color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to fire, gain [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] Fatigue recovery per turn and a slight damage reduction while standing on fire.";

		case 107:
			return "This item has the power of the rune sigil of Night Vision:\nNot affected by [color=" + ::Const.UI.Color.PositiveValue + "]Nighttime[/color] effect";
		}

		return item.getRuneSigilTooltip();
	}

	q.updateRuneSigilToken <- function()
	{
		item.updateRuneSigilToken();

		switch(m.RuneVariant)
		{
		case 100:
			m.Name = "Helmet Rune Sigil: Shielding";
			m.Description = "An inscribed rock that can be attached to a character\'s helmet.";
			m.Icon = "rune_sigils/rune_stone_2.png";
			m.IconLarge = "rune_sigils/rune_stone_2.png";
			break;

		case 101:
			m.Name = "Weapon Rune Sigil: Unstable";
			m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			m.Icon = "rune_sigils/rune_stone_1.png";
			m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 102:
			m.Name = "Armor Rune Sigil: Thorns";
			m.Description = "An inscribed rock that can be attached to a character\'s armor.";
			m.Icon = "rune_sigils/rune_stone_3.png";
			m.IconLarge = "rune_sigils/rune_stone_3.png";
			break;

		case 103:
			m.Name = "Armor Rune Sigil: Repulsion";
			m.Description = "An inscribed rock that can be attached to a character\'s armor.";
			m.Icon = "rune_sigils/rune_stone_3.png";
			m.IconLarge = "rune_sigils/rune_stone_3.png";
			break;

		case 104:
			m.Name = "Weapon Rune Sigil: Corrosion";
			m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			m.Icon = "rune_sigils/rune_stone_1.png";
			m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 105:
			m.Name = "Weapon Rune Sigil: Lucky";
			m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			m.Icon = "rune_sigils/rune_stone_1.png";
			m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 106:
			m.Name = "Shield Rune Sigil: Brimstone";
			m.Description = "An inscribed rock that can be attached to a character\'s shield.";
			m.Icon = "rune_sigils/rune_stone_4.png";
			m.IconLarge = "rune_sigils/rune_stone_4.png";
			break;

		case 107:
			m.Name = "Helmet Rune Sigil: Night Vision";
			m.Description = "An inscribed rock that can be attached to a character\'s helmet.";
			m.Icon = "rune_sigils/rune_stone_2.png";
			m.IconLarge = "rune_sigils/rune_stone_2.png";
			break;
		}
	}
	
});