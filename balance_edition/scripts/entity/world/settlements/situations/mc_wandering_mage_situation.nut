this.mc_wandering_mage_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mc_wandering_mage";
		this.m.Name = "Mysterious Traveler";
		this.m.Description = "A strange figure has come to this place, the locals gossip about that mysterious traveler taking a stop in here. Some say that person can use unnatural force and do things no other can...";
		this.m.Icon = "ui/settlement_status/settlement_effect_wandering_mage.png";
		this.m.Rumors = [
			"Some witch hunters came by yesterday. They didn\'t find what they were looking for and headed on to %settlement%.",
			"From what I hear they found a witch in %settlement% and will put her to the pyre. Come to think of it, maybe I should report that old shrew that bested me on the market the other day, she\'s a witch for sure!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return _s + " now has " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " no longer has " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.updateRoster(true);
		local tempo_roster = this.World.getTemporaryRoster();
		tempo_roster.clear();
		local mage = tempo_roster.create("scripts/entity/tactical/player");
		mage.setStartValuesEx(this.Const.MC_Backgrounds);
		this.World.Assets.getOrigin().onUpdateHiringRoster(tempo_roster);
		local roster = this.World.getRoster(_settlement.getID());
		roster.add(mage);
		tempo_roster.clear();
	}

	function onRemoved( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.05;
		_modifiers.RarityMult *= 1.5;
		_modifiers.RecruitsMult *= 0.75;
	}

});

