this.lesser_cursed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Faction = [],
		PlayerRelation = [],
	},
	function create()
	{
		this.m.ID = "effects.lesser_cursed";
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
		return this.m.Description + "You need to prevent from making the same failure next time or there will be a dire fate awaits you.";
	}

	function getTooltip()
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
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Resolve"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 0.75;
	}
	
	function removeSelf()
	{
		this.onRemoved();
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
	
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		
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

