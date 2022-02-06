this.butcher_building <- this.inherit("scripts/entity/world/camp/camp_building", {
	m = {
        Stash = null,
        Butcher = null,
        Products = null,
        Database = null,
        Capacity = 0,
        PointsNeeded = 0,
        PointsButchered = 0,
        ItemsButchered = 0,
        Items = [],
	},

    function create()
    {
        this.camp_building.create();
        this.m.ID = this.Const.World.CampBuildings.Butcher;
        this.m.BaseCraft = 21.0;
        this.m.ModName = "Butcher";
        this.m.Escorting = true;
        this.m.Slot = "butcher";
        this.m.Name = "Butcher Tent";
        this.m.Description = "Turn the remains of enemy into usable products";
        this.m.BannerImage = "ui/buttons/banner_butcher.png";
        this.m.Database = this.new("scripts/items/stash_container");
        this.m.Database.setID("butcher_camp");
        this.m.Database.setResizable(true);
    }

	function getTitle()
	{
		if (this.getUpgraded())
		{
			return this.m.Name + " *Upgraded*"
		}
		return this.m.Name +  " *Not Upgraded*"
	}

	function getDescription()
	{
		local desc = "";
		desc += "Butchering corpses in your stash in a linear fashion, so "
		desc += "order in the queue has significance. "
		desc += "The more people assigned to the tent, the quicker products will be produced. Corpses will only be butchered when camped."
		desc += "\n\n"
        desc += "If no brothers are assigned to the butcher tent or your stash has no spare slot, the process is stopped. "
        desc += "\n\n"
		return desc;
	}

	function getModifierToolip()
    {
		this.init();
		local mod = this.getModifiers();
		local ret = [
			{
				id = 3,
				type = "text",
				icon = "ui/icons/plus.png",
				text = "There are [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Butcher.len() + "[/color] items in the butcher queue."
			},
			{
				id = 4,
				type = "text",
				icon = "ui/buttons/icon_time.png",
				text = "It will take [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getRequiredTime() + "[/color] hours to butcher all items in the queue."
			}
		];
		return ret;
	}

	function getUpgraded()
	{
        return this.Stash.hasItem("tent.butcher_tent");
	}

	function getLevel()
    {
        if (this.getUpgraded())
        {
            return "tent"
        }

        return "empty";
    }

    function getUIImage( _terrain )
    {
        local day = this.World.getTime().IsDaytime ? "day" : "night";
        return "ui/settlements/00_" + this.getSlot() + "_" + this.getLevel() + "_" + day;
    }

    function init()
    {
        this.onInit();
        this.m.PointsNeeded = 0;
        this.m.PointsButchered = 0;
        this.m.Items = [];

        foreach (i, r in this.m.Butcher)
        {
            if (r == null)
            {
                continue;
            }

            this.m.PointsNeeded += r.Item.getCondition() - r.Item.getConditionHasBeenProcessed();
        }
    }

    function onInit()
    {
        local items = this.getListOfItemsNeedingButcher()
        this.m.Stash = items.Stash;
        this.m.Butcher = items.Items;
        this.m.Products = items.Products;
        local capacity =  this.m.Butcher.len() + this.m.Stash.len();
        this.m.Capacity = capacity;
        while (this.m.Stash.len() < capacity)
        {
            this.m.Stash.push(null);
        }

        while (this.m.Butcher.len() < capacity)
        {
            this.m.Butcher.push(null);
        }
    }

    function getStash()
    {
        return this.m.Stash;
    }

    function getButcher()
    {
        return this.m.Butcher;
    }

    function getProducts()
    {
        return this.updateProducts();
    }

    function getCapacity()
    {
        return this.m.Capacity;
    }

    function getResults()
    {
        local res = []
        local id = 60;
       
        foreach (b in this.m.Items)
        {
            if (b == null) {
                this.logWarning("Null item attempted in gatherer building, the length of items arr is " + this.m.Items.len())
                continue;
            }
            res.push({
                id = id,
                icon = "ui/items/" + b.getIcon(),
                text = "You gained " + b.getName()
            })
            ++id;
        }
        return res;
    }


    function getModifiers()
    {
        local ret = {
            Consumption = 1.0,
            Craft = 0.0,
            Assigned = 0,
            Modifiers = []
        };
        local ModMod = this.m.ModMod;
        local isButcher = [
            "background.female_butcher",
            "background.butcher",
            "background.hunter",
            "background.legend_cannibal",
            "background.legend_preserver",
        ];
        local knowToCook = [
            "background.barbarian",
            "background.beast_slayer",
            "background.eunuch",
            "background.female_servant",
            "background.legend_necro",
            "background.legend_commander_necro",
            "background.legend_necromancer",
            "background.legend_warlock",
            "background.poacher",
            "background.servant",
            "background.wildman",
            "background.wildwoman"
        ];

        if (this.getUpgraded())
        {
            ModMod *= 1.25;
        }

        local roster = this.World.getPlayerRoster().getAll();

        foreach( bro in roster )
        {
            if (bro.getCampAssignment() != this.m.ID)
            {
                continue;
            }

            local mod = this.m.BaseCraft;

            if (isButcher.find(bro.getBackground().getID()) != null)
            {
                mod += this.m.BaseCraft * ModMod * 0.6;
            }
            else if (knowToCook.find(bro.getBackground().getID()) != null)
            {
                mod += this.m.BaseCraft * ModMod * 0.25;
            }

            ++ret.Assigned;
            ret.Modifiers.push([mod, bro.getNameOnly(), bro.getBackground().getNameOnly()]);
        }

        ret.Modifiers.sort(this.sortModifiers);
        for (local i = 0; i < ret.Modifiers.len(); i = ++i)
        {
            ret.Modifiers[i][0] = ret.Modifiers[i][0] * this.Math.pow(i + 1, -0.5);
            ret.Craft += ret.Modifiers[i][0];
        }

        ret.Craft += this.m.BaseCraft;
        ret.Craft *= this.World.Assets.m.HitpointsPerHourMult;

        if (this.getUpgraded())
        {
            ret.Craft *= 1.25;
        }

        return ret;
    }

    function getRequiredTime()
    {
        local points = 0;
        if (this.m.Butcher == null)
        {
            return 0;
        }

        foreach (i, r in this.m.Butcher)
        {
            if (r == null)
            {
                continue;
            }

            if (r.Item.getCondition() > r.Item.getConditionHasBeenProcessed())

            points += r.Item.getCondition() - r.Item.getConditionHasBeenProcessed();
        }
        local modifiers = this.getModifiers();
        return this.Math.ceil(points / modifiers.Craft);
    }

    function getAssignedBros()
    {
        local mod = this.getModifiers();
        return mod.Assigned;
    }

	function getResourceImage()
	{
		return "ui/buttons/icon_time.png";
	}

	function getResourceCount()
	{
		return this.getRequiredTime();
	}

	function getUpdateText()
	{
        if (this.m.PointsNeeded == 0)
        {
            return "No butcher queued";
        }

		local percent = this.Math.floor((this.m.PointsButchered / this.m.PointsNeeded) * 10000) / 100.0;
		if (percent >= 100)
		{
			return "Butchered ... 100%";
		}

        return "Butchered ... " + percent + "%";
	}

    function update ()
    {
        if (this.m.Butcher == null)
		{
			this.init();
		}

        if (this.m.Butcher.len() == 0)
        {
            return this.getUpdateText();
        }

        local stash = this.World.Assets.getStash();

        if (!stash.hasEmptySlot()) 
        {
            return this.getUpdateText();
        }

        local modifiers = this.getModifiers();
		modifiers.Craft = this.Math.round(modifiers.Craft);
        local butcher_products = [];
		
        foreach (i, r in this.m.Butcher)
        {
            if (r == null)
            {
                continue;
            }

            local mod = r.Item.getConditionMax() >= 500 ? 0.67 : 1.0;
            local needed = this.Math.floor(r.Item.getCondition() - r.Item.getConditionHasBeenProcessed());
            if (modifiers.Craft < needed)
            {
                needed = modifiers.Craft;
            }

            r.Item.setProcessedCondition(r.Item.getConditionHasBeenProcessed() + needed);
            this.m.PointsButchered += needed;
            modifiers.Craft -= this.Math.floor(needed * mod);

            if (r.Item.getConditionHasBeenProcessed() >= r.Item.getCondition())
            {
                local products =  r.Item.onButchered();
                r.Item.setGarbage();
                this.m.Butcher[i] = null;
                this.m.ItemsButchered += 1;
                if (products.len() > 0) butcher_products.extend(products);
            }

            if (modifiers.Craft <= 0)
            {
                break;
            }
        }

        stash.collectGarbage();
        local emptySlots = stash.getNumberOfEmptySlots();

        foreach (p in butcher_products)
        {
            if (--emptySlots >= 0)
            {
                stash.add(p);
                this.m.Items.push(p);
            }
        }

        return this.getUpdateText();
    }

    function sortButcherQueue( _f1, _f2 )
	{
		if (_f1.Item.isToBeButcheredQ() > _f2.Item.isToBeButcheredQ())
		{
			return 1;
		}
		else if (_f1.Item.isToBeButcheredQ() < _f2.Item.isToBeButcheredQ())
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}

    function getListOfItemsNeedingButcher()
    {
        local items = [];
        local stash = [];
        local products = [];
       
        local stashItems = this.Stash.getItems();
        foreach( item in stashItems)
        {
            if (item == null)
            {
                continue;
            }

            if (!item.isItemType(this.Const.Items.ItemType.Corpse))
            {
                continue;
            }

            if (item.isToBeButchered())
            {
                items.push({
                    Bro = null,
                    Item = item
                });
                
                this.addProducts(item.getExpectedItemAfterButchered(), products);
            }
            else
            {
                stash.push({
                    Bro = null,
                    Item = item
                });
            }
        }
        items.sort(this.sortButcherQueue);
        return {Items = items, Stash = stash, Products = products};
    }

    function updateProducts()
    {
        this.m.Products = [];

        foreach( r in this.m.Butcher)
        {
            if (r == null)
            {
                continue;
            }

            this.addProducts(r.Item.getExpectedItemAfterButchered(), this.m.Products);
        }

        return this.m.Products;
    }

    function addProducts( _productArray, _target)
    {
        foreach (p in _productArray)
        {
            if (!this.m.Database.hasItem(p.InstanceID))
            {
                this.m.Database.add(p.Item);
            }
            else
            {
                delete p.Item;
            }

            local hasThisProduct = false;

            foreach (_p in _target)
            {
                if (_p.InstanceID == p.InstanceID)
                {
                    _p.Max += p.Max;
                    _p.Min += p.Min;
                    hasThisProduct = true;
                }
            }

            if (!hasThisProduct)
            {
                _target.push(p);
            }
        }
    }

    function assignAll( _filter = 0 )
    {
        if (_filter == 0)
		{
			_filter = this.Const.Items.ItemFilter.All;
		}

        local index = 0
        foreach (i, s in this.m.Stash)
        {
            if (s == null)
            {
                continue
            }

            if (_filter == 99 && s.Bro != null)
            {
                continue;
            }
            else if ((s.Item.getItemType() & _filter) == 0)
            {
                continue;
            }

            for (index; index < this.m.Butcher.len(); index = ++index)
            {
                if (this.m.Butcher[index] == null)
                {
                    break;
                }
            }

            s.Item.setToBeButchered(true, index);
            if (index >= this.m.Butcher.len())
            {
                this.m.Butcher.push(s);
            }
            else
            {
                this.m.Butcher[index] = s;
            }
            s.Item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag)
            this.m.Stash[i] = null;
        }
    }

    function removeAll()
    {
        local index = 0;
        foreach (i, s in this.m.Butcher)
        {
            if (s == null)
            {
                continue
            }

            for (index; index < this.m.Butcher.len(); index = ++index)
            {
                if (this.m.Stash[index] == null)
                {
                    break;
                }
            }

            s.Item.setToBeButchered(false, 0);
            if (index >= this.m.Stash.len())
            {
                this.m.Stash.push(s);
            }
            else
            {
                this.m.Stash[index] = s;
            }
            s.Item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag)
            this.m.Butcher[i] = null;
        }
    }

	function swapItems( sourceItemOwner, sourceItemIdx, targetItemOwner, targetItemIdx )
	{
		if (targetItemOwner == null)
		{
			this.logError("onSwapItem #1");
			return false;
		}

        if (sourceItemOwner == targetItemOwner && sourceItemIdx == targetItemIdx)
        {
            return false;
        }

        local sourceList = null;
        local targetList = null;
        local isButcher = false
		switch(sourceItemOwner)
		{
		case "camp-screen-butcher-dialog-module.stash":
            sourceList = this.m.Stash
            if (sourceItemOwner == targetItemOwner)
            {
                targetList = this.m.Stash;
            }
            else
            {
                targetList = this.m.Butcher;
                isButcher = true;
            }
            break;

		case "camp-screen-butcher-dialog-module.shop":
            sourceList = this.m.Butcher
            if (sourceItemOwner == targetItemOwner)
            {
                targetList = this.m.Butcher;
                isButcher = true
            }
            else
            {
                targetList = this.m.Stash;
            }
            break;
        }

        local sourceItem = sourceList[sourceItemIdx];

        if (sourceItem == null)
        {
            this.logError("onSwapItem(stash) #2");
            return false;
        }

        //We've picked a spot to drop it
        if (targetItemIdx != null)
        {
            //Make sure array is big enough for target spot
            while (targetItemIdx > targetList.len() - 1)
            {
                targetList.push(null)
            }
            sourceList[sourceItemIdx] = targetList[targetItemIdx];
            targetList[targetItemIdx] = sourceItem;
            sourceItem.Item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag)
            local index = 0
            if (isRepair)
            {
                index = targetItemIdx
            }
            sourceItem.Item.setToBeButchered(isButcher, index);
            return true;
        }

        //didn't pick a spot to drop, find the first null spot
        foreach (i,r in targetList)
        {
            if (r != null)
            {
                continue
            }
            targetList[i] = sourceItem;
            sourceList[sourceItemIdx] = null;
            sourceItem.Item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag)
            local index = 0
            if (isButcher)
            {
                index = i
            }
            sourceItem.Item.setToBeButchered(isButcher, index);
            return true;
        }

        //No null spot, push to the end
        targetList.push(sourceItem);
        sourceList[sourceItemIdx] = null;
        sourceItem.Item.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag)
        local index = 0
        if (isButcher)
        {
            index = targetList.len() - 1
        }
        sourceItem.Item.setToBeButchered(isButcher, index);
        return true;
	}

	function onClicked( _campScreen )
	{
        _campScreen.showButcherDialog();
        this.camp_building.onClicked(_campScreen);
	}

	function onSerialize( _out )
	{
		this.camp_building.onSerialize(_out);
        this.m.Database.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.camp_building.onDeserialize(_in);
        this.m.Database.onDeserialize(_in);
	}

    function getSortedRoster()
    {
        local brothers = this.World.getPlayerRoster().getAll();
        local roster = [];
        local isButcher = [
            "background.female_butcher",
            "background.butcher",
            "background.hunter",
            "background.legend_cannibal",
            "background.legend_preserver",
        ];
        local knowToCook = [
            "background.barbarian",
            "background.beast_slayer",
            "background.eunuch",
            "background.female_servant",
            "background.legend_necro",
            "background.legend_commander_necro",
            "background.legend_necromancer",
            "background.legend_warlock",
            "background.poacher",
            "background.servant",
            "background.wildman",
            "background.wildwoman"
        ];

        foreach( b in brothers )
        {
            if (!this.onBroEnter(b))
            {
                continue
            }
            local bro = this.UIDataHelper.convertEntityToUIData(b, null);
            local tent = this.World.Camp.getBuildingByID(b.getCampAssignment());
            bro.bannerImage <- tent.getBanner();
            bro.IsSelected <- b.getCampAssignment() == this.m.ID;
            local modifier = 0;

            if (isButcher.find(b.getBackground().getID()) != null)
            {
                modifier += 1.5;
            }
            else (knowToCook.find(b.getBackground().getID()) != null)
            {
                modifier += 1.0;
            }

            bro.Modifier <- modifier;
            roster.push(bro);
        }

        roster.sort(this.onSortByModifier);
        return roster;
    }

});