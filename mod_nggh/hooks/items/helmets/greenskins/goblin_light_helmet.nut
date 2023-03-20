::mods_hookExactClass("items/helmets/greenskins/goblin_light_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Variants = [1, 3];
    	this.m.Variant = ::MSU.Array.rand(this.m.Variants);
    	this.m.Name = "Goblin Leather Cap";
		this.m.Description = "A sturdy leather cap that is only fitted for a child.";
		this.m.InventorySound = ::Const.Sound.ClothEquip;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
		this.m.StaminaModifier = -1;
		this.updateVariant();
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_goblin_01_helmet_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});