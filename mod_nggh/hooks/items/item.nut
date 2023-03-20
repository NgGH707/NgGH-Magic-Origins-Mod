::mods_hookBaseClass("items/item", function(obj) 
{
    obj = obj[obj.SuperName];

    local onEquipRuneSigil = obj.onEquipRuneSigil;
  	obj.onEquipRuneSigil = function()
	{
		onEquipRuneSigil();

		switch(this.m.RuneVariant)
		{
		case 100:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSH_shielding"));
			break;

		case 101:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSW_unstable"));
			break;

		case 102:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSA_thorns"));
			break;

		case 103:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSA_repulsion"));
			break;

		case 104:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSW_corrosion"));
			break;

		case 105:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSW_lucky"));
			break;

		case 106:
			this.addSkill(this.new("scripts/skills/rune_sigils/nggh_mod_RSS_brimstone"));
			break;

		case 107:
			this.addSkill(this.new("scripts/skills/rune_sigils/mod_RSH_night_vision"));
			break;

		default:
			break;
		}
	}

	local getRuneSigilTooltip = obj.getRuneSigilTooltip;
	obj.getRuneSigilTooltip = function()
	{
		switch(this.m.RuneVariant)
		{
		case 100:
			return "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + this.Const.UI.Color.PositiveValue + "]Protective Barrier[/color] that can repel physical attacks.";
		
		case 101:
			return "This item has the power of the rune sigil of Unstable:\nAttacks have [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] to either deal triple or a third of the original damage.";
		
		case 102:
			return "This item has the power of the rune sigil of Thorns:\n[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to your armor.\nReflect [color=" + this.Const.UI.Color.PositiveValue + "]35[/color]-[color=" + this.Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
		
		case 103:
			return "This item has the power of the rune sigil of Repulsion:\n[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + this.Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";

		case 104:
			return "This item has the power of the rune sigil of Corrosion:\n[color=" + this.Const.UI.Color.PositiveValue + "]1 to 2[/color] turn(s) of acid applied, which capable of destroying [color=" + this.Const.UI.Color.NegativeValue + "]10%[/color] of affected target\'s armor per turn.";
		
		case 105:
			return "This item has the power of the rune sigil of Lucky:\nKilled enemy has [color=" + this.Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] to drop a random item, you may get a free named item if you are super lucky!";
		
		case 106:
			return "This item has the power of the rune sigil of Brimstone:\n[color=" + this.Const.UI.Color.PositiveValue + "]Immune[/color] to fire, gain [color=" + this.Const.UI.Color.NegativeValue + "]+10[/color] Fatigue recovery per turn and a slight damage reduction while standing on fire.";

		case 107:
			return "This item has the power of the rune sigil of Night Vision:\nNot affected by [color=" + this.Const.UI.Color.PositiveValue + "]Nighttime[/color] effect";
		}

		return getRuneSigilTooltip();
	}

	local updateRuneSigilToken = obj.updateRuneSigilToken;
	obj.updateRuneSigilToken = function()
	{
		updateRuneSigilToken();

		switch(this.m.RuneVariant)
		{
		case 100:
			this.m.Name = "Helmet Rune Sigil: Shielding";
			this.m.Description = "An inscribed rock that can be attached to a character\'s helmet.";
			this.m.Icon = "rune_sigils/rune_stone_2.png";
			this.m.IconLarge = "rune_sigils/rune_stone_2.png";
			break;

		case 101:
			this.m.Name = "Weapon Rune Sigil: Unstable";
			this.m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			this.m.Icon = "rune_sigils/rune_stone_1.png";
			this.m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 102:
			this.m.Name = "Armor Rune Sigil: Thorns";
			this.m.Description = "An inscribed rock that can be attached to a character\'s armor.";
			this.m.Icon = "rune_sigils/rune_stone_3.png";
			this.m.IconLarge = "rune_sigils/rune_stone_3.png";
			break;

		case 103:
			this.m.Name = "Armor Rune Sigil: Repulsion";
			this.m.Description = "An inscribed rock that can be attached to a character\'s armor.";
			this.m.Icon = "rune_sigils/rune_stone_3.png";
			this.m.IconLarge = "rune_sigils/rune_stone_3.png";
			break;

		case 104:
			this.m.Name = "Weapon Rune Sigil: Corrosion";
			this.m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			this.m.Icon = "rune_sigils/rune_stone_1.png";
			this.m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 105:
			this.m.Name = "Weapon Rune Sigil: Lucky";
			this.m.Description = "An inscribed rock that can be attached to a character\'s weapon.";
			this.m.Icon = "rune_sigils/rune_stone_1.png";
			this.m.IconLarge = "rune_sigils/rune_stone_1.png";
			break;

		case 106:
			this.m.Name = "Shield Rune Sigil: Brimstone";
			this.m.Description = "An inscribed rock that can be attached to a character\'s shield.";
			this.m.Icon = "rune_sigils/rune_stone_4.png";
			this.m.IconLarge = "rune_sigils/rune_stone_4.png";
			break;

		case 107:
			this.m.Name = "Helmet Rune Sigil: Night Vision";
			this.m.Description = "An inscribed rock that can be attached to a character\'s helmet.";
			this.m.Icon = "rune_sigils/rune_stone_2.png";
			this.m.IconLarge = "rune_sigils/rune_stone_2.png";
			break;
		}
	};
});