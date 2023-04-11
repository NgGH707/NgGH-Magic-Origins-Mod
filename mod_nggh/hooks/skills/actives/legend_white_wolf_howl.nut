::mods_hookExactClass("skills/actives/legend_white_wolf_howl", function(obj) 
{
	obj.m.IsSpent <- false;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.Description = "A fearsome howl that boosts the fighting spirit of its pack members.";
		this.m.Icon = "skills/active_22.png";
		this.m.IconDisabled = "skills/active_22_sw.png";
		this.m.FatigueCost = 35;
		this.m.MaxRange = 4;
	};
	obj.getTooltip = function()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has an effective range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles radius"
		});

		if (this.m.IsSpent)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per battle[/color]"
			});
		}

		return ret;
	};
	obj.raiseMorale = function( _actor )
	{
		_actor.checkMorale(1, 2000);
		this.spawnIcon("status_effect_06", _actor.getTile());
	};
	obj.isUsable <- function()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}
	obj.onUse = function( _user, _targetTile )
	{
		foreach( a in ::Tactical.Entities.getAlliedActors(_user.getFaction(), _user.getTile(), this.getMaxRange()) )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
			
			a.getSkills().removeByID("effects.sleeping");
			this.raiseMorale(a);
		}

		this.m.IsSpent = true;
		return true;
	};
	obj.onCombatStarted <- function()
	{
		this.m.IsSpent = false;
	}
	obj.onCombatFinished <- function()
	{
		this.m.IsSpent = false;
	}
	
});