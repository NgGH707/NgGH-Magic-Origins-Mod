this.perk_magic_training_3 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.magic_training_3";
		this.m.Name = this.Const.Strings.PerkName.MC_MagicTraining3;
		this.m.Description = this.Const.Strings.PerkDescription.MC_MagicTraining3;
		this.m.Icon = "ui/perks/perk_magic_training_3.png";
		this.m.IconMini = "perk_magic_training_3_mini";
		this.m.Overlay = "perk_magic_training_3";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getBonus()
	{
		if (this.getContainer() == null)
		{
			return 5;
		}

		local actor = this.getContainer().getActor();

		if (actor == null)
		{
			return 5;
		}

		local staff = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local mult = 1.0;

		if (staff == null || !staff.isWeaponType(this.Const.Items.WeaponType.MagicStaff))
		{
			mult = actor.getCurrentProperties().IsSpecializedInMC_Magic ? 0.67 : 0;
		}

		local bonus = actor.getBaseProperties().getBravery() * mult;
		return this.Math.max(5, this.Math.floor(bonus / 4));
	}

	function getTooltip()
	{
		local bonus = this.getBonus();
		local tooltip = this.skill.getTooltip();

		if (bonus != 0)
		{
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "You are gaining [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus + "[/color] melee skill"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "You are gaining [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus + "[/color] ranged skill"
				}
			]);
		}
		else 
		{
		    tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "You need to equip a [color=" + this.Const.UI.Color.PositiveValue + "]Magic Staff[/color] to benifit from this effect"
			});
		}
		return tooltip;
	}

	function onUpdate( _properties )
	{
		local bonus = this.getBonus();
		_properties.MeleeSkill += bonus;
		_properties.RangedSkill += bonus;
	}

});

