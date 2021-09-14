this.faction_banner <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.player_banner";
		this.m.Name = "Battle Standard";
		this.m.Description = "A noble house standard to take into battle. Held high, allies will rally around it with renewed resolve, and enemies will know well who is about to crush them.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDroppedAsLoot = false;
		this.m.IsIndestructible = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = false;
		this.m.ArmamentIcon = "";
		this.m.Value = 1000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.35;
		this.m.ChanceToHitHead = 5;
	}
	
	function setVariant( _v )
	{
		local nobleName = "";
		this.m.Variant = _v;
		
		if (("State" in this.Tactical) && this.Tactical.State != null && !this.Tactical.State.isScenarioMode())
		{
			local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
			
			foreach ( house in nobleHouses )
			{
				if (house.getBanner() == _v)
				{
					nobleName = house.getName();
					break;
				}
			}
		}
		
		if (nobleName.len() == 0)
		{
			nobleName = "House Whatever";
		}
		
		this.setName(nobleName);
		this.updateVariant();
	}
	
	function setName( _n )
	{
		this.m.Name = "Battle Standard of " + _n;
	}
	
	function updateVariant()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		this.m.IconLarge = "weapons/faction_banner/faction_banner_" + variant + ".png";
		this.m.Icon = "weapons/faction_banner/faction_banner_" + variant + "_70x70.png";
	}
	
	function updateAppearance()
	{
		if (!this.isEquipped())
		{
			return;
		}
		
		local actor = this.getContainer().getActor();
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;

		if (actor.hasSprite("background"))
		{
			actor.getSprite("background").setBrush("faction_banner_" + variant);
		}

		if (actor.hasSprite("shaft"))
		{
			actor.getSprite("shaft").setBrush("faction_banner_shaft");
		}

		actor.setDirty(true);
	}
	
	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Allies at a range of 4 tiles or less receive [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] of the Resolve of the character holding this standard as a bonus, up to a maximum of the standard bearer\'s Resolve."
		});
		return result;
	}
	
	function getBuyPrice()
	{
		return 1000000;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_54.png";
		impale.m.IconDisabled = "skills/active_54_sw.png";
		impale.m.Overlay = "active_54";
		this.addSkill(impale);
		
		local actor = this.getContainer().getActor();

		if (actor != null)
		{
			this.m.IsDroppedAsLoot = actor.isPlayerControlled();
		}
		else
		{
			this.m.IsDroppedAsLoot = false;
		}
	}
	
	function onUnequip()
	{
		local actor = this.getContainer().getActor();

		if (actor == null)
		{
			return;
		}

		if (actor.hasSprite("background"))
		{
			actor.getSprite("background").resetBrush();
		}

		if (actor.hasSprite("shaft"))
		{
			actor.getSprite("shaft").resetBrush();
		}

		actor.setDirty(true);
		this.weapon.onUnequip();
	}

	function onMovementFinished()
	{
		local actor = this.getContainer().getActor();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach( ally in allies )
		{
			if (ally.getID() != actor.getID())
			{
				ally.getSkills().update();
			}
		}
	}
	
	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeU8(this.m.Variant);
		_out.writeF32(0);
		this.weapon.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.Variant = _in.readU8();
		_in.readF32();
		this.weapon.onDeserialize(_in);
		this.updateVariant();
	}

});

