this.tent_butcher <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "tent.butcher_tent";
		this.m.Name = "Butchering\'s tent";
		this.m.Description = "A tent for butchering the spoil of battle. Comes with the all the neccessary equipments and tools to make the process easier. Having this in your stash upgrades your camp.";
		this.m.Icon = "tents/tent_hunt_70x70.png";
		this.m.Value = 2000;
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.World.Assets.BaseBuyPrice));
		}

		return this.item.getBuyPrice();
	}

	function getSellPrice()
	{
		if (this.m.IsBought)
		{
			return this.getBuyPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.floor(this.item.getSellPrice() * this.Const.World.Assets.BaseSellPrice);
		}

		return this.item.getSellPrice();
	}

});
