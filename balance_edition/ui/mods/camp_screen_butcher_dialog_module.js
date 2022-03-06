

var ButcherScreenShop =
{
	ItemOwner:
	{
		Stash: 'camp-screen-butcher-dialog-module.stash',
		Shop: 'camp-screen-butcher-dialog-module.shop'
	},

	ItemFlag:
	{
		Inserted: 0,
		Removed: 1,
		Updated: 2
    }
};

var CampScreenButcherDialogModule = function(_parent)
{
	this.mSQHandle = null;
    this.mParent = _parent;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

    // list containers
    this.mStashListContainer = null;
    this.mStashListScrollContainer = null;
    this.mShopListContainer = null;
    this.mShopListScrollContainer = null;
    this.mProductListContainer = null;
    this.mProductScrollContainer = null;

    // assets labels
    this.mAssetValues = null;
    this.mTimeAsset = null;
    this.mBrothersAsset	= null;

    // buttons
    this.mLeaveButton = null;

    this.mStashSpaceUsed = 0;
    this.mStashSpaceMax = 0;

    // stash & found loot
    this.mStashSlots = null;
    this.mShopSlots = null;

	// lists
	this.mStashList = null;
	this.mShopList = null;

	// sort & filter
	this.mSortInventoryButton = null;
	this.mAssignAllButton = null;
    this.mRemoveAllButton = null;

    // generics
	this.mIsVisible = false;
};


CampScreenButcherDialogModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

CampScreenButcherDialogModule.prototype.onConnection = function (_handle)
{
	//if (typeof(_handle) == 'string')
	{
		this.mSQHandle = _handle;

        // notify listener
        if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
		{
            this.mEventListener.onModuleOnConnectionCalled(this);
        }
	}
};

CampScreenButcherDialogModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};


CampScreenButcherDialogModule.prototype.updateAssetValue = function (_container, _value, _valueMax, _valueDifference, _negative)
{
    var label = _container.find('.label:first');

    if(label.length > 0)
    {
        if(_valueMax !== undefined && _valueMax !== null)
		{
            label.html('' + Helper.numberWithCommas(_value) + '/' + Helper.numberWithCommas(_valueMax));
        }
        else
		{
            label.html(Helper.numberWithCommas(_value));
        }

        if(_valueDifference !== null && _valueDifference !== 0)
		{
            label.animateValueAndFadeOut(_valueDifference < 0, function (_element)
			{
                _element.html(_valueDifference);
            });
        }

        if(_value <= 0 || _negative)
		{
            label.removeClass('font-color-assets-positive-value').addClass('font-color-assets-negative-value');
        }
        else
		{
            label.removeClass('font-color-assets-negative-value').addClass('font-color-assets-positive-value');
        }
    }
};

CampScreenButcherDialogModule.prototype.updateAssets = function (_data)
{
    if(_data === undefined || _data === null || !(typeof(_data) === 'object'))
    {
        return;
    }

    var value = null;
    var previousValue = null;
    var valueDifference = null;
    var currentAssetInformation = _data;
    var previousAssetInformation = this.mAssetValues;
   
    if('Time' in currentAssetInformation && currentAssetInformation['Time'] !== null)
    {
        value = currentAssetInformation['Time'];
        valueDifference = null;
        if(previousAssetInformation !== null && 'Time' in previousAssetInformation && previousAssetInformation['Time'] !== null)
        {
            previousValue = previousAssetInformation['Time'];
            valueDifference = value - previousValue;
        }
        this.updateAssetValue(this.mTimeAsset, value, null, valueDifference);
    }

    if('Brothers' in currentAssetInformation && currentAssetInformation['Brothers'] !== null)
    {
        value = currentAssetInformation['Brothers'];
        valueDifference = null;
        if(previousAssetInformation !== null && 'Brothers' in previousAssetInformation && previousAssetInformation['Brothers'] !== null)
        {
            previousValue = previousAssetInformation['Brothers'];
            valueDifference = value - previousValue;
        }
        this.updateAssetValue(this.mBrothersAsset, value, null, valueDifference);
    }

    this.mAssetValues = currentAssetInformation;

}

