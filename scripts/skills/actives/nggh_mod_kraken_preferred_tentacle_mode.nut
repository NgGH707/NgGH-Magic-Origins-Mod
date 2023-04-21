this.nggh_mod_kraken_preferred_tentacle_mode <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.kraken_prefer_tentacle_mode";
		this.m.Name = "Preferred Mode";
		this.m.FlagName = "tentacle_mode";
		//this.m.Description = "the autopilot mode of your spawned spiders.";
		this.m.Icon = "skills/active_kraken_tentacle_rage_on.png";
		this.m.IconDisabled = "skills/active_kraken_tentacle_rage_off.png";
		this.m.Order += 3;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.getContainer().getActor().getFlags().get("tentacle_autopilot");
	}

	function getMode()
	{
		return this.getContainer().getActor().getFlags().getAsInt(this.m.FlagName);
	}

	function setMode( _integer )
	{
		if (typeof _integer == "integer")
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, _integer);
		}
		else
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, ::Const.KrakenTentacleMode.Ensnaring);
		}
	}

	function getName()
	{
		return this.m.Name + ": " + (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? "[color=" + ::Const.UI.Color.PositiveValue + "]Ensnaring[/color]" : "[color=" + ::Const.UI.Color.NegativeValue + "]Attacking[/color]");
	}

	function getDescription()
	{
		return "Allows you to determine what behaviour your newly spawned tentacles should prioritize while autopilot is enabled. [color=" + ::Const.UI.Color.NegativeValue + "]Does not affect already existing tentacles[/color]";
	}

	function getIcon()
	{
		if (this.getMode() == ::Const.KrakenTentacleMode.Attacking)
		{
			return this.m.Icon;
		}

		return this.m.IconDisabled;
	}

	function getTooltip()
	{
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
		];

		if (this.getMode() == ::Const.KrakenTentacleMode.Ensnaring)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/net.png",
				text = "Spawned tentacle will be in [color=" + ::Const.UI.Color.PositiveValue + "]Ensnaring[/color] mode"
			});

			return ret;
		}
		
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/damage_dealt.png",
			text = "Spawned tentacle will be in [color=" + ::Const.UI.Color.NegativeValue + "]Attacking[/color] mode"
		});

		return ret;
	}

	function switchMode( _reset = false )
	{
		if (_reset)
		{
			this.setMode(::Const.KrakenTentacleMode.Ensnaring);
		}
		else
		{
			this.setMode(this.getMode() == ::Const.KrakenTentacleMode.Ensnaring ? ::Const.KrakenTentacleMode.Attacking : ::Const.KrakenTentacleMode.Ensnaring);
		}

		this.onAfterSwitchMode();
		return true;
	}


});

