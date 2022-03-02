this.befriend_with_necro_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		GiftsToNecromacer = 3
	},
	function fail()
	{
		this.ambition.fail();
		this.World.Statistics.getFlags().remove("IsDoingNecromancerAmbition");
	}

	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.befriend_with_necro";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "There is rumors about certain individuals looking for precious artifacts.\nMay be we can convince one of them to join us!";
		this.m.UIText = "Befriend with forbidden art practitioners";
		this.m.TooltipText = "Betraying 5 \'Return Item\' contracts by giving out thhe item with less reward so you can be in a good side of a rather notorious society but might also become a great helper later. You\'ll also need free roster seat enough for 2 new comers.";
		this.m.SuccessText = "[img]gfx/ui/events/event_76.png[/img]A man in dark, ragged clothes shows up and insists on wanting to have a conversation with the captain. The man then recites as how he heard story about the company from his connection. Finally, he states that he wants to have more opportunities to learn and improve his specialty, one of those opportunities can be found in this company, he offers his service and knowledge as payment. You accept his offers without any hesitation.";
		this.m.SuccessButtonText = "Welcome to the company!";
	}

	function getUIText()
	{
		local d = this.World.Statistics.getFlags().getAsInt("GiftsToNecromacer");
		return this.m.UIText + " (" + this.Math.min(3, d) + "/" + this.m.GiftsToNecromacer + ")";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBrothersMax() - this.World.getPlayerRoster().getSize() <= 1)
		{
			return false;
		}

		if (this.World.Statistics.getFlags().get("FriendOfNecromancer") || this.World.Statistics.getFlags().getAsInt("GiftsToNecromacer") >= this.m.GiftsToNecromacer)
		{
			return true;
		}

		return false;
	}

	function onStart()
	{
		this.World.Statistics.getFlags().set("IsDoingNecromancerAmbition", true);
	}

	/*
	local roster = this.World.getPlayerRoster();
	local undead = roster.create("scripts/entity/tactical/ghost_player");
	undead.setStartValuesEx();
	undead.onHired();

	local roster = this.World.getPlayerRoster();
	local undead = roster.create("scripts/entity/tactical/undead_player");
	undead.setStartValuesEx();
	undead.onHired();
	*/

	function onReward()
	{
		this.World.Statistics.getFlags().remove("IsDoingNecromancerAmbition");
		this.World.Statistics.getFlags().set("FriendOfNecromancer", true);
		local roster = this.World.getPlayerRoster();
		local necromancer = roster.create("scripts/entity/tactical/player");
		necromancer.getSprite("socket").setBrush("bust_base_undead");
		necromancer.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		necromancer.setStartValuesEx([
			"legend_puppet_master_background"
		]);
		necromancer.onHired();
		this.World.Assets.getOrigin().addScenarioPerk(necromancer.getBackground(), this.Const.Perks.PerkDefs.LegendPossession);
		local undead = roster.create(this.Math.rand(1, 100) <= 60 ? "scripts/entity/tactical/undead_player" : "scripts/entity/tactical/ghost_player");
		undead.setStartValuesEx();
		undead.onHired();

		this.m.SuccessList.extend([
			{
				id = 10,
				icon = necromancer.getBackground().getIcon(),
				text = necromancer.getNameOnly() + " has joined the " + this.World.Assets.getName()
			},
			{
				id = 10,
				icon = undead.getBackground().getIcon(),
				text = undead.getNameOnly() + " has joined the " + this.World.Assets.getName()
			}
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.GiftsToNecromacer);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		_in.readU16();
	}

});

