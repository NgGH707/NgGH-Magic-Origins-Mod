::mods_hookExactClass("skills/perks/perk_ironside", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	obj.getBonus = function()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return 0;
		}
		
		return this.getContainer().getActor().getSurroundedCount() * 0.05;
	}

	obj.onBeforeDamageReceived = function( _attacker, _skill, _hitInfo, _properties )
	{
		_properties.DamageReceivedTotalMult *= 1.0 - this.getBonus();
	}
});