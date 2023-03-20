::mods_hookExactClass("items/armor/greenskins/orc_berserker_medium_armor", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Bone Armor";
		this.m.Description = "An armor made out of the bone of whatever thing it is. A valuable item to show its owner standing in the horde.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -12;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_02_armor_02.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("berserker_armor");
		}
	}

	obj.onUnequip <- function()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("berserker_armor");
		}

		this.armor.onUnequip();
	}

	obj.getTooltip <- function()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+50[/color] Resolve"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("berserker_helmet"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Cannot be reduced to [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold - 1] + "[/color] morale, only [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold] + "[/color]"
				}
			]);
		}
		
		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.armor.onUpdateProperties(_properties);
		_properties.Bravery += 50;
	}
});