this.player_orc_behemoth <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 5;
	}
	
	function onInit()
	{
		this.m.OffsetHelmet = [13, 15];
		this.m.OrcType = 5;
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_limb_lopper"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_bough"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_man_mangler"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullbreaker"));
		}

		local item = this.Const.World.Common.pickArmor([
			[
				1,
				"greenskins/legend_orc_behemoth_armor"
			]
		]);
		this.m.Items.equip(item);
		local item = this.Const.World.Common.pickHelmet([
			[
				1,
				"greenskins/legend_orc_behemoth_helmet"
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
	        	"legend_orc_behemoth_body_01",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"legend_orc_behemoth_head_01",
	        ];
	        break;
		}

		return ret;
	}

});

