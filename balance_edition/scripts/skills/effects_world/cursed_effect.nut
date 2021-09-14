this.cursed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceRemoved = true,
		DayLefts = 4,
		Faction = [],
		PlayerRelation = [],
	},
	function create()
	{
		this.m.ID = "effects.cursed";
		this.m.Name = "Cursed";
		this.m.Description = "You have failed to do what you must do. This is a punishment for your failure. ";
		this.m.Icon = "skills/status_effect_70.png";
		this.m.IconMini = "status_effect_70_mini";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function isTreated()
	{
		return true;
	}
	
	function getDescription()
	{
		return this.m.Description + "The effect will be weakened as time passes but you need to make sure the next ritual is succeeded or there will be an even worse fate awaits you.";
	}

	function getTooltip()
	{
		local penalty = 10 + this.Math.min(15, 10 * this.m.DayLefts);
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + penalty + "%[/color] Resolve"
			},
		];
		
		if (this.m.DayLefts > 0)
		{
			ret.extend([
				{
					id = 16,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can\'t use Captive Charm[/color]"
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
		local actor = this.getContainer().getActor();
		actor.getSprite("hair").setBrush(actor.m.RealHair);
		actor.getSprite("head").setBrush(actor.m.RealHead);
		actor.getSprite("body").setBrush(actor.m.RealBody);
	}

	function onNewDay()
	{
		this.m.DayLefts = this.Math.max(0, this.m.DayLefts - 1);
		
		if (this.m.DayLefts == 0)
		{
			local lesser_curse = this.new("scripts/skills/effects_world/lesser_cursed_effect");
			lesser_curse.m.Faction = this.m.Faction;
			lesser_curse.m.PlayerRelation = this.m.PlayerRelation;
			this.getContainer().add(lesser_curse);
			this.m.IsForceRemoved = false;
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 0.9 - this.Math.min(0.15, 0.1 * this.m.DayLefts);
	}
	
	function removeSelf()
	{
		if (this.m.IsForceRemoved)
		{
			this.onRemoved();
		}
		
		this.m.IsGarbage = true;
	}
	
	function onRemoved()
	{
		if (this.m.Faction.len() != 0 && this.m.PlayerRelation.len() != 0)
		{
			foreach ( i, id in this.m.Faction )
			{
				local f = this.World.FactionManager.getFaction(id)
				f.m.PlayerRelation = this.m.PlayerRelation[i];
				f.updatePlayerRelation();
			}
		}
		
		this.m.Faction = [];
		this.m.PlayerRelation = [];
		
		local actor = this.getContainer().getActor();
		actor.getSprite("hair").setBrush(this.Const.HexenOrigin.FakeHair[this.Math.rand(0, 4)]);
		actor.getSprite("head").setBrush(this.Const.HexenOrigin.FakeHead[this.Math.rand(0, 1)]);
		actor.getSprite("body").setBrush("bust_hexen_fake_body_00");
	}
	
	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Disgruntled && actor.getMoraleState() > this.Const.MoraleState.Wavering)
		{
			actor.setMoraleState(this.Const.MoraleState.Wavering);
		}
	}
	
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.DayLefts);
		
		_out.writeU8(this.m.Faction.len());
		for( local i = 0; i != this.m.Faction.len(); i = i )
		{
			_out.writeU8(this.m.Faction[i]);
			i = ++i;
		}
		
		_out.writeU8(this.m.PlayerRelation.len());
		for( local i = 0; i != this.m.PlayerRelation.len(); i = i )
		{
			_out.writeF32(this.m.PlayerRelation[i]);
			i = ++i;
		}
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.DayLefts = _in.readU16();
		
		local numFactions = _in.readU8();
		this.m.Faction.resize(numFactions, 0);

		for( local i = 0; i != numFactions; i = i )
		{
			this.m.Faction[i] = _in.readU8();
			i = ++i;
		}
		
		local numPlayerRelation = _in.readU8();
		this.m.PlayerRelation.resize(numPlayerRelation, 0);

		for( local i = 0; i != numPlayerRelation; i = i )
		{
			this.m.PlayerRelation[i] = _in.readF32();
			i = ++i;
		}
	}

});

