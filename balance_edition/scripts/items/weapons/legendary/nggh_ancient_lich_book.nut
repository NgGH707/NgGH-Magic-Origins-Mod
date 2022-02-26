this.nggh_ancient_lich_book <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.nggh_ancient_lich_book";
		this.m.Name = "The Black Book";
		this.m.Description = "An old and eerie looking tome with a fleshen cover. Its pages are filled with inscrutable writing and mysterious drawings that you can\'t begin to understand. The longer you look at the book, the more uneasy it makes you feel. Perhaps someone with more knowledge in ancient languages could make some sense of it.";
		this.m.IconLarge = "tools/ancient_lich_book.png";
		this.m.Icon = "tools/ancient_lich_book_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.MagicStaff;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive | this.Const.Items.ItemType.Legendary;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.IsDroppedAsLoot = true;
		this.m.IsIndestructible = true;
		this.m.ArmamentIcon = "icon_necronomicon";
		this.m.Value = 1000;
		this.m.StaminaModifier = -2;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		local index = this.isRuned() ? result.len() - 2 : result.len() - 1;
		local find;

		result.insert(index, {
			id = 64,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Contains forbidden knowledge of ancient time"
		});

		foreach (i, a in result )
		{
			if (a.id == 5)
			{
				find = i;
				break;
			}
		}

		if (find != null) result.remove(find);
		return result;
	}

	function playInventorySound( _eventType )
	{
		local sounds = [
			"sounds/combat/dlc4/prophet_chant_01.wav",
			"sounds/combat/dlc4/prophet_chant_02.wav",
			"sounds/combat/dlc4/prophet_chant_03.wav",
			"sounds/combat/dlc4/prophet_chant_04.wav"
		];

		this.Sound.play(this.MSU.Array.getRandom(sounds), this.Const.Sound.Volume.Inventory);
	}

	function onUpdateProperties( _properties )
	{
		if (this.getContainer().getActor().getFlags().has("boss"))
		{
			_properties.ActionPoints += 3;
		}

		this.weapon.onUpdateProperties(_properties);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local c = this.getContainer();
		local hasActor = c != null && c.getActor() != null && !c.getActor().isNull();
		local hasFlags = hasActor && c.getActor().getFlags().has("boss");
		
		if (hasFlags)
		{
			this.addSkill(this.new("scripts/skills/actives/mod_geomancy_skill"));
			this.addSkill(this.new("scripts/skills/actives/mod_raise_all_undead_skill"));
			this.addSkill(this.new("scripts/skills/actives/mod_lightning_storm_skill"));

			if (c.getActor().getFlags().getAsInt("boss") == this.Const.Necro.UndeadBossType.SkeletonLich)
			{
				this.addSkill(this.new("scripts/skills/actives/mod_command_explode_skull_skill"));
				this.addSkill(this.new("scripts/skills/actives/mod_summon_mirror_image_skill"));
				this.addSkill(this.new("scripts/skills/actives/mod_summon_flying_skulls_skill"));
			}
		}
		else
		{
			local mad = this.new("scripts/skills/traits/mad_trait");
			mad.m.IsSerialized = false;
			this.addSkill(mad);
			this.addSkill(this.new("scripts/skills/actives/raise_undead"));
		}
	}

});

