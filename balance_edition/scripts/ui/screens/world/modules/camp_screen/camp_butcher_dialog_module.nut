this.camp_butcher_dialog_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {
		Title = "Butcher",
		Description = "Items in the queue will be butchered from left to right, top to bottom. Assign butchers in the commanders tent.",
		InventoryFilter = this.Const.Items.ItemFilter.All
	},
	function create()
	{
		this.m.ID = "CampButcherDialogModule";
		this.ui_module.create();
	}

	function getTent()
	{
		return this.World.Camp.getBuildingByID(this.Const.World.CampBuildings.Butcher);
	}

	function destroy()
	{
		this.ui_module.destroy();
	}

	function onShow()
	{
		this.getTent().onInit();
		return this.queryLoad();
	}

	function queryLoad()
	{
		local result = {
			Title = this.m.Title,
			SubTitle = this.m.Description,
			Assets = this.assetsInformation(),
			Stash = [],
			Butcher = [],
			Products = this.getTent().getProducts(),
			Capacity = this.getTent().getCapacity()
		};
		this.UIDataHelper.convertRepairItemsToUIData(this.getTent().getButcher(), result.Butcher, this.Const.UI.ItemOwner.Shop);
		this.UIDataHelper.convertRepairItemsToUIData(this.getTent().getStash(), result.Stash, this.Const.UI.ItemOwner.Stash, this.m.InventoryFilter);
		return result;
	}

	function assetsInformation()
	{
		return {
			Time = this.getTent().getRequiredTime(),
			Brothers = this.getTent().getAssignedBros()
		};
	}

	function loadStashList()
	{
		local result = this.queryLoad()
		this.m.JSHandle.asyncCall("loadFromData", result);
	}

	function onSortButtonClicked()
	{
		if (this.Tactical.isActive())
		{
			this.getroottable().Stash.sort();
		}
		else
		{
			this.World.Assets.getStash().sort();
		}

		this.getTent().onInit();
		this.loadStashList();
	}

	function onFilterAll()
	{
		if (this.m.InventoryFilter != this.Const.Items.ItemFilter.All)
		{
			this.m.InventoryFilter = this.Const.Items.ItemFilter.All;
			this.loadStashList();
		}
	}

	function onAssignAll()
	{
		this.getTent().assignAll(this.m.InventoryFilter);
		this.loadStashList();
	}

	function onRemoveAll()
	{
		this.getTent().removeAll();
		this.loadStashList();
	}

	function onSwapItem( _data )
	{
		local sourceItemIdx = _data[0];
		local sourceItemOwner = _data[1];
		local targetItemIdx = _data[2];
		local targetItemOwner = _data[3];
		this.getTent().swapItems(sourceItemOwner, sourceItemIdx, targetItemOwner, targetItemIdx)
		return this.queryLoad();
	}

	function onLeaveButtonPressed()
	{
		this.m.Parent.onModuleClosed();
	}

	function onBrothersButtonPressed()
	{
		this.m.Parent.onCommanderButtonPressed();
	}


});
