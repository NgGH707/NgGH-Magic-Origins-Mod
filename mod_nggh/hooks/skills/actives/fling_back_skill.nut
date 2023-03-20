::mods_hookExactClass("skills/actives/fling_back_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Grab a target and throw behind you in order to move forward. Can be used on allies.";
		this.m.Icon = "skills/active_111.png";
		this.m.IconDisabled = "skills/active_111_sw.png";
		this.m.Delay = 250;
		this.m.IsAttack = false;
		this.m.IsIgnoringRiposte = true;
		this.m.IsSpearwallRelevant = false;
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Throws[/color] an target away and [color=" + ::Const.UI.Color.PositiveValue + "]Steps Forward[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deals [color=" + ::Const.UI.Color.NegativeValue + "]Fall Damage[/color] depending on the [color=" + ::Const.UI.Color.NegativeValue + "]Height[/color]"
			}
		]);

		if (this.isUpgraded())
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to daze"
			});
		}
		
		return ret;
	};
	obj.isUpgraded <- function()
	{
		return this.getContainer().hasSkill("perk.unhold_fling");
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInThrowing)
		{
			this.m.ActionPointCost -= 1;
		}
	};
	obj.onKnockedDown = function( _entity, _tag )
	{
		if (_tag.Skill.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(_tag.Skill.m.SoundOnHit), ::Const.Sound.Volume.Skill, _entity.getPos());
		}

		local isSpecialized = _tag.Skill.isUpgraded();

		if (_tag.HitInfo.DamageRegular != 0)
		{
			if (isSpecialized)
			{
				_tag.HitInfo.DamageRegular *= 2;
			}

			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
			
			if (typeof _tag.Attacker == "instance" && _tag.Attacker.isNull() || !_tag.Attacker.isAlive() || _tag.Attacker.isDying())
			{
				return;
			}
			
			_tag.Skill.getContainer().onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageRegular, 0);
		}

		if (isSpecialized && _entity.isAlive() && !_entity.isDying() && !_entity.getCurrentProperties().IsImmuneToDaze)
		{
			_entity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_tag.Attacker) + " has dazed " + ::Const.UI.getColorizedEntityName(_entity) + " for one turn");
		}
	};
});