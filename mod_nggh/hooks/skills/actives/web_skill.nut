::mods_hookExactClass("skills/actives/web_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Send a web of silk out to ensnare an opponent, rooting them in place halving their damage, defenses and initiative. Does no damage.";
		this.m.Icon = "skills/active_114.png";
		this.m.IconDisabled = "skills/active_114_sw.png";
	};
	obj.getTooltip = function()
	{
		local ret = this.getDefaultUtilityTooltip();
		
		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used in " + this.m.Cooldown + " turn(s)[/color]"
			});
		}
		
		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = this.getContainer().hasSkill("perk.spider_web") ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};

	local ws_onVerifyTarget = obj.onVerifyTarget;
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!ws_onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		return !_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot;
	};

	local ws_onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		local ret = ws_onUse(_user, _targetTile);
		local specialization = this.getContainer().getSkillByID("perk.spider_web");

		if (specialization != null)
		{
			local breakFree = _targetTile.getEntity().getSkills().getSkillByID("actives.break_free");

			if (breakFree != null)
			{
				breakFree.setChanceBonus(specialization.getPenalty());
			}

			this.m.Cooldown = 0;
		}

		return ret;
	};
	obj.onCombatStarted <- function()
	{
		this.m.Cooldown = 0;
	}
});