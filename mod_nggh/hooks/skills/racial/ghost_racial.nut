::mods_hookExactClass("skills/racial/ghost_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "This character doesn\'t have an actual body or a definite form. Making it extremely hard to land on a hit.";
		this.m.Icon = "skills/racial_ghost.png";
		this.m.IconMini = "racial_ghost_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
    obj.onUpdate <- function( _properties )
    {
		_properties.IsImmuneToFire = true;
    	_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToDaze = true;
		_properties.IsImmuneToRoot = true;
		_properties.IsImmuneToDisarm = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.IsResistantToPhysicalStatuses = true;
		_properties.IsAffectedByRain = false;
		_properties.IsAffectedByNight = false;
		_properties.IsAffectedByInjuries = false;
		_properties.IsMovable = false;
		_properties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] *= 1000.0;
    }
});