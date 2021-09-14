this.player_orc_elite <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 2.5;
	}
	
	function onInit()
	{
		this.entity.onInit();

		if (!this.isInitialized())
		{
			this.createOverlay();
			this.m.BaseProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.CurrentProperties = this.Const.HexenOrigin.CharacterProperties.getClone();
			this.m.IsAttackable = true;

			if (this.m.MoraleState != this.Const.MoraleState.Ignore)
			{
				this.m.Skills.add(this.new("scripts/skills/special/morale_check"));
			}

			this.m.Items.setUnlockedBagSlots(2);
		}

		local b = this.m.BaseProperties;
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		local arrow = this.addSprite("arrow");
		arrow.setBrush("bust_arrow");
		arrow.Visible = false;
		this.setSpriteColorization("arrow", false);
		local rooted = this.addSprite("status_rooted_back");
		rooted.Visible = false;
		rooted.Scale = 0.55;
		
		this.m.Items.getAppearance().Body = "bust_orc_03_body";
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		
		local body = this.addSprite("body");
		body.setBrush("bust_orc_03_body");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		
		this.addSprite("tattoo_body");
		
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_03_body_injured");
		
		this.addSprite("armor");
		local upgrade_back = this.addSprite("armor_upgrade_back");
		upgrade_back.Scale = 1.05;
		this.addSprite("shaft");
		
		local head = this.addSprite("head");
		head.setBrush("bust_orc_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		this.addSprite("tattoo_head");
		
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_03_head_injured");
		
		local v = 0;
		local v2 = 10;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
			this.setSpriteOffset(a, this.createVec(v2, v));
		}

		local upgrade_front = this.addSprite("armor_upgrade_front");
		upgrade_front.Scale = 1.05;
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_orc_03_body_bloodied");
		body_blood.Visible = false;
		
		local body_rage = this.addSprite("body_rage");
		body_rage.Visible = false;
		body_rage.Alpha = 220;
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.6;

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		
		this.m.Skills.add(this.new("scripts/skills/effects/realm_of_nightmares_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/legend_demon_hound_aura_effect"));
		this.m.Skills.add(this.new("scripts/skills/special/weapon_breaking_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		this.m.Skills.add(this.new("scripts/skills/effects/captain_effect"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/hand_to_hand_orc"));
		this.setName("");
		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
	}

	function canEquipThis( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			local orc_armors = [
				"armor.body.orc_berserker_light_armor",
				"armor.body.orc_berserker_medium_armor",
				"armor.body.orc_elite_heavy_armor",
				"armor.body.orc_warrior_heavy_armor",
				"armor.body.orc_warrior_light_armor",
				"armor.body.orc_warrior_medium_armor",
				"armor.body.orc_young_heavy_armor",
				"armor.body.orc_young_light_armor",
				"armor.body.orc_young_medium_armor",
				"armor.body.orc_young_very_light_armor"
			];

			return orc_armors.find(_item.getID()) != null;
		}

		return true;
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

