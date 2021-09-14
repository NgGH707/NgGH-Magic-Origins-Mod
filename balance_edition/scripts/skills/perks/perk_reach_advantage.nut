this.perk_reach_advantage <- this.inherit("scripts/skills/skill", {
	m = {
		Stacks = 0
	},
	function create()
	{
		this.m.ID = "perk.reach_advantage";
		this.m.Name = this.Const.Strings.PerkName.ReachAdvantage;
		this.m.Description = this.Const.Strings.PerkDescription.ReachAdvantage;
		this.m.Icon = "ui/perks/perk_19.png";
		this.m.IconMini = "perk_19_mini";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function getDescription()
	{
		return "This character is using the superior reach of their melee weapon to keep opponents at bay, increasing Melee Defense by [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.Stacks * 5 + "[/color] until their next turn.";
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.getContainer().getActor().getFlags().has("lindwurm") && _skill != null && _skill.getID() != "actives.spit_acid")
		{
			this.m.Stacks = this.Math.min(this.m.Stacks + 1, 5);
			return;
		}

		if (!this.getContainer().getActor().getCurrentProperties().IsAbleToUseWeaponSkills)
		{
			return;
		}

		local weapon = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon) && weapon.isItemType(this.Const.Items.ItemType.TwoHanded))
		{
			this.m.Stacks = this.Math.min(this.m.Stacks + 1, 5);
		}
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Stacks == 0;
		local weapon = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon) && weapon.isItemType(this.Const.Items.ItemType.TwoHanded))
		{
			_properties.MeleeDefense += this.m.Stacks * 5;
		}
		else if (this.getContainer().getActor().getFlags().has("lindwurm")) 
		{
			_properties.MeleeDefense += this.m.Stacks * 5;
		}
		else
		{
			this.m.Stacks = 0;
		}
	}

	function onTurnStart()
	{
		this.m.Stacks = 0;
		this.m.IsHidden = true;
	}

	function onCombatStarted()
	{
		this.m.Stacks = 0;
		this.m.IsHidden = true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.IsHidden = true;
	}

});

