::mods_hookExactClass("items/armor/greenskins/orc_warlord_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.ID = "armor.body.orc_warlord_armor";
    	this.m.Name = "Warlord Battle Gear";
		this.m.Description = "A makeshift armor made from the armors of the owner greatest trophy.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 600;
		this.m.ConditionMax = 600;
		this.m.StaminaModifier = -40;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_04_armor_01.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}

	obj.getTooltip <- function()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] Resolve"
		});
		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.armor.onUpdateProperties(_properties);
		_properties.BraveryMult *= 1.1;
	}
});