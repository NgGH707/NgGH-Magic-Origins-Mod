::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/fake_charmed_effect", function(q) 
{
	q.getName <- function()
	{
		return "Simp";
	}

	q.getDescription <- function()
	{
		return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his e-girl overlord, your everyday simp no more no less.";
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] Resolve"
			}
		];
	}
});