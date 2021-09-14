this.player_orc_behemoth <- this.inherit("scripts/entity/tactical/player_orc", {
	m = {},
	
	function getStrength()
	{
		return 5;
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
		
		this.m.Items.getAppearance().Body = "legend_orc_behemoth_body_01";
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		
		local body = this.addSprite("body");
		body.setBrush("legend_orc_behemoth_body_01");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		
		this.addSprite("tattoo_body");
		
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("legend_orc_behemoth_body_01_bloodied");
		
		this.addSprite("armor");
		local upgrade_back = this.addSprite("armor_upgrade_back");
		upgrade_back.Scale = 1.05;
		this.addSprite("shaft");
		
		local head = this.addSprite("head");
		head.setBrush("legend_orc_behemoth_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		this.addSprite("tattoo_head");
		
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("legend_orc_behemoth_head_01_bloodied");
		
		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local v = 15;
		local v2 = 13;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
		}

		local upgrade_front = this.addSprite("armor_upgrade_front");
		upgrade_front.Scale = 1.05;
		
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_orc_01_body_bloodied");
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
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
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
				"armor.body.legend_orc_behemoth_armor",
			];

			return orc_armors.find(_item.getID()) != null;
		}

		return true;
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

