::mods_hookExactClass("items/tools/faction_banner", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.ID = "weapon.player_banner";
		this.m.Description = "A noble house standard to take into battle. Held high, allies will rally around it with renewed resolve, and enemies will know well who is about to crush them.";
		this.m.WeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.SlotType = ::Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Weapon | ::Const.Items.ItemType.MeleeWeapon | ::Const.Items.ItemType.TwoHanded | ::Const.Items.ItemType.Defensive;
		this.m.IsIndestructible = true;
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.35;
	}

	local ws_onEquip = obj.onEquip;
	obj.onEquip = function()
	{
		ws_onEquip();
		
		local actor = this.getContainer().getActor();
		this.m.IsDroppedAsLoot = actor != null && !actor.isNull() && actor.isPlayerControlled();
	}

	obj.onUnequip <- function()
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

	obj.updateVariant <- function()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		this.m.IconLarge = "weapons/faction_banner/faction_banner_" + variant + ".png";
		this.m.Icon = "weapons/faction_banner/faction_banner_" + variant + "_70x70.png";
	}

	obj.setVariant <- function( _v )
	{
		local nobleName = "";
		this.m.Variant = _v;
		
		if (("State" in ::Tactical) && ::Tactical.State != null && !::Tactical.State.isScenarioMode())
		{
			local nobleHouses = ::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse);
			
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
		
		this.m.Name = "Battle Standard of " + nobleName;
		this.updateVariant();
	}

	obj.getTooltip <- function()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Allies at a range of 4 tiles or less receive [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] of the Resolve of the character holding this standard as a bonus, up to a maximum of the standard bearer\'s Resolve."
		});
		return result;
	}

	obj.getBuyPrice <- function()
	{
		return 1000000;
	}

	obj.onSerialize <- function( _out )
	{
		_out.writeString(this.m.Name);
		this.weapon.onSerialize(_out);
	}

	obj.onDeserialize <- function( _in )
	{
		this.m.Name = _in.readString();
		this.weapon.onDeserialize(_in);
	}
});