::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/warwolf", function ( q )
{
	if (!::Is_AccessoryCompanions_Exist) {
		q.setVariant = @() function( _v )
		{
			m.Items.getAppearance().Body = "bust_wolf_0" + _v;
			getSprite("body").setBrush("bust_wolf_0" + _v + "_body");
			getSprite("head").setBrush("bust_wolf_0" + _v + "_head");
			setDirty(true);
		}
	}

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		if (!::MSU.isNull(m.Item) && ::MSU.isNull(m.Item.getContainer()))
			m.Item = null;

		__original(_killer, _skill, _tile, _fatalityType);
	}
	
});