this.player_corpse_item <- this.inherit("scripts/items/corpses/corpse_item", {
	m = {
		DeadBroID = null
	},
	function create()
	{
		this.corpse_item.create()
		this.m.IsPlayer = true;
	}

	function getName()
	{
		local ret = this.item.getName();
		
		if (this.m.IsRotten)
		{
			return ret + " Remains";
		}

		return ret + " Corpse";
	}

	function setUpAsLootInBattle( _entity, _type, _corpse, _fatalityType )
	{
		this.corpse_item.setUpAsLootInBattle(_entity, _type, _corpse, _fatalityType);
		this.m.DeadBroID = _entity.getID();
		this.m.CorpseValue *= 1.1;
	}

	function onResurrected()
	{
		local bro = this.Tactical.getEntityByID(this.m.DeadBroID);

		if (bro != null)
		{
			this.World.getPlayerRoster().add(bro);
		}
	}

	function onRemovedFromStash( _stashID )
	{
		if (_stashID != "player")
		{
			return;
		}

		local bro = this.Tactical.getEntityByID(this.m.DeadBroID);

		if (bro != null)
		{
		}
	}

	function onSerialize( _out )
	{
		this.corpse_item.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.corpse_item.onDeserialize(_in);
	}

});

