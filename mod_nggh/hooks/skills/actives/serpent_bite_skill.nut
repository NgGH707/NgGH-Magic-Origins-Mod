::mods_hookExactClass("skills/actives/serpent_bite_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "A bite from a giant snake can be painful for a \"little\" bit.";
		this.m.KilledString = "Bitten to bits";
		this.m.Icon = "skills/active_196.png";
		this.m.IconDisabled = "skills/active_196_sw.png";
		this.m.ChanceDisembowel = 25;
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]2[/color] tiles"
			});
		}

		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		if (_properties.IsSpecializedInShields)
			this.m.MaxRange += 1;
		
		if (_properties.IsSpecializedInPolearms)
			this.m.ActionPointCost -= 1;
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
	    if (_skill == this && _targetEntity != null)
	    {
	    	local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

	    	// deal less damage when is not in melee range
	    	if (d <= 1)
	    		return;
	    	
    		_properties.MeleeSkill -= 7 * (d - 1);
    		_properties.MeleeDamageMult *= 0.85;
	    }
	}
});