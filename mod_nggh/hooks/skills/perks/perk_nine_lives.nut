::mods_hookExactClass("skills/perks/perk_nine_lives", function(obj) 
{
	obj.m.NineLivesCount <- 1;
	obj.m.StillSurvive <- true;

	obj.isSpent = function()
	{
		return this.m.NineLivesCount <= 0;
	};
	obj.restoreLife <- function()
	{
		if (this.getMaxLives() > this.m.NineLivesCount) this.addNineLivesCount();
	};
	obj.addNineLivesCount <- function( _n = 1 )
	{
		this.m.LastFrameUsed = 0;
		this.m.NineLivesCount = ::Math.min(8, this.m.NineLivesCount + _n);
	};
	obj.getMaxLives <- function()
	{
		return this.getContainer().getActor().getFlags().getAsInt("max_lives");
	}
	obj.getName <- function()
	{
		local ret = this.skill.getName();

		if (this.m.NineLivesCount == 1)
		{
			return ret + " (" + (this.m.NineLivesCount) + " life left)"
		}
		else if (this.m.NineLivesCount > 1)
		{
			return ret + " (" + (this.m.NineLivesCount) + " lives left)"
		}

		return ret;
	};
	obj.isHidden <- function()
	{
		return this.isSpent();
	};
	obj.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Extra life left: [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.NineLivesCount + "[/color]"
			}
		];
	};
	local ws_create = obj.create;
	obj.create <- function()
	{
		ws_create();
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.IconMini = "perk_07_mini";
		this.m.Overlay = "perk_07";
	};
	local ws_setSpent = obj.setSpent;
	obj.setSpent = function(_f)
	{
		ws_setSpent(_f);
		this.m.IsSpent = this.isSpent();

		if (!this.m.IsSpent)
		{
			this.m.LastFrameUsed = 0;
		}
	}
	local ws_onProc = obj.onProc;
	obj.onProc = function()
	{
		ws_onProc();
		--this.m.NineLivesCount;
	}
});