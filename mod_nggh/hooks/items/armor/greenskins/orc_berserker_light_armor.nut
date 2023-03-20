::mods_hookExactClass("items/armor/greenskins/orc_berserker_light_armor", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Trophy Bones";
		this.m.Description = "A harness made out of the bone of what is seemed as battle trophy. A token to honor its owner warrior skill.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -7;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_02_armor_01.png";
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
		result.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "No morale check triggered upon allies dying or fleeing"
			}
		]);

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
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByFleeingAllies = false;
	}
});