CampScreenButcherDialogModule.prototype.createAssetDIV = function (_parentDiv, _imagePath, _classExtra)
{
    var layout = $('<div class="l-tab-asset"/>');
    layout.addClass(_classExtra);
    _parentDiv.append(layout);

    var image = $('<img/>');
    image.attr('src', _imagePath);
    layout.append(image);
    var text = $('<div class="label text-font-normal font-color-assets-positive-value"/>');
    layout.append(text);

    return layout;
};

CampScreenButcherDialogModule.prototype.createImageButton = function (_parentDiv, _imagePath, _callback)
{
    var layout = $('<div class="l-assets-container"/>');
    var image = $('<img/>');
    image.attr('src', _imagePath);
    layout.append(image);
    var text = $('<div class="label text-font-small font-bold font-bottom-shadow font-color-assets-positive-value"/>');
    layout.append(text);

    if (_callback === undefined)
    {
        _parentDiv.append(layout);
        return layout;
    }
    else
    {
        return _parentDiv.createCustomButton(layout, _callback, '', 2);
    }
};

CampScreenButcherDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-butcher-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('', '', '', true, 'dialog-1024-768');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);
    
	//create assets
    this.mTimeAsset = this.createAssetDIV(tabButtonsContainer, Path.GFX + 'ui/buttons/icon_time.png', 'is-time-required');
    var assetContainer = $('<div class="l-tab-asset is-brothers"></div>');
    this.mBrothersAsset = this.createImageButton(assetContainer, Path.GFX + Asset.ICON_ASSET_BROTHERS, function()
	{
        self.notifyBackendBrothersButtonPressed();
    });
    tabButtonsContainer.append(assetContainer);

    // create content
    var content = this.mDialogContainer.findDialogContentContainer();

    // create stash
    var leftColumn = $('<div class="column is-left"/>');
    content.append(leftColumn);
    var headerRow = $('<div class="row is-header title-font-normal font-bold font-color-title">Stash</div>');
    leftColumn.append(headerRow);
	var contentRow = $('<div class="row is-content"/>');
    leftColumn.append(contentRow);
    var footerRow = $('<div class="row is-footer"/>');
    leftColumn.append(footerRow);

    var listContainerLayout = $('<div class="l-list-container is-left"></div>');
    contentRow.append(listContainerLayout);
    this.mStashListContainer = listContainerLayout.createList(1.24/*8.63*/);
    this.mStashListScrollContainer = this.mStashListContainer.findListScrollContainer();

    // create middle
    var middleColumn = $('<div class="column is-middle"/>');
    content.append(middleColumn);
    contentRow = $('<div class="row is-content"/>');
    middleColumn.append(contentRow);
	var buttonContainer = $('<div class="button-container"/>');
    contentRow.append(buttonContainer);

	// sort/filter
	var layout = $('<div class="l-button is-sort"/>');
    buttonContainer.append(layout);
    this.mSortInventoryButton = layout.createImageButton(Path.GFX + Asset.BUTTON_SORT, function()
	{
        self.notifyBackendSortButtonClicked();
    }, '', 3);

	var layout = $('<div class="l-button is-assign-all"/>');
    buttonContainer.append(layout);
    this.mAssignAllButton = layout.createImageButton(Path.GFX + 'ui/buttons/arrow_right.png', function()
	{
        self.notifyBackendAssignAllButtonClicked();
    }, '', 3);

    var layout = $('<div class="l-button is-remove-all"/>');
    buttonContainer.append(layout);
    this.mRemoveAllButton = layout.createImageButton(Path.GFX + 'ui/buttons/arrow_left.png', function ()
    {
        self.notifyBackendRemoveAllButtonClicked();
    }, '', 3);

    // create shop loot
    var rightColumn = $('<div class="column is-right"/>');
    content.append(rightColumn);
    headerRow = $('<div class="row is-header title-font-normal font-bold font-color-title">Butcher</div>');
    rightColumn.append(headerRow);
    contentRow = $('<div class="row is-content"/>');
    rightColumn.append(contentRow);

    listContainerLayout = $('<div class="l-list-container is-right"></div>');
    contentRow.append(listContainerLayout);
    this.mShopListContainer = listContainerLayout.createList(1.24);
    this.mShopListScrollContainer = this.mShopListContainer.findListScrollContainer();

    // create product
    contentRow = $('<div class="row is-ingredients-container"/>');
    rightColumn.append(contentRow);
    var ingredientsHeader = $('<div class="row is-header"/>');
    contentRow.append(ingredientsHeader);
    var ingredientsHeaderLabel = $('<div class="label title-font-normal font-bold font-bottom-shadow font-color-title">Expected Result</div>');
    ingredientsHeader.append(ingredientsHeaderLabel);

    this.mProductListContainer = $('<div class="row is-components-container"/>');
    contentRow.append(this.mProductListContainer);

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Leave", function()
	{
        self.notifyBackendLeaveButtonPressed();
    }, '', 1);

    this.mIsVisible = false;

    this.setupEventHandler();
};

