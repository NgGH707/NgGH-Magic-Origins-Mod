::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/alp_teleport_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Fading out your physical body then reappearing at another place.";
		m.Icon = "skills/active_160.png";
		m.IconDisabled = "skills/active_160.png";
		m.Overlay = "active_160";
		m.SoundOnHit = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		m.Order =  ::Const.SkillOrder.UtilityTargeted + 3;
		m.IsHidden = true;
	}

	q.onAdded <- function()
	{
		local auto_button = ::new("scripts/skills/actives/nggh_mod_auto_mode_alp_teleport");
		getContainer().add(auto_button);

		if (!getContainer().getActor().isPlayerControlled())
			auto_button.onCombatStarted();

		getContainer().add(::new("scripts/skills/actives/nggh_mod_alp_teleport_skill"));
	}

	q.isUsable <- function()
	{
		return true;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (::Tactical.TurnSequenceBar.isActiveEntity(_user))
			::Sound.play(::MSU.Array.rand(m.SoundOnHit), ::Const.Sound.Volume.Skill * m.SoundVolume, _user.getPos());

		return __original(_user, _targetTile);
	}

	q.onTeleportDone = @(__original) function( _entity, _tag )
	{
		__original(_entity, _tag);

		if (_entity.getSkills().hasSkill("perk.afterimage"))
			_entity.getSkills().add(::new("scripts/skills/effects/nggh_mod_afterimage_effect"));
	}
});