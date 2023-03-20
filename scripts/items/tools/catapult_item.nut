this.catapult_item <- this.inherit("scripts/items/item", {
	m = {
		BringInBattle = true,
		IsInPLayerStash = false,
	},

	function isBroughtInBattle()
	{
		return this.m.BringInBattle;
	}

	function getEntityData()
	{
		return {
			ID = this.Const.EntityType.GreenskinCatapult,
			Faction = this.Const.Faction.PlayerAnimals,
			Variant = 0,
			Strength = 10,
			Cost = 10,
			Row = 2,
			Script = "scripts/entity/tactical/siege_weapons/catapult_entity",
		};
	}

	function create()
	{
		this.m.ID = "misc.mc_catapult";
		this.m.Name = "Trebuchet";
		this.m.Description = "Trebuchet is a type of catapult that uses a long arm to throw a projectile.";
		this.m.Icon = "tools/catapult.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = false;
		this.m.IsAllowedInBag = false;
		this.m.IsIndestructible = true;
		this.m.IsUsable = true;
		this.m.Value = 5000;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		if (this.m.IsInPLayerStash)
		{
			if (this.m.BringInBattle)
			{
				result.push({
					id = 8,
					type = "text",
					icon = "ui/icons/icon_contract_swords.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]Is brought in battle[/color]"
				});
			}
			else 
			{
			    result.push({
			    	id = 8,
					type = "text",
					icon = "ui/icons/cancel.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Is put in reserve[/color]"
				});
			}
		}

		return result;
	}

	function updateIcon()
	{
		if (!this.m.IsInPLayerStash)
		{
			this.m.ID = "misc.mc_catapult";
			this.m.Icon = "tools/catapult.png";
			return;
		}

		if (this.m.BringInBattle)
		{
			this.m.ID = "misc.mc_catapult";
			this.m.Icon = "tools/catapult_on.png";
		}
		else 
		{
			this.m.ID = "misc.mc_catapult_off";
		    this.m.Icon = "tools/catapult_off.png";
		}
	}

	function onUse( _actor, _item = null )
	{
		return true;
	}

	function onUseIndestructibleItem()
	{
		local item = this.new("scripts/items/tools/catapult_item");
		item.m.BringInBattle = !this.m.BringInBattle;
		return item;
	}

	function onAddedToStash( _stashID )
	{
		this.m.IsInPLayerStash = _stashID == this.World.Assets.getStash().getID();
		this.updateIcon();
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeBool(this.m.BringInBattle);
		_out.writeBool(this.m.IsInPLayerStash);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.BringInBattle = _in.readBool();
		this.m.IsInPLayerStash = _in.readBool();

		if (this.m.IsInPLayerStash)
		{
			this.updateIcon();
		}
	}

});

