this.player_orc_elite <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 2.5;
	}
	
	function onInit()
	{
		this.m.OffsetHelmet = [10, 0];
		this.m.OrcType = 3;
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		local r;

		if (this.Math.rand(1, 100) <= 15)
		{
			r = this.Math.rand(1, 2);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/named/named_orc_cleaver"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/named/named_orc_axe"));
			}
		}
		else
		{
			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullsmasher"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_cleaver"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skin_flayer"));
			}
		}

		if (this.Math.rand(1, 100) <= 2)
		{
			this.m.Items.equip(this.new("scripts/items/shields/named/named_orc_heavy_shield"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
		}

		local item = this.Const.World.Common.pickArmor([
			[
				1,
				"greenskins/orc_elite_heavy_armor"
			]
		]);
		this.m.Items.equip(item);
		local item = this.Const.World.Common.pickHelmet([
			[
				1,
				"greenskins/orc_elite_heavy_helmet"
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

