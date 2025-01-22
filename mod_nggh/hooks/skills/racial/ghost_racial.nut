::Nggh_MagicConcept.HooksMod.hook("scripts/skills/racial/ghost_racial", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "This character doesn\'t have an actual body or a definite form. Making it extremely hard to land on a hit.";
		m.Icon = "skills/racial_ghost.png";
		m.IconMini = "racial_ghost_mini";
		m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.First + 1;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

    q.onUpdate <- function( _properties )
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