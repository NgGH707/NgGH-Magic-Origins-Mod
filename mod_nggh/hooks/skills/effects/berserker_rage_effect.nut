::mods_hookExactClass("skills/effects/berserker_rage_effect", function(obj) 
{
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.RageStacks = 1;
		}
	};
	obj.isHidden <- function()
	{
		return this.m.RageStacks == 0;
	}
	obj.getTooltip <- function()
	{
		local i = this.Math.max(30, (1.0 - 0.01 * this.m.RageStacks) * 100);
		local ret = [
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
				id = 7,
				type = "text",
				icon = "ui/icons/mood_01.png",
				text = "Has [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.RageStacks + "[/color] stack(s) of rage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Attack Damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.RageStacks + "[/color] Initiative"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]" + (100 - i) + "%[/color] less damage to Hitpoints"
			}
		];
		
		return ret;
	};
	obj.onUpdate = function( _properties )
	{
		// nerf the damage reduction to only affect hitpoints damage
		_properties.DamageReceivedRegularMult *= ::Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
		_properties.Bravery += this.m.RageStacks;
		_properties.DamageRegularMin += this.m.RageStacks;
		_properties.DamageRegularMax += this.m.RageStacks;
		_properties.Initiative += this.m.RageStacks;
	}
	obj.onCombatStarted <- function()
	{
		this.m.RageStacks = 0;
		this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
	};
	obj.onCombatFinished <- function()
	{
		this.m.RageStacks = 1;
		this.getContainer().getActor().updateRageVisuals(this.m.RageStacks);
	};
});