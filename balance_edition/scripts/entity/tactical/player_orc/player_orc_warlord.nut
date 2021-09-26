this.player_orc_warlord <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 3.75;
	}
	
	function onInit()
	{
		this.m.OffsetHelmet = [13, 10];
		this.m.OrcType = 4;
		this.player_orc.onInit();
	}
	
	function assignRandomEquipment( _gearSet = 0 )
	{
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			local weapons = [
				"weapons/greenskins/orc_axe",
				"weapons/greenskins/orc_cleaver"
			];

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
			{
				weapons.extend([
					"weapons/greenskins/orc_axe_2h",
					"weapons/greenskins/orc_axe_2h"
				]);
			}

			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			local item = this.Const.World.Common.pickArmor([
				[
					1,
					"greenskins/orc_warlord_armor"
				]
			]);
			this.m.Items.equip(item);
		}

		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
		{
			local item = this.Const.World.Common.pickHelmet([
				[
					1,
					"greenskins/orc_warlord_helmet"
				]
			]);

			if (item != null)
			{
				this.m.Items.equip(item);
			}
		}
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_orc_04_body",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_orc_04_head_01",
	        ];
	        break;
		}

		return ret;
	}

});

