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

CharacterScreenPaperdollModule.prototype.blockThisSlot = function (_slot) {
  _slot.Container.assignPaperdollItemImage(_slot.BlockedImage, false, false);
  _slot.Container.assignPaperdollItemOverlayImage();
  _slot.Container.setPaperdollRepairImageVisible(false);
};

CharacterScreenPaperdollModule.prototype.assignBlockSlots = function (
  _data
) {
	if (_data[CharacterScreenIdentifier.ItemSlot.Mainhand])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.RightHand);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Offhand])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.LeftHand);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Head])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Head);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Body])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Body);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Accessory])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.Accessory);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Ammo])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.Ammo);
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

	ws_onBrotherSelected.call(this, [_dataSource, _brother]);
};

