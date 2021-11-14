this.mc_wandering_mage_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mc_wandering_mage";
		this.m.Name = "Mysterious Travelers";
		this.m.Description = "A group of strange figures have come to this place, the locals gossip about them taking a stop in here. Some say that person can use unnatural force and do things no other can, maybe you can recruit some of them.";
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
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.1;
		_modifiers.RarityMult *= 1.25;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.extend(this.Const.MC_Backgrounds);
		_draftList.extend(this.Const.MC_Backgrounds);
	}

});

