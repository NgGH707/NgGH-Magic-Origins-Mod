::mods_hookExactClass("items/helmets/greenskins/orc_warrior_medium_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Variants = [2, 5];
    	this.m.Name = "Looted Kettle Hat";
		this.m.Description = "A makeshift helmet crafted from looted kettle hats of fallen foes, quite durable.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_03_helmet_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});