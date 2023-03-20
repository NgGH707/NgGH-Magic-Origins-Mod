::mods_hookExactClass("items/helmets/greenskins/goblin_skirmisher_helmet", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Variants = [1, 2, 3];
    	this.m.Variant = ::MSU.Array.rand(this.m.Variants);
    	this.m.Name = "Camouflage Hood";
		this.m.Description = "A hood was made to help the wearer disguise as a bush.";
		this.m.InventorySound = ::Const.Sound.ClothEquip;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = 0;
		this.updateVariant();
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_goblin_04_helmet_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("skirmisher_helmet");
	}

	obj.onUnequip <- function()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("skirmisher_helmet");
		this.helmet.onUnequip();
	}

	obj.getTooltip <- function()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("skirmisher_armor"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Will always start combat inside a bush"
				}
			]);
		}

		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.RangedDefense += 5;
		_properties.TargetAttractionMult *= 0.9;
	}
});