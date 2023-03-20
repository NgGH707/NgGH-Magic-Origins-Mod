::mods_hookExactClass("items/helmets/greenskins/orc_warlord_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Warlord Battle Helm";
		this.m.Description = "A makeshift helmet made out of looted armors from the toughest opponents that the owner of this helmet has fought.";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.StaminaModifier = -35; // -25
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_04_helmet_01.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});