this.player_orc_warrior <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 2;
	}
	
	function onInit()
	{
		this.m.OffsetHelmet = [10, 3];
		this.m.OrcType = 2;
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			local weapons = [
				"weapons/greenskins/orc_axe",
				"weapons/greenskins/legend_skin_flayer",
				"weapons/greenskins/orc_cleaver"
			];
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			local armor = [
				[
					1,
					"greenskins/orc_warrior_light_armor"
				],
				[
					1,
					"greenskins/orc_warrior_medium_armor"
				],
				[
					1,
					"greenskins/orc_warrior_heavy_armor"
				],
				[
					1,
					"greenskins/orc_warrior_heavy_armor"
				]
			];
			local item = this.Const.World.Common.pickArmor(armor);
			this.m.Items.equip(item);
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
		{
			local helmet = [
				[
					1,
					"greenskins/orc_warrior_light_helmet"
				],
				[
					1,
					"greenskins/orc_warrior_medium_helmet"
				],
				[
					1,
					"greenskins/orc_warrior_heavy_helmet"
				]
			];
			local item = this.Const.World.Common.pickHelmet(helmet);
			this.m.Items.equip(item);
		}
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_orc_02_body",
	        	"bust_orc_03_body",

	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_orc_02_head_01",
	        	"bust_orc_02_head_02",
	        	"bust_orc_02_head_03",
	        	"bust_orc_03_head_01",
	        	"bust_orc_03_head_02",
	        	"bust_orc_03_head_03",
	        ];
	        break;
		}

		return ret;
	}

});

