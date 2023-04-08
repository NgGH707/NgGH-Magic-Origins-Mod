this.nggh_mod_world_cursed_badly_effect <- ::inherit("scripts/skills/effects_world/nggh_mod_world_cursed_effect", {
	m = {
		IsForceRemoved = true,
		DayLefts = 4,
	},
	function create()
	{
		this.nggh_mod_world_cursed_effect.create();
		this.m.ID = "effects.cursed_badly";
	}
	
	function getDescription()
	{
		return this.m.Description + "The effect will be weakened as time passes but you need to make sure the next ritual is succeeded or there will be an even worse fate awaits you.";
	}

	function getTooltip()
	{
		local penalty = 10 + ::Math.min(15, 10 * this.m.DayLefts);
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
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + penalty + "%[/color] Resolve"
			},
		];
		
		if (this.m.DayLefts > 0)
		{
			ret.extend([
				{
					id = 16,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can\'t use Captive Charm[/color]"
				},
				{
					id = 10,
					type = "text",
					icon = "ui/icons/morale.png",
					text = "Will start combat at wavering morale"
				},
			]);
		}
		
		return ret;
	}
	
	function onAdded()
	{
		if (this.m.IsNew)
		{
			local actor = this.getContainer().getActor();
			local background = actor.getBackground();
			actor.getSprite("hair").setBrush(background.m.RealHair);
			actor.getSprite("head").setBrush(background.m.RealHead);
			actor.getSprite("body").setBrush(background.m.RealBody);
			actor.setDirty(true);
		}
		
		this.m.IsNew = false;
	}

	function onNewDay()
	{
		this.m.DayLefts = ::Math.max(0, this.m.DayLefts - 1);
		
		if (this.m.DayLefts == 0)
		{
			local weaken_curse = ::new("scripts/skills/effects_world/nggh_mod_world_cursed_effect");
			weaken_curse.m.Factions.extend(this.m.Factions);
			weaken_curse.m.PlayerRelations.extend(this.m.PlayerRelations);
			this.getContainer().add(weaken_curse);
			this.m.IsForceRemoved = false;
			this.m.HasBeenRemoved = true;
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 0.9 - ::Math.min(0.15, 0.1 * this.m.DayLefts);
	}
	
	function removeSelf()
	{
		if (this.m.IsForceRemoved)
		{
			this.onRemoved();
		}
		
		this.m.IsGarbage = true;
	}
	
	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= ::Const.MoodState.Disgruntled && actor.getMoraleState() > ::Const.MoraleState.Wavering)
		{
			actor.setMoraleState(::Const.MoraleState.Wavering);
		}
	}
	
	function onSerialize( _out )
	{
		this.nggh_mod_world_cursed_effect.onSerialize(_out);
		_out.writeU16(this.m.DayLefts);
	}

	function onDeserialize( _in )
	{
		this.nggh_mod_world_cursed_effect.onDeserialize(_in);
		this.m.DayLefts = _in.readU16();
	}

});

