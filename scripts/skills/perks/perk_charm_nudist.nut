this.perk_charm_nudist <- this.inherit("scripts/skills/skill", {
	m = {
		Bonus = 5,
	},
	function create()
	{
		this.m.ID = "perk.charm_nudist";
		this.m.Name = this.Const.Strings.PerkName.CharmNudist;
		this.m.Icon = "ui/perks/perk_charm_nudist.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getBonus()
	{
		local bodyitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local headitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);

		if (bodyitem == null && headitem == null)
		{
			return this.m.Bonus;
		}

		return 0;
	}

	function isHidden()
	{
		local fm = this.Math.floor(this.getChance() * 100);
		return fm >= 100;
	}

	function getDescription()
	{
		return "True slut!!! I mean a true beauty can easily catch other\'s' heart with her body. Gain nimble if you have no clothes or helm. Stacks with nimble";
	}

	function getTooltip()
	{
		local fm = this.Math.round(this.getChance() * 100);
		local tooltip = this.skill.getTooltip();
		local bodyitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local headitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);

		if (bodyitem == null && headitem == null)
		{
			tooltip.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "]" + fm + "%[/color] of any damage to hitpoints from attacks"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Increases chance to charm a target by [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color]"
				},
			]);
		}
		else
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character isn\'t nude.[/color]"
			});
		}

		return tooltip;
	}

	function getChance()
	{
		return 0.4;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		local bodyitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local headitem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);

		if (bodyitem != null || headitem != null)
		{
			return;
		}

		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		local chance = this.getChance();
		_properties.DamageReceivedRegularMult *= chance;
	}

});

