::mods_hookExactClass("skills/effects/fake_charmed_effect", function(obj) 
{
	obj.getName <- function()
	{
		return "Simp";
	}

	obj.getDescription <- function()
	{
		return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his e-girl overlord, your everyday simp no more no less.";
	}

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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+20[/color] Resolve"
			}
		];
	}
});