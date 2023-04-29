this.nggh_mod_world_cursed_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Factions = [],
		PlayerRelations = [],
		HasBeenRemoved = false,
	},
	function create()
	{
		this.m.ID = "effects.cursed";
		this.m.Name = "Cursed";
		this.m.Description = "You have failed to do what you must do. This is the punishment for your failure.";
		this.m.Icon = "skills/status_effect_70.png";
		this.m.IconMini = "status_effect_70_mini";
		this.m.Type = ::Const.SkillType.Trait;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function isTreated()
	{
		return true;
	}
	
	function getDescription()
	{
		return this.m.Description + "You need to stop making the same failure next time or there will be a dire fate awaits you.";
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
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-25%[/color] Resolve"
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
		if (this.m.HasBeenRemoved) return;

		if (this.m.Factions.len() != 0 && this.m.PlayerRelations.len() != 0)
		{
			foreach ( i, id in this.m.Factions )
			{
				local f = ::World.FactionManager.getFaction(id)
				f.m.PlayerRelation = this.m.PlayerRelations[i];
				f.updatePlayerRelation();
			}
		}
		
		this.m.Factions = [];
		this.m.PlayerRelations = [];
		this.m.HasBeenRemoved = true;
		
		local actor = this.getContainer().getActor();
		actor.getSprite("hair").setBrush(::MSU.Array.rand(::Const.HexeOrigin.FakeHair));
		actor.getSprite("head").setBrush(::MSU.Array.rand(::Const.HexeOrigin.FakeHead));
		actor.getSprite("body").setBrush("bust_hexen_fake_body_00");
		actor.setDirty(true);
	}
	
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		
		_out.writeU8(this.m.Factions.len());
		for( local i = 0; i != this.m.Factions.len(); ++i )
		{
			_out.writeU8(this.m.Factions[i]);
		}
		
		_out.writeU8(this.m.PlayerRelations.len());
		for( local i = 0; i != this.m.PlayerRelations.len(); ++i )
		{
			_out.writeF32(this.m.PlayerRelations[i]);
		}
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		
		local numFactions = _in.readU8();
		this.m.Factions.resize(numFactions, 0);

		for( local i = 0; i != numFactions; ++i )
		{
			this.m.Factions[i] = _in.readU8();
		}
		
		local numPlayerRelation = _in.readU8();
		this.m.PlayerRelations.resize(numPlayerRelation, 0);

		for( local i = 0; i != numPlayerRelation; ++i )
		{
			this.m.PlayerRelations[i] = _in.readF32();
		}
	}

});

