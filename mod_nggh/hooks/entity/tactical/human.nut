::mods_hookExactClass("entity/tactical/human", function(obj) 
{
	obj.isAbleToEquip <- function(_item)
	{
		if (_item.isItemType(::Const.Items.ItemType.Armor) && ::Const.Items.NotForHumanArmorList.find(_item.getID()) != null)
		{
			return false;	
		}

		if (_item.isItemType(::Const.Items.ItemType.Helmet) && ::Const.Items.NotForHumanHelmetList.find(_item.getID()) != null)
		{
			return false;
		}

		return true;
	}
});