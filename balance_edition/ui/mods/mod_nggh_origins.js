// OVERWRITTEN FUNCTIONS --------------------------------------------------------------------------------------------------------------------


// refresh origin pool
var ws_setStartingScenarios = NewCampaignMenuModule.prototype.setStartingScenarios
NewCampaignMenuModule.prototype.setStartingScenarios = function(_data)
{
	if (_data !== null && jQuery.isArray(_data)) {
		this.mScenarioScrollContainer.empty();
		ws_setStartingScenarios.call(this, _data);
	}
};


// show a huge red X on the slot if the slot can't be used

CharacterScreenPaperdollModule.prototype.blockThisSlot = function (_slot, _imagePath) {
  _slot.Container.assignPaperdollItemImage(Path.ITEMS + _imagePath, false, false);
  _slot.Container.assignPaperdollItemOverlayImage();
  _slot.Container.setPaperdollRepairImageVisible(false);
};

CharacterScreenPaperdollModule.prototype.assignBlockSlots = function (
  _data
) {
	if (_data[CharacterScreenIdentifier.ItemSlot.Mainhand])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.RightHand, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Offhand])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.LeftHand, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Head])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Head, _data['Icon']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Body])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Body, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Accessory])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.Accessory, _data['Icon']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Ammo])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.Ammo, _data['Icon']);
	}
};

var ws_onBrotherSelected = CharacterScreenPaperdollModule.prototype.onBrotherSelected
CharacterScreenPaperdollModule.prototype.onBrotherSelected = function (
  _dataSource,
  _brother
) {
	if (_brother !== null && CharacterScreenIdentifier.Entity.Id in _brother) {
			if ('restriction' in _brother && _brother['restriction'] !== undefined && _brother['restriction'] !== null) {
	       this.assignBlockSlots(
	        _brother['restriction']
	      );
	    }
	}

	ws_onBrotherSelected.call(this, _dataSource, _brother);
};


CharacterScreenDatasource.prototype.equipInventoryItem = function(_brotherId, _sourceItemId, _sourceItemIdx)
{
	var brotherId = _brotherId;
	if (brotherId === null)
	{
		var selectedBrother = this.getSelectedBrother();
		if (selectedBrother === null || !(CharacterScreenIdentifier.Entity.Id in selectedBrother))
		{
			console.error('ERROR: Failed to equip inventory item. No entity selected.');
			return;
		}

		brotherId = selectedBrother[CharacterScreenIdentifier.Entity.Id];
	}

	var self = this;
	this.notifyBackendEquipInventoryItem(brotherId, _sourceItemId, _sourceItemIdx, function (data)
	{
	    if (data === undefined || data == null || typeof (data) !== 'object')
	    {
	        console.error('ERROR: Failed to equip inventory item. Invalid data result.');
	        return;
	    }

	    // check if we have an error
	    if (ErrorCode.Key in data)
	    {
	        self.notifyEventListener(ErrorCode.Key, data[ErrorCode.Key]);
	    }
	    else
	    {
	        if ('stashSpaceUsed' in data)
	            self.mStashSpaceUsed = data.stashSpaceUsed;

	        if ('stashSpaceMax' in data)
	            self.mStashSpaceMax = data.stashSpaceMax;

	        self.mInventoryModule.updateSlotsLabel();

	        if (CharacterScreenIdentifier.QueryResult.Stash in data)
	        {
	            var stashData = data[CharacterScreenIdentifier.QueryResult.Stash];
	            if (stashData !== null && jQuery.isArray(stashData))
	            {
	            		if (('isForceUpdating' in data) && data['isForceUpdating'] === true)
	            		{
	                	 stashData.forceUpdate = _sourceItemIdx;
	                }
	                
	                self.updateStash(stashData);
	            }
	            else
	            {
	                console.error('ERROR: Failed to equip inventory item. Invalid stash data result.');
	            }
	        }

	        if (CharacterScreenIdentifier.QueryResult.Brother in data)
	        {
	            var brotherData = data[CharacterScreenIdentifier.QueryResult.Brother];
	            if (CharacterScreenIdentifier.Entity.Id in brotherData)
	            {
	                self.updateBrother(brotherData);
	            }
	            else
	            {
	                console.error('ERROR: Failed to equip inventory item. Invalid brother data result.');
	            }
	        }
	    }
	});
};

