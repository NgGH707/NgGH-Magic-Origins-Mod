this.player_orc_young <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 1.33;
	}
	
	function onInit()
	{
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		local r;
		local weapon;

		if (this.Math.rand(1, 100) <= 25)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/orc_javelin"));
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				local r = this.Math.rand(1, 2);

				if (r == 1)
				{
					weapon = this.new("scripts/items/weapons/greenskins/orc_axe");
				}
				else if (r == 2)
				{
					weapon = this.new("scripts/items/weapons/greenskins/orc_cleaver");
				}
				else if (r == 3)
				{
					weapon = this.new("scripts/items/weapons/greenskins/legend_skin_flayer");
				}
			}
			else
			{
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					weapon = this.new("scripts/items/weapons/greenskins/orc_wooden_club");
				}
				else if (r == 2)
				{
					weapon = this.new("scripts/items/weapons/greenskins/orc_metal_club");
				}
				else if (r == 3)
				{
					weapon = this.new("scripts/items/weapons/legend_chain");
				}
			}
		}
		else
		{
			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				weapon = this.new("scripts/items/weapons/greenskins/goblin_falchion");
			}
			else if (r == 2)
			{
				weapon = this.new("scripts/items/weapons/morning_star");
			}
			else if (r == 3)
			{
				weapon = this.new("scripts/items/weapons/greenskins/legend_meat_hacker");
			}
			else if (r == 4)
			{
				weapon = this.new("scripts/items/weapons/greenskins/legend_bone_carver");
			}
		}

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			this.m.Items.equip(weapon);
		}
		else
		{
			this.m.Items.addToBag(weapon);
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_light_shield"));
		}

		local item = this.Const.World.Common.pickArmor([
			[
				1,
				"greenskins/orc_young_very_light_armor"
			],
			[
				1,
				"greenskins/orc_young_light_armor"
			],
			[
				1,
				"greenskins/orc_young_medium_armor"
			],
			[
				1,
				"greenskins/orc_young_heavy_armor"
			],
			[
				1,
				""
			]
		]);
		this.m.Items.equip(item);
		local item = this.Const.World.Common.pickHelmet([
			[
				1,
				""
			],
			[
				1,
				"greenskins/orc_young_light_helmet"
			],
			[
				1,
				"greenskins/orc_young_medium_helmet"
			],
			[
				1,
				"greenskins/orc_young_heavy_helmet"
			]
		]);

		if (item != null)
		{
			this.m.Items.equip(item);
		}
	}

});

