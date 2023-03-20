::Nggh_MagicConcept.HooksHelper <- 
{
	randomlyRollPerk = function( _actor, _perkConsts, _chance = 25 )
	{
		foreach ( _const in _perkConsts )
		{
			if (::Math.rand(1, 100) <= _chance)
			{
				_actor.getSkills().add(::new(::Const.Perks.PerkDefObjects[_const].Script));
			}
		}
	},

	autoEnableForBeasts = function(_skill)
	{
		local actor = _skill.getContainer().getActor().get();

		if (::isKindOf(actor, "nggh_mod_player_beast") || ::isKindOf(actor, "nggh_mod_minion"))
		{
			_skill.m.IsForceEnabled = true;
		}
	},
};