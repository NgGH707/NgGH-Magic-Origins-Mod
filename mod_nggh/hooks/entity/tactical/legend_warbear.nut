::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/legend_warbear", function ( q )
{
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		if (!::MSU.isNull(m.Item) && ::MSU.isNull(m.Item.getContainer()))
			m.Item = null;

		__original(_killer, _skill, _tile, _fatalityType);
	}
	
});