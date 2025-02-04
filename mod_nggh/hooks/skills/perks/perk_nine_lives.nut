::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) 
{
	q.m.NineLivesCount <- 1;
	q.m.StillSurvive <- true;

	q.isSpent = @() function()
	{
		return m.NineLivesCount <= 0;
	}

	q.restoreLife <- function()
	{
		if (getMaxLives() > m.NineLivesCount) addNineLivesCount();
	}

	q.addNineLivesCount <- function( _n = 1 )
	{
		m.LastFrameUsed = 0;
		m.NineLivesCount = ::Math.min(8, m.NineLivesCount + _n);
	}

	q.getMaxLives <- function()
	{
		return getContainer().getActor().getFlags().getAsInt("max_lives");
	}

	q.getName <- function()
	{
		local ret = skill.getName();

		if (m.NineLivesCount == 1)
			return format("%s (%i life left)", ret, m.NineLivesCount);
		else if (m.NineLivesCount > 1)
			return format("%s (%i lives left)", ret, m.NineLivesCount);

		return ret;
	}

	q.isHidden <- function()
	{
		return isSpent();
	}

	q.getTooltip <- function()
	{
		return [
			{
				id = 1,
				type = "title",
				text = getName()
			},
			{
				id = 2,
				type = "description",
				text = getDescription()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Extra life left: [color=" + ::Const.UI.Color.PositiveValue + "]" + m.NineLivesCount + "[/color]"
			}
		];
	}

	q.create = @(__original) function()
	{
		__original();
		m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		m.IconMini = "perk_07_mini";
		m.Overlay = "perk_07";
	}

	q.setSpent = @(__original) function(_f)
	{
		__original(_f);
		m.IsSpent = isSpent();

		if (!m.IsSpent)
			m.LastFrameUsed = 0;
	}
	
	q.onProc = @(__original) function()
	{
		__original();
		return --m.NineLivesCount;
	}
});