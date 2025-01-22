::Nggh_MagicConcept.HooksMod.hook("scripts/items/trade/uncut_gems_item", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.ItemType = m.ItemType | ::Const.Items.ItemType.Crafting;
	}

});