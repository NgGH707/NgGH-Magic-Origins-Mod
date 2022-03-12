this.fake_charmed_broken_effect <- this.inherit("scripts/skills/skill", {
	m = {
		StartMutiny = false,
		Chance = 15,
	},
	function create()
	{
		this.m.ID = "effects.fake_charmed_broken";
		this.m.Name = "Simp (???)";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "This character is uncertain of whether he want to keep simping around or not. A bit suspicious.";
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
		];
	}
	
	function onUpdate( _properties )
	{
		_properties.DailyWageMult = 0.0;
	}

	function onTurnStart()
	{
		if (!this.m.StartMutiny && this.Math.rand(1, 100) <= this.m.Chance)
		{
			this.spawnIcon("status_effect_106", this.getContainer().getActor().getTile());
			this.getContainer().getActor().setFaction(this.Const.Faction.Arena);
			this.getContainer().getActor().setAIAgent(this.new("scripts/ai/tactical/agents/charmed_player_agent"));
			this.getContainer().getActor().getAIAgent().setActor(this.getContainer().getActor());
			this.m.StartMutiny = true;
		}
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function onRemoved()
	{
		this.getContainer().getActor().setFaction(this.Const.Faction.Player);
		this.getContainer().getActor().setAIAgent(this.new("scripts/ai/tactical/player_agent"));
		this.getContainer().getActor().getAIAgent().setActor(this.getContainer().getActor());
	}

	function onCombatStarted()
	{
		this.m.Chance = this.World.Flags.get("isExposed") ? 33 : 15;
	}

	function onCombatFinished()
	{
		if (this.m.StartMutiny) this.World.getPlayerRoster().remove(this.getContainer().getActor().get());
	}

});