CampScreenButcherDialogModule.prototype.destroyDIV = function ()
{
    this.mStashSlots = null;
    this.mShopSlots = null;

    this.mStashListContainer.destroyList();
    this.mStashListScrollContainer = null;
    this.mStashListContainer = null;

    this.mShopListContainer.destroyList();
    this.mShopListScrollContainer = null;
    this.mShopListContainer = null;

    this.mTimeAsset.remove();
    this.mTimeAsset = null;
    this.mBrothersAsset.remove();
    this.mBrothersAsset = null;

    this.mLeaveButton.remove();
    this.mLeaveButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

CampScreenButcherDialogModule.prototype.setupEventHandler = function ()
{
    var self = this;

    var dropHandler = function (ev, dd)
	{
        var drag = $(dd.drag);
        var drop = $(dd.drop);

        // do the swapping
        var sourceData = drag.data('item') || {};
        var targetData = drop.data('item') || {};

        var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
        var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;

        if(sourceOwner === null || targetOwner === null)
        {
            console.error('Failed to drop item. Owner are invalid.');
            return;
        }

        var sourceItemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;
        var targetItemIdx = (targetData !== null && 'index' in targetData) ? targetData.index : null;

        if(sourceItemIdx === null)
        {
            console.error('Failed to drop item. Source idx is invalid.');
            return;
        }

        self.swapItem(sourceItemIdx, sourceOwner, targetItemIdx, targetOwner);

        if(drag.parent().length === 0)
        {
            $(dd.proxy).remove();
        }
        else
        {
            drag.removeClass('is-dragged');
        }
    };

    // create drop handler for the stash & shop container
    $.drop({ mode: 'middle' });

    this.mStashListContainer.data('item', { owner: ButcherScreenShop.ItemOwner.Stash });
    this.mStashListContainer.drop(dropHandler);

    this.mShopListContainer.data('item', { owner: ButcherScreenShop.ItemOwner.Shop });
    this.mShopListContainer.drop(dropHandler);
};


CampScreenButcherDialogModule.prototype.bindTooltips = function ()
{
    this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.ShopDialogModule.LeaveButton });

    this.mSortInventoryButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterScreen.RightPanelHeaderModule.SortButton });
    this.mAssignAllButton.bindTooltip({ contentType: 'ui-element', elementId: 'camp-screen.butcher.assignall.button' });
    this.mRemoveAllButton.bindTooltip({ contentType: 'ui-element', elementId: 'camp-screen.butcher.removeall.button' });

    this.mTimeAsset.bindTooltip({ contentType: 'ui-element', elementId:  'butcher.Time' });
    this.mBrothersAsset.bindTooltip({ contentType: 'ui-element', elementId: 'butcher.Bros' });    
};

CampScreenButcherDialogModule.prototype.unbindTooltips = function ()
{
    this.mLeaveButton.unbindTooltip();

	this.mSortInventoryButton.unbindTooltip();
    this.mAssignAllButton.unbindTooltip();
    this.mRemoveAllButton.unbindTooltip();

    this.mTimeAsset.unbindTooltip();
    this.mBrothersAsset.unbindTooltip();
};

CampScreenButcherDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

CampScreenButcherDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


