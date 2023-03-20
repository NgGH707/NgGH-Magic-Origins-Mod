::mods_hookExactClass("items/helmets/barbarians/unhold_helmet_light", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Unhold Restrainting Headgear";
		this.m.Description = "Barbarians of the north often use this to restraint captured unhold.";
    	this.m.Icon = "helmets/inventory_armored_unhold_head_02.png";
    	this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -1;
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});