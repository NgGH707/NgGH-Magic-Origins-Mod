::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/web_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Send a web of silk out to ensnare an opponent, rooting them in place halving their damage, defenses and initiative. Does no damage.";
		m.Icon = "skills/active_114.png";
		m.IconDisabled = "skills/active_114_sw.png";
	}

	q.getTooltip @() = function()
	{
		local ret = this.getDefaultUtilityTooltip();
		
		if (m.Cooldown != 0)
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used in " + m.Cooldown + " turn(s)[/color]"
			});
		
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = getContainer().hasSkill("perk.spider_web") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		local specialization = getContainer().getSkillByID("perk.spider_web");

		if (specialization != null) {
			local breakFree = _targetTile.getEntity().getSkills().getSkillByID("actives.break_free");

			if (breakFree == null) {
				foreach (skill in _targetTile.getEntity().getSkills().m.SkillsToAdd)
				{
					if (skill.getID() != "actives.break_free")
						continue;

					breakFree = skill;
					break;
				}
			}

			if (breakFree != null)
				breakFree.setChanceBonus(specialization.getPenalty());

			m.Cooldown = 1;
		}

		return ret;
	}

	q.onCombatStarted <- function()
	{
		m.Cooldown = 0;
	}

});