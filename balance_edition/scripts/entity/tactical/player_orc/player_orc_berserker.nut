this.player_orc_berserker <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 2.25;
	}
	
	function onInit()
	{	
		this.m.OffsetHelmet = [8, 2];
		this.m.OrcType = 1;
		this.m.ScaleArmor = 1.15;
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		local r = this.Math.rand(1, 8);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_cleaver"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_flail_2h"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe_2h"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_limb_lopper"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_man_mangler"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_bough"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullbreaker"));
		}

		local item = this.Const.World.Common.pickArmor([
			[
				1,
				"greenskins/orc_berserker_light_armor"
			],
			[
				1,
				"greenskins/orc_berserker_medium_armor"
			],
			[
				3,
				""
			]
		]);
		this.m.Items.equip(item);
		local item = this.Const.World.Common.pickHelmet([
			[
				2,
				""
			],
			[
				1,
				"greenskins/orc_berserker_helmet"
			]
		]);

		if (item != null)
		{
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

