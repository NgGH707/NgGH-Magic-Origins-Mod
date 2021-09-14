this.scroll_of_unlimited_wisdom_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.wisdom_scroll";
		this.m.Name = "Scroll of Unlimited Wisdom";
		this.m.Description = "A scroll created from unnatural means, it's somehow being able to open the mind of its reader, with a gift of knowlegde that the reader hasn't learnt. It's even being able to open then mind of the most foolish one";
		this.m.Icon = "consumables/scroll_of_unlimited_wisdom.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Grants Magical Knowlegde"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can also remove Dumb trait"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to read. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/perfect_focus_01.wav", this.Const.Sound.Volume.Inventory);
		local Mage = _actor.getSkills().getSkillByID("trait.magic_caster");
		
		if (Mage != null)
		{
			if (Mage.IsBlessed())
			{
				_actor.m.LevelUps += 1;
				_actor.fillAttributeLevelUpValues(1, true);
			}
			else
			{
				Mage.onBless();
				_actor.m.PerkPoints += 1;
			}
		}
		else
		{
			if (_actor.getSkills().getSkillByID("trait.dumb") != null)
			{
				_actor.getSkills().removeByID("trait.dumb");
			}
			
			local perks = _actor.m.PerkPointsSpent;
			local hasStudent = false;

			if (_actor.getLevel() >= 11 && _actor.getSkills().hasSkill("perk.student"))
			{
				perks = perks - 1;
				hasStudent = true;
			}

			_actor.m.PerkPoints += perks;
			_actor.m.PerkPointsSpent = hasStudent ? 1 : 0;
			_actor.getSkills().removeByType(this.Const.SkillType.Perk);

			if (hasStudent)
			{
				_actor.getSkills().add(this.new("scripts/skills/perks/perk_student"));
			}
			
			_actor.m.LevelUps += 1;
			_actor.fillAttributeLevelUpValues(1, true);
		}
		
		return true;
	}

});