CampScreenButcherDialogModule.prototype.register = function (_parentDiv)
{
    console.log('CampScreenButcherDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Town Screen Hire Dialog Module. Reason: World Town Screen Hire Dialog Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

CampScreenButcherDialogModule.prototype.unregister = function ()
{
    console.log('CampScreenButcherDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Town Screen Hire Dialog Module. Reason: World Town Screen Hire Dialog Module is not initialized.');
        return;
    }

    this.destroy();
};

CampScreenButcherDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


CampScreenButcherDialogModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


CampScreenButcherDialogModule.prototype.show = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = (_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.css({ 'left': offset });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' }, {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function () {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function () {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
    else
    {
        this.mContainer.css({ opacity: 0 });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1 }, {
            duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function() {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function() {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
};

CampScreenButcherDialogModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
	{
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            $(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        complete: function ()
        {
        	self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};

CampScreenButcherDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

CampScreenButcherDialogModule.prototype.loadFromData = function (_data)
{
    if(_data === undefined || _data === null || !(typeof(_data) === 'object'))
	{
        return;
    }

    if ('Assets' in _data)
    {
        this.updateAssets(_data.Assets);
    }

    if('Title' in _data && _data.Title !== null)
	{
		this.mDialogContainer.findDialogTitle().html(_data.Title);
	}

	if('SubTitle' in _data && _data.SubTitle !== null)
	{
		this.mDialogContainer.findDialogSubTitle().html(_data.SubTitle);
    }
    
	if('Stash' in _data && _data.Stash !== null)
	{
		this.loadStashData(_data.Stash, _data.Capacity);
	}

	if('Butcher' in _data && _data.Butcher !== null)
	{
		this.loadShopData(_data.Butcher, _data.Capacity, _data.Products);
    }

    if('Products' in _data && _data.Products !== null)
    {
        this.updateProductList(_data.Products);
    }
};

CampScreenButcherDialogModule.prototype.loadStashData = function (_data, _capacity)
{
    if(_data === undefined || _data === null || !jQuery.isArray(_data))
    {
        return;
    }

	this.mStashList = _data;

    if(this.mStashSlots === null)
    {
        this.mStashSlots = [];
    }

    // call by ref hack
    var arrayRef = { val: this.mStashSlots };
    var containerRef = { val: this.mStashListScrollContainer };

    this.assignItems(ButcherScreenShop.ItemOwner.Stash, _data, _capacity, arrayRef.val, containerRef.val);
};

CampScreenButcherDialogModule.prototype.loadShopData = function (_data, _capacity)
{
    if(_data === undefined || _data === null || !jQuery.isArray(_data))
    {
        return;
    }

	this.mShopList = _data;

    if(this.mShopSlots === null)
    {
        this.mShopSlots = [];
    }

    // call by ref hack
    var arrayRef = { val: this.mShopSlots };
    var containerRef = { val: this.mShopListScrollContainer };

    this.assignItems(ButcherScreenShop.ItemOwner.Shop, _data, _capacity, arrayRef.val, containerRef.val);
};

CampScreenButcherDialogModule.prototype.querySlotByIndex = function(_itemArray, _index)
{
    if(_itemArray === null || _itemArray.length === 0 || _index < 0 || _index >= _itemArray.length)
    {
        return null;
    }

    return _itemArray[_index];
};

CampScreenButcherDialogModule.prototype.assignItemToSlot = function(_owner, _slot, _item)
{
    var remove = false;

    if(!('id' in _item) || !('imagePath' in _item))
    {
        remove = true;
    }

    if(remove === true)
    {
        this.removeItemFromSlot(_slot);
    }
    else
    {
        // update item data
        var itemData = _slot.data('item') || {};
        itemData.id = _item.id;
        _slot.data('item', itemData);

        // assign image
        _slot.assignListItemImage(Path.ITEMS + _item.imagePath);
        _slot.assignListItemOverlayImage(_item['imageOverlayPath']);

        // show amount
        if(_item.showAmount === true && _item.amount != '')
        {
			_slot.assignListItemAmount('' + _item.amount, _item['amountColor']);
        }

        // show price
        if('price' in _item && _item.price !== null)
        {
            _slot.assignListItemPrice(_item.price);
        }

        // bind tooltip
        _slot.assignListItemTooltip(itemData.id, 'character-screen-inventory-list-module.stash');
    }
};

CampScreenButcherDialogModule.prototype.assignItems = function (_owner, _items, _capacity, _itemArray, _itemContainer)
{
    this.destroyItemSlots(_itemArray, _itemContainer);
    this.createItemSlots(_owner, _capacity, _itemArray, _itemContainer);
    if(_items.length > 0)
    {
        for(var i = 0; i < _items.length; ++i)
        {
            // ignore empty slots
            if(_items[i] !== undefined && _items[i] !== null)
            {
                this.assignItemToSlot(_owner, _itemArray[i], _items[i]);
            }
        }
    }
};

CampScreenButcherDialogModule.prototype.clearItemSlots = function (_itemArray)
{
    if(_itemArray === null || _itemArray.length === 0)
    {
        return;
    }

    for(var i = 0; i < _itemArray.length; ++i)
    {
        // remove item image
        this.removeItemFromSlot(_itemArray[i]);
    }
};

CampScreenButcherDialogModule.prototype.removeItemFromSlot = function(_slot)
{
    // remove item image
	_slot.assignListItemImage();
    _slot.assignListItemOverlayImage();
	_slot.assignListItemTooltip();
};

CampScreenButcherDialogModule.prototype.createItemSlots = function (_owner, _size, _itemArray, _itemContainer)
{
    var screen = $('.camp-screen');
    for(var i = 0; i < _size; ++i)
    {
        _itemArray.push(this.createItemSlot(_owner, i, _itemContainer, screen));
    }
};

CampScreenButcherDialogModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
{
    var self = this;

    var result = _parentDiv.createListItem(true);
    result.attr('id', 'slot-index_' + _index);

    // update item data
    var itemData = result.data('item') || {};
    itemData.index = _index;
    itemData.owner = _owner;
    result.data('item', itemData);

    // add event handler
    var dropHandler = function (_source, _target)
	{
        var sourceData = _source.data('item');
        var targetData = _target.data('item');

        var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
        var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;

        if(sourceOwner === null || targetOwner === null)
        {
            console.error('Failed to drop item. Owner are invalid.');
            return;
        }

        var sourceItemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;
        var targetItemIdx = (targetData !== null && 'index' in targetData) ? targetData.index : null;

        if(sourceItemIdx === null)
        {
            console.error('Failed to drop item. Source idx is invalid.');
            return;
        }

        self.swapItem(sourceItemIdx, sourceOwner, targetItemIdx, targetOwner);
    };

    var dragEndHandler = function (_source, _target)
	{
        if(_source.length === 0 || _target.length === 0)
        {
            return false;
        }

        var sourceData = _source.data('item');
        var targetData = _target.data('item');

        var sourceOwner = (sourceData !== null && 'owner' in sourceData) ? sourceData.owner : null;
        var targetOwner = (targetData !== null && 'owner' in targetData) ? targetData.owner : null;
        var itemIdx = (sourceData !== null && 'index' in sourceData) ? sourceData.index : null;

        if(sourceOwner === null || targetOwner === null)
        {
            console.error('Failed to drop item. Owner is invalid.');
            return false;
        }

        return true;
    };

    result.assignListItemDragAndDrop(_screenDiv, null, dragEndHandler, dropHandler);

    result.assignListItemRightClick(function (_item, _event)
	{
        var data = _item.data('item');
        var isEmpty = (data !== null && 'isEmpty' in data) ? data.isEmpty : true;
        var owner = (data !== null && 'owner' in data) ? data.owner : null;
        var itemIdx = (data !== null && 'index' in data) ? data.index : null;

        if(isEmpty === false && owner !== null && itemIdx !== null)
        {
            switch(owner)
            {
                case ButcherScreenShop.ItemOwner.Stash:
                    self.swapItem(itemIdx, owner, null, ButcherScreenShop.ItemOwner.Shop);
                    break;
                case ButcherScreenShop.ItemOwner.Shop:
                    self.swapItem(itemIdx, owner, null, ButcherScreenShop.ItemOwner.Stash);
                    break;
            }
        }
    });

    return result;
};

CampScreenButcherDialogModule.prototype.swapItem = function (_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner)
{
    var self = this;
    this.notifyBackendSwapItem(_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner, function (data)
    {
        if (data === undefined || data == null || typeof (data) !== 'object')
        {
            console.error("ERROR: Failed to swap item. Reason: Invalid data result.");
            return;
        }

        if ('Assets' in data)
        {
            self.updateAssets(data.Assets);
        }

        if ('Stash' in data)
        {
            self.updateStashList(data.Stash, data.Capacity);
        }

        if ('Butcher' in data)
        {
            self.updateShopList(data.Butcher, data.Capacity, data);
        }
    });
};

CampScreenButcherDialogModule.prototype.updateSlotItem = function (_owner, _itemArray, _item, _index, _flag)
{
    var slot = this.querySlotByIndex(_itemArray, _index);
    if(slot === null)
    {
        console.error('ERROR: Failed to update slot item: Reason: Invalid slot index: ' + _index);
        return;
    }

    switch(_flag)
    {
        case ButcherScreenShop.ItemFlag.Inserted:
        case ButcherScreenShop.ItemFlag.Updated:
        {
            this.removeItemFromSlot(slot);
            this.assignItemToSlot(_owner, slot, _item);
			break;
        }
        case ButcherScreenShop.ItemFlag.Removed:
        {
            this.removeItemFromSlot(slot);
			break;
        } 
    }
};

CampScreenButcherDialogModule.prototype.updateStashList = function (_data, _capacity)
{
    if(this.mStashList === null || !jQuery.isArray(this.mStashList) || this.mStashList.length === 0)
    {
        this.loadStashData(_data, _capacity);
        return;
    }

    // check stash for changes
    for(var i = 0; i < this.mStashList.length; ++i)
    {
        var sourceItem = this.mStashList[i];
        var targetItem = _data[i];

        // item added to stash slot
        if(sourceItem === null && targetItem !== null)
        {
            if('id' in targetItem)
            {
                this.mStashList[i] = targetItem;
				this.updateSlotItem(ButcherScreenShop.ItemOwner.Stash, this.mStashSlots, targetItem, i, ButcherScreenShop.ItemFlag.Inserted);
            }
        }

        // item removed from stash slot
        else if(sourceItem !== null && targetItem === null)
        {
            this.mStashList[i] = targetItem;
			this.updateSlotItem(ButcherScreenShop.ItemOwner.Stash, this.mStashSlots, targetItem, i, ButcherScreenShop.ItemFlag.Removed);
        }

        // item might have changed within stash slot
        else
        {
            if((sourceItem !== null && targetItem !== null) && ('id' in sourceItem && 'id' in targetItem) && (sourceItem.id !== targetItem.id))
            {
                this.mStashList[i] = targetItem;
				this.updateSlotItem(ButcherScreenShop.ItemOwner.Stash, this.mStashSlots, targetItem, i, ButcherScreenShop.ItemFlag.Updated);
            }
        }
    }
};

CampScreenButcherDialogModule.prototype.updateShopList = function (_data, _capacity, _origin)
{
    if(this.mShopList === null || !jQuery.isArray(this.mShopList) || this.mShopList.length === 0)
    {
		this.loadShopData(_data, _capacity);
        return;
    }

	// create more slots?
	if(_data.length > this.mShopSlots.length)
	{
		this.createItemSlots(ButcherScreenShop.ItemOwner.Shop, _data.length - this.mShopSlots.length, this.mShopSlots, this.mShopListScrollContainer);
	}

    // check shop for changes
	var maxLength = this.mShopList.length >= _data.length ? this.mShopList.length : _data.length;

    for(var i = 0; i < maxLength; ++i)
    {
        var oldItem = this.mShopList[i];
        var newItem = _data[i];

        // item added to shop slot
        if(i >= this.mShopList.length || (oldItem === null && newItem !== null))
        {
			this.updateSlotItem(ButcherScreenShop.ItemOwner.Shop, this.mShopSlots, newItem, i, ButcherScreenShop.ItemFlag.Inserted);
        }

        // item removed from shop slot
        else if(i >= _data.length || (oldItem !== null && newItem === null))
        {
			this.updateSlotItem(ButcherScreenShop.ItemOwner.Shop, this.mShopSlots, oldItem, i, ButcherScreenShop.ItemFlag.Removed);
        }

        // item might have changed within shop slot
        else
        {
            if((oldItem !== null && newItem !== null) && ('id' in oldItem && 'id' in newItem))
            {
				if(oldItem.id !== newItem.id)
				{
					this.updateSlotItem(ButcherScreenShop.ItemOwner.Shop, this.mShopSlots, newItem, i, ButcherScreenShop.ItemFlag.Updated);
				}
            }			
        }
    }

	// update list
	this.mShopList = _data;

    if ('Products' in _origin)
    {
        this.updateProductList(_origin.Products);
    }
};

CampScreenButcherDialogModule.prototype.updateProductList = function( _data )
{
    this.mProductListContainer.empty();
    for(var i = 0; i < _data.length; ++i)
    {
        if (i === 12)
        {
            break;
        }

        var iconContainer = $('<div class="icons-container"/>');
        this.mProductListContainer.append(iconContainer);
        var icon = $('<img src="' + Path.ITEMS + _data[i].ImagePath + '"/>');
        icon.bindTooltip({ contentType: 'ui-item', itemId: _data[i].InstanceID, entityId: null, itemOwner: 'butcher_database' });

        var amountLayer =$('<div class="amount-layer display-block"/>');
        iconContainer.append(amountLayer);
        var amountLabel = $('<div class="label text-font-very-small font-shadow-outline font-size-15 font-color-assets-positive-value"/>');
        amountLayer.append(amountLabel);
        amountLabel.text(_data[i].Min + "-" + _data[i].Max);
        amountLabel.css({'color' : "#ffffff"});
        iconContainer.append(icon);
    }
};

CampScreenButcherDialogModule.prototype.destroyItemSlots = function (_itemArray, _itemContainer)
{
    this.clearItemSlots(_itemArray);

    _itemContainer.empty();
    _itemArray.length = 0;
};

CampScreenButcherDialogModule.prototype.notifyBackendModuleShown = function ()
{
    SQ.call(this.mSQHandle, 'onModuleShown');
};

CampScreenButcherDialogModule.prototype.notifyBackendModuleHidden = function ()
{
    SQ.call(this.mSQHandle, 'onModuleHidden');
};

CampScreenButcherDialogModule.prototype.notifyBackendModuleAnimating = function ()
{
    SQ.call(this.mSQHandle, 'onModuleAnimating');
};

CampScreenButcherDialogModule.prototype.notifyBackendLeaveButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
};

CampScreenButcherDialogModule.prototype.notifyBackendSortButtonClicked = function () 
{
    SQ.call(this.mSQHandle, 'onSortButtonClicked');
}

CampScreenButcherDialogModule.prototype.notifyBackendFilterAllButtonClicked = function ()
{
	SQ.call(this.mSQHandle, 'onFilterAll');
};

CampScreenButcherDialogModule.prototype.notifyBackendAssignAllButtonClicked = function ()
{
	SQ.call(this.mSQHandle, 'onAssignAll');
};

CampScreenButcherDialogModule.prototype.notifyBackendRemoveAllButtonClicked = function ()
{
    SQ.call(this.mSQHandle, 'onRemoveAll');
};

CampScreenButcherDialogModule.prototype.notifyBackendBrothersButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onBrothersButtonPressed');
};

CampScreenButcherDialogModule.prototype.notifyBackendSwapItem = function (_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner, _callback)
{
    SQ.call(this.mSQHandle, 'onSwapItem', [_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner], _callback);
};



//registerScreen("CampScreenButcherDialogModule", new CampScreenButcherDialogModule());

var onDisconnection = CampScreen.prototype.onDisconnection;
CampScreen.prototype.onDisconnection = function ()
{
    this.mButcherDialogModule.onDisconnection();
    onDisconnection.call(this);
};

var onModuleOnConnectionCalled = CampScreen.prototype.onModuleOnConnectionCalled;
CampScreen.prototype.onModuleOnConnectionCalled = function (_module)
{
    if (this.mButcherDialogModule !== null && this.mButcherDialogModule.isConnected())
    {
        onModuleOnConnectionCalled.call(this);
    }
};

var onModuleOnDisconnectionCalled = CampScreen.prototype.onModuleOnDisconnectionCalled;
CampScreen.prototype.onModuleOnDisconnectionCalled = function (_module)
{
    if (this.mButcherDialogModule !== null && !this.mButcherDialogModule.isConnected())
    {
        onModuleOnDisconnectionCalled.call(this);
    }
};

var unregisterModules = CampScreen.prototype.unregisterModules;
//unregisterModules.call(CampScreen);
CampScreen.prototype.unregisterModules = function ()
{
    this.mButcherDialogModule.unregister();
    unregisterModules.call(this);
};

var createModules = CampScreen.prototype.createModules;
CampScreen.prototype.createModules = function()
{
    var self = this;
    createModules.call(this);

    if (!('mButcherDialogModule' in self))
    {
        self.mButcherDialogModule = null;
        this.mButcherDialogModule = new CampScreenButcherDialogModule(this);
    }
};
createModules.call(CampScreen);

var registerModules = CampScreen.prototype.registerModules;
registerModules.call(CampScreen);
CampScreen.prototype.registerModules = function ()
{
    var self = this;

    if (!('mButcherDialogModule' in self))
    {
        self.mButcherDialogModule = null;
        this.mButcherDialogModule = new CampScreenButcherDialogModule(this);
    }

    this.mButcherDialogModule.register(this.mContainer);
    registerModules.call(this);
};

var getModule = CampScreen.prototype.getModule;
CampScreen.prototype.getModule = function (_name)
{
    if (_name === 'CampButcherDialogModule') {
        return this.mButcherDialogModule;
    }

    var result = getModule.call(this, _name);
    return result;
};

var getModules = CampScreen.prototype.getModules;
CampScreen.prototype.getModules = function ()
{
    var result = getModules.call(this);
    result.push({name: 'CampButcherDialogModule', module: this.mButcherDialogModule});
    return result;
};

CampScreen.prototype.showButcherDialog = function (_data)
{
    var _withSlideAnimation = true;

    this.mContainer.addClass('display-block').removeClass('display-none');

    if (this.mActiveModule != null)
        this.mActiveModule.hide(_withSlideAnimation);
    else
        this.mMainDialogModule.hide();

    this.mActiveModule = this.mButcherDialogModule;

    if (_data !== undefined && _data !== null && typeof (_data) === 'object')
    {
        this.loadAssetData(_data.Assets);
        this.mButcherDialogModule.loadFromData(_data);
    }

    this.mButcherDialogModule.show(_withSlideAnimation);
};


$.fn.setRepairImageVisible = function(_isVisible, _isSalvage)
{
    var imageLayer = this.find('.repair-layer:first');
    var iconLayer = this.find('.repair-layer:first > img');

    if (typeof _isSalvage === 'boolean')
    {
        if (imageLayer.length > 0)
        {
            if (_isSalvage)
            {
                iconLayer.attr('src', Path.GFX + 'ui/icons/salvage_item.png');
            }
            else
            {
                iconLayer.attr('src', Path.GFX + Asset.ICON_REPAIR_ITEM);
            }
            if(_isVisible || _isSalvage)
            {
                imageLayer.removeClass('display-none');
                imageLayer.addClass('display-block');
            }
            else
            {
                imageLayer.addClass('display-none');
                imageLayer.removeClass('display-block');
            }
        }
    }
    else
    {
        if (imageLayer.length > 0)
        {
            if (_isSalvage === 1)
            {
                iconLayer.attr('src', Path.GFX + 'ui/icons/salvage_item.png');
            }
            else
            {
                iconLayer.attr('src', Path.GFX + 'ui/icons/cursor_bandages.png');
            }
            if(_isVisible || _isSalvage === 1)
            {
                imageLayer.removeClass('display-none');
                imageLayer.addClass('display-block');
            }
            else
            {
                imageLayer.addClass('display-none');
                imageLayer.removeClass('display-block');
            }
        }
    }
};